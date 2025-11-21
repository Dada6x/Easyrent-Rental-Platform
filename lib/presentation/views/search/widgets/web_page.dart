import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:get/get.dart';

class StripeWebPage extends StatefulWidget {
  const StripeWebPage({super.key});

  @override
  _StripeWebPageState createState() => _StripeWebPageState();
}

class _StripeWebPageState extends State<StripeWebPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            if (url
                .contains("https://dashboard.stripe.com/register/payments")) {
              Get.snackbar("Success", "Your payment was completed!");
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(
          'https://buy.stripe.com')); // <-- Replace with your Stripe Checkout URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: WebViewWidget(controller: _controller),
    );
  }
}
