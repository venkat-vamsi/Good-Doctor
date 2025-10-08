import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Heart extends StatefulWidget {
  const Heart({super.key});

  @override
  State<Heart> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<Heart> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted) // Enable JavaScript
      ..loadRequest(Uri.parse(
          'https://ibmaws.streamlit.app/')); // Replace with your local server URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panic Attack Detector'),
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
