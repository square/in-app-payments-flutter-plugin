import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:square_mobile_commerce_sdk/models.dart';
import 'package:square_mobile_commerce_sdk/square_mobile_commerce_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _paymentInitialized = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _initSquarePayment();
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

  Future<void> _initSquarePayment() async {
    await SquareMobileCommerceSdkFlutterPlugin.setApplicationId('sq0idp-aDbtFl--b2VU5pcqQD7wmg');
    if(Theme.of(context).platform == TargetPlatform.android) {
      await SquareMobileCommerceSdkFlutterPlugin.initializeGooglePay(SquareMobileCommerceSdkFlutterPlugin.googlePayEnvTestKey);
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      await SquareMobileCommerceSdkFlutterPlugin.initializeApplePay('merchant.com.mcomm.flutter');
    }

    setState(() {
      _paymentInitialized = true;
    });
  }

  void _onCardEntryDidSucceedWithResult(CardResult result) async {
    print(result);
    await SquareMobileCommerceSdkFlutterPlugin.closeCardEntryForm();
  }

  void _onCardEntryCancel() async {
    print('card entry flow is canceled.');
    await SquareMobileCommerceSdkFlutterPlugin.closeCardEntryForm();
  }

  Future<void> _onStartCardEntryFlow() async {
    try {
      await SquareMobileCommerceSdkFlutterPlugin.startCardEntryFlow(_onCardEntryDidSucceedWithResult, _onCardEntryCancel);
    } on PlatformException {
      print('Failed to startCardEntryFlow.');
    }
  }

  void _onStartGooglePay() async {
    try {
      var merchantId = '0ZXKWWD1CB2T6';
      var price = '100';
      var currencyCode = 'USD';
      await SquareMobileCommerceSdkFlutterPlugin.requestGooglePayNonce(
        merchantId, price, currencyCode, _onGooglePayDidSucceedWithResult, _onGooglePayCancel, _onGooglePayFailed);
    } on PlatformException catch(ex) {
       print('Failed to onStartGooglePay. \n ${ex.toString()}');
    }
  }

  void _onGooglePayDidSucceedWithResult(CardResult result) {
      print(result);
  }

  void _onGooglePayCancel() {
    print('GooglePay is canceled');
  }

  void _onGooglePayFailed(ErrorInfo errorInfo) {
    print('GooglePay failed. \n ${errorInfo.toString()}');
  }

  void _onStartApplePay() async {
    try {
      var summaryLabel = 'Flutter Test';
      var price = '100';
      var countryCode = 'US';
      var currencyCode = 'USD';
      await SquareMobileCommerceSdkFlutterPlugin.requestApplePayNonce(price, summaryLabel, countryCode, currencyCode, _onApplePayDidSucceedWithResult, _onApplePayFailed);
    } on PlatformException catch(ex) {
       print('Failed to onStartApplePay. \n ${ex.toString()}');
    }
  }

  void _onApplePayDidSucceedWithResult(CardResult result) async {
    print(result);
    await SquareMobileCommerceSdkFlutterPlugin.completeApplePayAuthorization();
  }

  void _onApplePayFailed(ErrorInfo errorInfo) async {
    print('ApplePay failed. \n ${errorInfo.toString()}');
    await SquareMobileCommerceSdkFlutterPlugin.completeApplePayAuthorization();
  }

  @override
  Widget build(BuildContext context) => 
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text('Running on: $_platformVersion\n'),
              RaisedButton(
                onPressed: _paymentInitialized ? _onStartCardEntryFlow : null,
                child: Text('Start Checkout'),
              ),
              RaisedButton(
                onPressed: _paymentInitialized ? 
                  (Theme.of(context).platform == TargetPlatform.iOS) ? _onStartApplePay : _onStartGooglePay
                  : null,
                child: Text((Theme.of(context).platform == TargetPlatform.iOS) ? 'pay with ApplePay' : 'pay with GooglePay'),
              ),
            ],
          ), 
        ),
      ),
    );
}
