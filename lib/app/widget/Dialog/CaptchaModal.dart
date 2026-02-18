import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import '../../data/service/APIService.dart';

class CaptchaModal extends StatefulWidget {
  final String siteKey;
  final Function(String token) onSuccess;
  final VoidCallback? onError;
  final VoidCallback? onCancel;

  const CaptchaModal({
    Key? key,
    required this.siteKey,
    required this.onSuccess,
    this.onError,
    this.onCancel,
  }) : super(key: key);

  @override
  State<CaptchaModal> createState() => _CaptchaModalState();
}

class _CaptchaModalState extends State<CaptchaModal> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _error = null;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _error = error.description ?? 'Gagal memuat halaman verifikasi';
            });
            print('WebView Error: ${error.description}');
            print('Error Code: ${error.errorCode}');
            print('Error Type: ${error.errorType}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'CaptchaChannel',
        onMessageReceived: (JavaScriptMessage message) {
          final token = message.message;
          if (token.isNotEmpty) {
            Navigator.of(context).pop(token);
            widget.onSuccess(token);
          }
        },
      )
      ..loadRequest(
        // Load from backend endpoint instead of data URI to fix domain authorization
        // This ensures the page is served from a proper domain (develop.transgo.id or api.transgo.id)
        // that can be added to Cloudflare Turnstile's allowed domains
        Uri.parse('${baseUrl.replaceAll('/api/v1', '')}/api/v1/auth/captcha?siteKey=${Uri.encodeComponent(widget.siteKey)}'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.security, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Verifikasi Keamanan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      widget.onCancel?.call();
                      Navigator.of(context).pop();
                    },
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
            // WebView Content
            Expanded(
              child: _error != null
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red.shade300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Gagal memuat verifikasi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _error ?? 'Terjadi kesalahan',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _error = null;
                              });
                              _initializeWebView();
                            },
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    )
                  : Stack(
                      children: [
                        if (_controller != null)
                          WebViewWidget(controller: _controller!),
                        if (_isLoading)
                          Container(
                            color: Colors.white,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      ],
                    ),
            ),
            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                'Verifikasi ini membantu melindungi akun Anda',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
