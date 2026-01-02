import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../widget/General/text.dart';

class LapentorSection extends StatefulWidget {
  final String? url;
  final String title;
  final String? description;

  const LapentorSection({
    super.key,
    this.url,
    this.description,
    this.title = 'Tampilan 3D Lokasi',
  });

  @override
  State<LapentorSection> createState() => _LapentorSectionState();
}

class _LapentorSectionState extends State<LapentorSection> {
  WebViewController? controller;
  bool hasError = false;

  bool get hasValidUrl =>
      widget.url != null &&
      widget.url!.isNotEmpty &&
      Uri.tryParse(widget.url!)?.hasAbsolutePath == true;

  @override
  void initState() {
    super.initState();
    if (hasValidUrl) {
      controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onWebResourceError: (_) {
              setState(() => hasError = true);
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final showWebView = hasValidUrl && !hasError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gabaritoText(
          text: widget.title,
        ),
        if (widget.description != null) ...[
          gabaritoText(
            text: widget.description!,
            fontSize: 13,
          ),
        ],
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 260,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.grey.shade100,
            ),
            child: showWebView
                ? WebViewWidget(controller: controller!)
                : const Center(
                    child: gabaritoText(
                      text: 'TransgoVers tidak tersedia untuk produk ini',
                      fontSize: 14,
                      textColor: Colors.grey,
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
