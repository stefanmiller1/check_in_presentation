import 'package:flutter/material.dart';

void presentALertDialogMobile(BuildContext context, String title, String description, String donButton, {required Function() didSelectDone}) {
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
                title: Text(title),
                content: Text(description),
                actions: [
                  InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Text('Canacel')
                  ),
                  InkWell(
                      onTap: () => didSelectDone(),
                      child: Text(donButton)
                  ),
                ]
            )
    );

}