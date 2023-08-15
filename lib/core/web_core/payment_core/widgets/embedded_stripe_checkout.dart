import 'package:flutter/material.dart';

class EmbeddedStripeCheckoutForm extends StatelessWidget {

  final String client_secret;
  final Function() didCompleteCheckout;
  final Function() didNotCompleteSuccessfully;

  const EmbeddedStripeCheckoutForm({super.key, required this.client_secret, required this.didCompleteCheckout, required this.didNotCompleteSuccessfully});

  @override
  Widget build(BuildContext context) {
    print('oh im not web....');
      return Container(
        child: Text('hmm...'),
      );
  }
}