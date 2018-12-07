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
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/google_pay_constants.dart' as google_pay_constants;
import 'package:flutter/material.dart';
import 'button_widget.dart';
import 'order_sheet.dart';


const String squareApplicationId = "REPLACE_ME";
const String squareLocationId = "REPLACE_ME";
const String appleMerchantToken = "REPLACE_ME";

void main() => runApp(MaterialApp(
   title: 'Super Cookie',
   home: HomeScreen(),
 ));

 class HomeScreen extends StatefulWidget {
   HomeScreenState createState() => HomeScreenState();
 }

class HomeScreenState extends State<HomeScreen> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  VoidCallback _showBottomSheetCallback;

  @override
  void initState() {
    super.initState();
    _showBottomSheetCallback = _showBottomSheet;
    _initSquareInAppPayments();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
  }

  void _showBottomSheet() {
    setState(() { // disable the button
      _showBottomSheetCallback = null;
    });

    scaffoldKey.currentState.showBottomSheet<bool>((context) {
      return OrderSheet();
    })
    .closed.whenComplete(() {
      if (mounted) {
        setState(() { // re-enable the button
          _showBottomSheetCallback = _showBottomSheet;
        });
      }
    });
  }

  void _initSquareInAppPayments() async {
    InAppPayments.setSquareApplicationId(squareApplicationId);
    if(Platform.isAndroid) {
      await InAppPayments.initializeGooglePay(squareLocationId, google_pay_constants.environmentTest);
      // Android's theme is set in /android/app/src/main/res/themes.xml
    } else if (Platform.isIOS) {
      await _setIOSCardEntryTheme();
      await InAppPayments.initializeApplePay(appleMerchantToken);
    }
  }

  Future _setIOSCardEntryTheme() async {
    var themeConfiguationBuilder = IOSThemeBuilder();
    themeConfiguationBuilder.saveButtonTitle = 'Pay';

    await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
  }

  Widget build(BuildContext context) => 
    MaterialApp(
      theme: ThemeData(
        canvasColor: Colors.transparent
      ),
      home: Scaffold(
        backgroundColor: Color(0xFF78CCC5),
        key: scaffoldKey,
        body: Builder(builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Image(image: AssetImage("assets/iconCookie.png")),
              ),
              Container(
                height: 50,
                child:
                  Text(
                    'Super Cookie',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                    ),
                  ),
              ),
              Container(
                height: 70,
                child:
                  Text(
                    "Instantly gain special powers \nwhen ordering a super cookie",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                ),
              ),
              createGreenButton("Buy", _showBottomSheetCallback)
            ],
          )),
        ),
      ),
    );
}