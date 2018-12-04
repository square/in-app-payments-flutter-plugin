import 'dart:async';
import 'package:flutter/material.dart';

Future<void> showAlertDialog(BuildContext context, String title, String description) =>
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) =>
      AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child:
              Text(description),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      )
  );
