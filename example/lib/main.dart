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
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/google_pay_constants.dart' as google_pay_constants;
import 'package:flutter/material.dart';
import 'buy_screen.dart';
import 'process_payment.dart';

void main() => runApp(MaterialApp(
   title: 'Super Cookie',
   home: HomeScreen(),
 ));

class HomeScreen extends StatelessWidget {
  HomeScreen() {
    _initSquareInAppPayments();
  }

  void _initSquareInAppPayments() async {
    InAppPayments.setSquareApplicationId('sq0idp-yqrzNS_5RBpkYBdxCT3tIQ');
    if(Platform.isAndroid) {
      await InAppPayments.initializeGooglePay('7270VTEWZABAJ', google_pay_constants.environmentTest);
      // Android's theme is set in /android/app/src/main/res/themes.xml
    } else if (Platform.isIOS) {
      await _setIOSCardEntryTheme();
      await InAppPayments.initializeApplePay('merchant.com.mcomm.flutter');
    }
  }

  Future _setIOSCardEntryTheme() async {
    var themeConfiguationBuilder = IOSThemeBuilder();
    themeConfiguationBuilder.saveButtonTitle = 'Pay';

    await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
  }

  _navigateToBuyScreen(BuildContext context) async {
    var result = await Navigator.push(context, PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (context, _, __) => BuyScreen()
                        ));
    print(result);
    if (result) {
      ProcessPayment.showSuccess(context);
    }
  }

  Widget build(BuildContext context) => 
    MaterialApp(
      theme: ThemeData(
        canvasColor: Color(0xFF78CCC5)
      ),
      home: Scaffold(
        body: Center(
          child: FittedBox(child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: Image(image: AssetImage("assets/iconCookie.png")),
              ),
              FittedBox(
                child:
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
              ),
              FittedBox(
                child:
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
              ),
              FittedBox(
                child:
                Container(
                  height: 64,
                  width: 170,
                  child:
                    RaisedButton(
                      child: 
                        Text(
                          "Buy",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18
                          )
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                        color: Color(0xFF24988D),
                        onPressed: (){
                          _navigateToBuyScreen(context);
                        },
                    ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
}