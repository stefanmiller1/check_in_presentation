import 'package:check_in_presentation/check_in_presentation.dart';
import 'package:flutter/material.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

class NewPaymentMethodWidget extends StatefulWidget {

  final UserProfileModel profile;
  final DashboardModel model;
  final Function(String token) didSaveNewPaymentMethod;

  const NewPaymentMethodWidget({super.key, required this.model, required this.didSaveNewPaymentMethod, required this.profile});

  @override
  State<NewPaymentMethodWidget> createState() => _NewPaymentMethodWidgetState();

}

class _NewPaymentMethodWidgetState extends State<NewPaymentMethodWidget> {

  late html.DivElement _divElement;
  html.IFrameElement? _iFrameElement;

  @override
  void initState() {
    super.initState();

    _iFrameElement = html.IFrameElement();

    _iFrameElement!.style.overflow = 'hidden';
    _iFrameElement!.height = '400';
    _iFrameElement!.width = '500';

    _iFrameElement!.src = 'assets/html/payment_method.html';

    _iFrameElement!.style.border = 'none';
    _iFrameElement!.style.width = '100%';
    _iFrameElement!.style.height = '100%';


    _divElement = html.DivElement()
      ..append(_iFrameElement!);

    // Listen for messages from the iframe
    html.window.onMessage.listen((event) {
      print('se;lllected');
      print(event.data);
      if (event.data['type'] == 'paymentToken') {
        String tokenId = event.data['tokenId'];

        widget.didSaveNewPaymentMethod(tokenId);
        Navigator.of(context).pop();
        // Handle the token ID
      }
    });


    ui.platformViewRegistry.registerViewFactory(
      'iframeElement',
          (int viewId) => _iFrameElement!,
    );
  }

  @override
  void dispose() {
    _iFrameElement?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: TextStyle(color: widget.model.paletteColor, fontSize: widget.model.secondaryQuestionTitleFontSize, fontWeight: FontWeight.bold),
        elevation: 0,
        title: Text('New Payment Method'),
      ),
      body: HtmlElementView(
        viewType: 'iframeElement',
        onPlatformViewCreated: (int viewId) {
          html.document.getElementById('iframeElement')?.append(_divElement);
        },
      ),
    );
  }
}
