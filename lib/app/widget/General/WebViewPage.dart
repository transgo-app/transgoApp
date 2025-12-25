

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:transgomobileapp/app/data/data.dart';

class WebViewPage extends StatefulWidget {
  final String pdfUrl;
  final String invoice;
  const WebViewPage({super.key, required this.pdfUrl, required this.invoice});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.invoice,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      body: Stack(
        children: [
          SfPdfViewer.network(
            "https://${widget.pdfUrl}",
            key: _pdfViewerKey,
            onDocumentLoaded: (details) {
              setState(() {
                isLoading = false;
              });
            },
            onDocumentLoadFailed: (error) {
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Gagal memuat PDF: ${error.description}')),
              );
            },
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
