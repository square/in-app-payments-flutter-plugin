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


  void showSuccess(BuildContext context) {
    showAlertDialog(context, "Your order was successful", 
      "Go to your Square dashbord to see this order reflected in the sales tab.");
  }

   void showError(BuildContext context, String errorMessage) {
    showAlertDialog(context, "Error occurred", errorMessage);
  }