import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TrackingOrderWebview extends StatefulWidget {
  final String url; // URL yang akan dibuka

  const TrackingOrderWebview({Key? key, required this.url}) : super(key: key);

  @override
  _TrackingOrderWebviewState createState() => _TrackingOrderWebviewState();
}

class _TrackingOrderWebviewState extends State<TrackingOrderWebview> {
  late WebViewController _controller;
  bool _isLoading = true; // Status untuk menandakan apakah halaman masih loading

  @override
  void initState() {
    super.initState();

    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar (opsional, jika ingin menampilkan progres loading)
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true; // Halaman mulai dimuat
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false; // Halaman selesai dimuat
            });
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Tracking Order'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _controller,
          ),
          _isLoading // Jika halaman masih loading, tampilkan loading spinner
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink(), // Jika halaman sudah selesai dimuat, sembunyikan loading spinner
        ],
      ),
    );
  }
}
