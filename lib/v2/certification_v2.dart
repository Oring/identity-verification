import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

class CertificationV2 extends StatelessWidget {
  const CertificationV2({super.key});

  @override
  Widget build(BuildContext context) {
    var uuid = const Uuid();
    var request = '''
PortOne.requestIdentityVerification({
  storeId: 'store-aa6d5a55-df32-42d8-8d98-ca6efefb2b76',
  identityVerificationId: `identity-verification-${uuid.v4()}`,
  channelKey: 'channel-key-29eae0b1-a323-4cec-99d2-1c02d4b3b025',
  redirectUrl: 'portone://complete',
})
''';

    var controller = WebViewController();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('webviewChannel',
          onMessageReceived: (JavaScriptMessage message) {
        // print('받은 메시지: ${message.message}');
        // print('메시지 타입: ${message.message.runtimeType}');

        // final decodedMessage = jsonDecode(message.message);
        // print('디코딩된 메시지: $decodedMessage');
        // print('디코딩된 메시지 타입: ${decodedMessage.runtimeType}');

        Navigator.pushReplacementNamed(
          context,
          '/certification-result-v2',
          arguments: jsonDecode(message.message), // Map<String, dynamic> 그대로 전달
        );
      })
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (String url) {
          if (url.startsWith('file:')) {
            controller.runJavaScript(
                '$request.catch((err) => webviewChannel.postMessage(err.message));');
          }
        },
        onNavigationRequest: (NavigationRequest request) {
          var colon = request.url.indexOf(':');
          var protocol = request.url.substring(0, colon);
          switch (protocol) {
            case 'file':
            case 'http':
            case 'https':
              return NavigationDecision.navigate;
            case 'portone':
              var question = request.url.indexOf('?');
              var searchParams = request.url.substring(question);
              controller.runJavaScript(
                  'webviewChannel.postMessage(JSON.stringify(Object.fromEntries(new URLSearchParams("$searchParams").entries())));');
              return NavigationDecision.prevent;
            case 'intent':
              var firstHash = request.url.indexOf('#');
              String? scheme;
              for (var param
                  in request.url.substring(firstHash + 1).split(';')) {
                var keyValue = param.split('=');
                if (keyValue.elementAtOrNull(0) == 'scheme') {
                  scheme = keyValue[1];
                  break;
                }
              }
              var redirect = '$scheme${request.url.substring(colon)}';
              launchUrlString(redirect);
              return NavigationDecision.prevent;
            default:
              launchUrlString(request.url);
              return NavigationDecision.prevent;
          }
        },
      ))
      ..loadFlutterAsset('assets/delegate.html');

    return Scaffold(
      appBar: AppBar(
        title: const Text('본인인증 v2'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (await controller.canGoBack()) {
            await controller.goBack();
          } else {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              var state = Navigator.of(context);
              if (state.canPop()) state.pop();
            });
          }
        },
        child: SafeArea(
          child: WebViewWidget(controller: controller),
        ),
      ),
    );
  }
}
