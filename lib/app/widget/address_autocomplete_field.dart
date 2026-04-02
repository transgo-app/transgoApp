import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:transgomobileapp/app/data/globalvariables.dart';
import 'package:transgomobileapp/app/data/service/places_api_service.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:transgomobileapp/app/widget/General/textfieldcomponent.dart';

/// Address search with backend Places proxy when logged in; plain field when guest.
/// [onResolvedCoords] / [onClearCoords] optional for reuse outside form sewa (e.g. saved address form).
class AddressAutocompleteField extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final void Function(double lat, double lng)? onResolvedCoords;
  final VoidCallback? onClearCoords;

  const AddressAutocompleteField({
    super.key,
    required this.controller,
    this.title = 'Tuliskan alamat lengkap ya!',
    this.onResolvedCoords,
    this.onClearCoords,
  });

  @override
  State<AddressAutocompleteField> createState() =>
      _AddressAutocompleteFieldState();
}

class _AddressAutocompleteFieldState extends State<AddressAutocompleteField> {
  final PlacesApiService _places = PlacesApiService();
  late final String _sessionToken;
  Timer? _debounce;
  List<PlacePrediction> _suggestions = [];
  bool _loading = false;
  String? _resolvingPlaceId;
  String? _lastResolvedText;
  final FocusNode _focusNode = FocusNode();
  bool _suppressListener = false;

  bool get _loggedIn => GlobalVariables.token.value.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _sessionToken =
        '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(1 << 31)}';
    widget.controller.addListener(_onControllerText);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(_onControllerText);
    _focusNode.dispose();
    super.dispose();
  }

  void _onControllerText() {
    if (_suppressListener) return;
    final text = widget.controller.text;
    if (text != _lastResolvedText) {
      widget.onClearCoords?.call();
    }
    if (!_loggedIn) return;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _fetch(text));
  }

  Future<void> _fetch(String input) async {
    if (!mounted) return;
    if (input.trim().length < 2) {
      setState(() => _suggestions = []);
      return;
    }
    setState(() => _loading = true);
    try {
      final list =
          await _places.autocomplete(input, sessionToken: _sessionToken);
      if (!mounted) return;
      setState(() {
        _suggestions = list;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _suggestions = [];
        _loading = false;
      });
    }
  }

  Future<void> _select(PlacePrediction p) async {
    setState(() {
      _resolvingPlaceId = p.placeId;
      _loading = true;
    });
    try {
      final d = await _places.details(p.placeId, sessionToken: _sessionToken);
      if (!mounted) return;
      final line =
          d.formattedAddress.isNotEmpty ? d.formattedAddress : p.description;
      _suppressListener = true;
      widget.controller.text = line;
      _lastResolvedText = line;
      _suppressListener = false;
      widget.onResolvedCoords?.call(d.lat, d.lng);
      setState(() {
        _suggestions = [];
        _loading = false;
        _resolvingPlaceId = null;
      });
      _focusNode.unfocus();
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _resolvingPlaceId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loggedIn) {
      return reusableTextField(
        title: widget.title,
        maxLines: 3,
        controller: widget.controller,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 14,
            color: textHeadline,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          focusNode: _focusNode,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Cari alamat (pilih saran untuk koordinat)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
        ),
        if (_loading && _suggestions.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        if (_suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            constraints: const BoxConstraints(maxHeight: 240),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header: "Saran Alamat"
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.navigation_rounded,
                          size: 12,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'SARAN ALAMAT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade500,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Suggestions list
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _suggestions.length,
                      itemBuilder: (ctx, i) {
                        final s = _suggestions[i];
                        final isBusy = _resolvingPlaceId == s.placeId;
                        return InkWell(
                          onTap: () => _select(s),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: i < _suggestions.length - 1
                                  ? Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.shade100,
                                        width: 1,
                                      ),
                                    )
                                  : null,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon box
                                Container(
                                  margin: const EdgeInsets.only(top: 1),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: isBusy
                                      ? SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: primaryColor,
                                          ),
                                        )
                                      : Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: Colors.grey.shade500,
                                        ),
                                ),
                                const SizedBox(width: 12),
                                // Address text
                                Expanded(
                                  child: Text(
                                    s.description,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Google attribution footer
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'powered by ',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          'Google',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
