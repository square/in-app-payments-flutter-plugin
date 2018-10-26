import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:square_mobile_commerce_sdk/square_mobile_commerce_sdk.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _paymentInitialized = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initSquarePayment();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await SquareMobileCommerceSdkFlutterPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> initSquarePayment() async {
    await SquareMobileCommerceSdkFlutterPlugin.setApplicationId('sq0idp-aDbtFl--b2VU5pcqQD7wmg');
    if(Theme.of(context).platform == TargetPlatform.android) {
      await SquareMobileCommerceSdkFlutterPlugin.initializeGooglePay(SquareMobileCommerceSdkFlutterPlugin.GOOGLE_PAY_ENV_TEST);
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      await SquareMobileCommerceSdkFlutterPlugin.initializeApplePay('merchant.com.mcomm.flutter');
    }

    setState(() {
      _paymentInitialized = true;
    });
  }

  void onCardEntryDidSucceedWithResult(Map result) async {
    print(result);
    await SquareMobileCommerceSdkFlutterPlugin.closeCardEntryForm();
  }

  void onCardEntryCancel() async {
    await SquareMobileCommerceSdkFlutterPlugin.closeCardEntryForm();
  }

  Future<void> onStartCardEntryFlow() async {
    try {
      await SquareMobileCommerceSdkFlutterPlugin.startCardEntryFlow(this.onCardEntryDidSucceedWithResult, this.onCardEntryCancel);
    } on PlatformException {
      print('Failed to startCardEntryFlow.');
    }
  }

  Future<void> onStartGooglePay() async {
    try {
      String merchantId = '0ZXKWWD1CB2T6';
      String price = '100';
      String currencyCode = 'USD';
      Map result = await SquareMobileCommerceSdkFlutterPlugin.payWithGooglePay(merchantId, price, currencyCode);
      print(result.toString());
    } on PlatformException {
       print('Failed to onStartGooglePay.');
    }
  }
  
  Future<void> onStartApplePay() async {
    try {
      String summaryLabel = 'Flutter Test';
      String price = '100';
      String countryCode = 'US';
      String currencyCode = 'USD';
      Map result = await SquareMobileCommerceSdkFlutterPlugin.payWithApplePay(price, summaryLabel, countryCode, currencyCode);
      print(result.toString());
    } on PlatformException {
       print('Failed to onStartApplePay.');
    }
  }

  Future<void> onStartEWalletPay() async {
    String result;
    try {
      result = await SquareMobileCommerceSdkFlutterPlugin.payWithEWallet();
    } on PlatformException {
      result = 'Failed to payWithEWallet';
    }

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              RaisedButton(
                onPressed: _paymentInitialized ? onStartCardEntryFlow : null,
                child: Text('Start Checkout'),
              ),
              RaisedButton(
                onPressed: _paymentInitialized ? 
                  (Theme.of(context).platform == TargetPlatform.iOS) ? onStartApplePay : onStartGooglePay
                  : null,
                child: Text((Theme.of(context).platform == TargetPlatform.iOS) ? 'pay with ApplePay' : 'pay with GooglePay'),
              ),
            ],
          ), 
        ),
      ),
    );
  }
}
