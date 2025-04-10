import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Solicita permissões antes de iniciar o app
  await Permission.camera.request();
  await Permission.microphone.request();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewExample(),
    );
  }
}

class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  InAppWebViewController? webViewController;

  final String url = "https://app.hml.zapsign.com.br/verificar/d8bc4d26-ffad-40ad-b59b-f94978f05b27";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Zapsign WebView")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          mediaPlaybackRequiresUserGesture: false,
          allowsInlineMediaPlayback: true,
          allowFileAccess: true,
          allowContentAccess: true,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;

          // Injeta JavaScript para impedir a remoção de "capture"
          controller.evaluateJavascript(source: '''
            const originalRemoveAttr = HTMLInputElement.prototype.removeAttribute;
            HTMLInputElement.prototype.removeAttribute = function(attr) {
              if (attr !== 'capture') {
                originalRemoveAttr.call(this, attr);
              }
            };
          ''');
        },
        onPermissionRequest: (controller, request) async {
          return PermissionResponse(
            resources: request.resources,
            action: PermissionResponseAction.GRANT,
          );
        },
      ),
    );
  }
}
