import 'dart:convert';
import 'dart:html';
import 'dart:ui_web' as ui;
import 'package:check_in_credentials/check_in_credentials.dart';
import 'package:check_in_domain/check_in_domain.dart';
import 'package:flutter/cupertino.dart';


class EmbeddedStripeCheckoutForm extends StatefulWidget {

  final String client_secret;
  final Function() didCompleteCheckout;
  final Function() didNotCompleteSuccessfully;

  const EmbeddedStripeCheckoutForm({Key? key, required this.client_secret, required this.didCompleteCheckout, required this.didNotCompleteSuccessfully}) : super(key: key);

  @override
  State<EmbeddedStripeCheckoutForm> createState() => _EmbeddedStripeCheckoutFormState();

}

class _EmbeddedStripeCheckoutFormState extends State<EmbeddedStripeCheckoutForm> {

  // String _uniqueFrame = UniqueId().getOrCrash();
  final String _uniqueFrame = 'qwdqwd';
  IFrameElement? _iFrameElement;


  @override
  void initState() {
    super.initState();

    _iFrameElement = IFrameElement();

    _iFrameElement!.style.overflow = 'hidden';
    _iFrameElement!.height = '550';
    _iFrameElement!.width = '550';

    _iFrameElement!.src = 'assets/html/checkout.html';

    _iFrameElement!.style.border = 'none';
    _iFrameElement!.style.width = '100%';
    _iFrameElement!.style.height = '100%';

    _iFrameElement!.onLoad.listen((event) {
      window.onMessage.listen((event) {
        if (event.data == null) {
          return;
        }
      });

      final data = {
        'data': widget.client_secret
      };
      final jsonString = jsonEncode(data);

      window.postMessage(jsonString, '*');

      window.addEventListener('message', (event) {
        final data = (event as MessageEvent).data ?? '-';

        print('data? $data');
        if (data == 'success') {
          widget.didCompleteCheckout();
        } else if (data != widget.client_secret) {
          // widget.didNotCompleteSuccessfully();
        }
      });
    });


    ui.platformViewRegistry.registerViewFactory(
          widget.client_secret,
          (int viewId) => _iFrameElement!,
    );
  }


  String htmlForEmbeddedMap() {
    return 'assets/html/checkout.html';
  }

  @override
  void dispose() {
    _iFrameElement?.remove();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    if (_iFrameElement!.src != htmlForEmbeddedMap()) {
      _iFrameElement!.src = htmlForEmbeddedMap();
    }

   return HtmlElementView(
     viewType: widget.client_secret,
   );
  }
}
