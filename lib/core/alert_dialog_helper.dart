import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void presentALertDialogMobile(BuildContext context, String title, String description, String donButton, {required Function() didSelectDone}) {
  if (!Platform.isIOS) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
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

  showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(description),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text(donButton),
            onPressed: () {
              Navigator.of(context).pop();
              didSelectDone();
            },
          ),
        ]
      )
  );

}