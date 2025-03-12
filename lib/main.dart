import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  InAppWebViewController? webViewController;
  String url = "https://app.hml.zapsign.com.br/verificar/d8bc4d26-ffad-40ad-b59b-f94978f05b27";
  TextEditingController urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    urlController.text = url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("InAppWebView Example"),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                supportZoom: false,
              ),

              initialUrlRequest: URLRequest(url: WebUri(url)),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}