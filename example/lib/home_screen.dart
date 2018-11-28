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
import 'process_payment.dart';

void main() => runApp(MaterialApp(
    title: 'Navigation Basics',
    home: HomeScreen(),
  ));

class HomeScreen extends StatefulWidget {
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  ProcessPayment processPayment;

  @override
  void initState() {
    super.initState();
    processPayment = ProcessPayment(context);
  }

  Widget build(BuildContext context) => 
    MaterialApp(
      theme: ThemeData(
        canvasColor: Color(0xFF78CCC5)
      ),
      home: Scaffold(
        body: Center(
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
                    onPressed: (){
                      showModalBottomSheet<void>(context: context,
                        builder: (context) {
                          return Container(
                            alignment: Alignment(1.0, 1.0),
                            color: Colors.transparent,
                            child:
                              Container(
                                  height: 500,
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft:  const  Radius.circular(20.0),
                                                topRight: const  Radius.circular(20.0))
                                        ),
                                  child:
                                    Column(
                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                      // mainAxisSize: MainAxisSize.max,
                                      // mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: (){
                                          processPayment.paymentInitialized ? processPayment.onStartCardEntryFlow() : null;
                                        },
                                        child: Text('Start Checkout'),
                                      ),
                                      RaisedButton(
                                        onPressed: (){
                                          processPayment.paymentInitialized && (processPayment.applePayEnabled || processPayment.googlePayEnabled) ? 
                                          (Theme.of(context).platform == TargetPlatform.iOS) ? processPayment.onStartApplePay : processPayment.onStartGooglePay
                                          : null;
                                        },
                                        child: Text((Theme.of(context).platform == TargetPlatform.iOS) ? 'pay with ApplePay' : 'pay with GooglePay'),
                                      ),
                                    ],
                                  ), 
                              ),
                          );
                      });
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    color: Color(0xFF24988D),
                    // borderSide: BorderSide(style: BorderStyle.none),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
}