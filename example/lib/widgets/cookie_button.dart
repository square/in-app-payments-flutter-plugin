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
import 'package:flutter/material.dart';
import '../colors.dart';

class CookieButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  CookieButton({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) => Container(
      height: 64,
      width: MediaQuery.of(context).size.width * .4,
      child: RaisedButton(
          child:
              FittedBox(child:Text(text, style: TextStyle(color: Colors.white, fontSize: 18))),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          color: mainButtonColor,
          onPressed: onPressed));
}
