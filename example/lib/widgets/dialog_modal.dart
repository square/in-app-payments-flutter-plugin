/*
 Copyright 2018 Square Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:square_in_app_payments_example/colors.dart';

Future<void> showAlertDialog({
  required BuildContext context,
  required String title,
  required String description,
  required bool status,
}) => showDialog<void>(
  context: context,
  barrierDismissible: true,
  builder: (context) => AlertDialog(
    title: Column(
      children: [
        Image(
          height: 50,
          width: 50,
          image: status
              ? AssetImage("assets/sucessIcon.png")
              : AssetImage("assets/failIcon.png"),
          color: status ? mainButtonColor : Colors.red,
        ),
        SizedBox(height: 15),
        Text(title, textAlign: TextAlign.center),
      ],
    ),
    content: SingleChildScrollView(
      child: Column(
        children: [
          Text(
            description,
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
    actions: <Widget>[],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
    ),
  ),
);
