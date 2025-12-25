import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleMapsEmbedPage extends StatefulWidget {
  final String iframeUrl;

  const GoogleMapsEmbedPage({Key? key, required this.iframeUrl})
      : super(key: key);

  @override
  _GoogleMapsEmbedPageState createState() => _GoogleMapsEmbedPageState();
}

class _GoogleMapsEmbedPageState extends State<GoogleMapsEmbedPage>
    with AutomaticKeepAliveClientMixin {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    String getHtml(String url) {
      final modifiedUrl = Uri.parse(url).replace(queryParameters: {
        ...Uri.parse(url).queryParameters,
        'gestureHandling': 'none',
      }).toString();

      return '''
      <!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
          body {
            margin: 0;
            padding: 0;
            overflow: hidden;
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #f9f9f9;
          }
          iframe {
            width: 100%;
            height: 100%;
            border: 1px solid #ccc;
            border-radius: 10px;
            pointer-events: none;
          }
        </style>
      </head>
      <body>
        <iframe
          src="$modifiedUrl"
          frameborder="0"
          style="border: 0; border-radius: 10px;"
          allowfullscreen
          scrolling="no">
        </iframe>
      </body>
      </html>
      ''';
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..loadHtmlString(getHtml(widget.iframeUrl));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WebViewWidget(controller: _controller);
  }

  @override
  bool get wantKeepAlive => true; 
}

