import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:square_mobile_commerce_sdk/apple_pay.dart';
import 'package:square_mobile_commerce_sdk/google_pay.dart';
import 'package:square_mobile_commerce_sdk/models.dart';
import 'package:square_mobile_commerce_sdk/square_mobile_commerce_sdk.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _paymentInitialized = false;

  @override
  void initState() {
    super.initState();
    _initSquarePayment();
  }

  Future<void> _initSquarePayment() async {
    await InAppPayments.setSquareApplicationId('sq0idp-aDbtFl--b2VU5pcqQD7wmg');
    if(Theme.of(context).platform == TargetPlatform.android) {
      await GooglePay.initializeGooglePay(GooglePay.googlePayEnvTestKey);
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      var canUseApplePay = await ApplePay.canUseApplePay;
      if (canUseApplePay) {
        await ApplePay.initializeApplePay('merchant.com.mcomm.flutter');
      }
    }

    setState(() {
      _paymentInitialized = true;
    });
  }

  Future<bool> _checkout(CardDetails result) async => true;

  void _onCardEntryComplete() {
    print('entry is closed');
  }

  void _onCardEntryGetCardDetails(CardDetails result) async {
    print(result);
    var success = await _checkout(result);
    if (!success) {
      await InAppPayments.showCardProcessingError('failed to checkout.');
    } else {
      await InAppPayments.completeCardEntry(_onCardEntryComplete);
    }
  }

  void _onCardEntryCancel() async {
    print('card entry flow is canceled.');
  }

  Future<void> _onStartCardEntryFlow() async {
    try {
      await InAppPayments.startCardEntryFlow(_onCardEntryGetCardDetails, _onCardEntryCancel);
    } on PlatformException {
      print('Failed to startCardEntryFlow.');
    }
  }

  void _onStartGooglePay() async {
    try {
      var merchantId = '0ZXKWWD1CB2T6';
      var price = '100';
      var currencyCode = 'USD';
      await GooglePay.requestGooglePayNonce(
        merchantId, price, currencyCode, _onGooglePayDidSucceedWithResult, _onGooglePayFailed, _onGooglePayCancel);
    } on PlatformException catch(ex) {
       print('Failed to onStartGooglePay. \n ${ex.toString()}');
    }
  }

  void _onGooglePayDidSucceedWithResult(CardDetails result) {
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
      await ApplePay.requestApplePayNonce(price, summaryLabel, countryCode, currencyCode, _onApplePayNonceRequestSuccess, _onApplePayNonceRequestFailure, _onApplePayComplete);
    } on PlatformException catch(ex) {
       print('Failed to onStartApplePay. \n ${ex.toString()}');
    }
  }

  void _onApplePayNonceRequestSuccess(CardDetails result) async {
    print(result);
    var success = await _checkout(result);
    if (success) {
      await ApplePay.completeApplePayAuthorization(isSuccess: true);
    } else {
      await ApplePay.completeApplePayAuthorization(isSuccess: false, errorMessage: "failed to charge amount.");
    }
  } 

  void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    print('ApplePay failed. \n ${errorInfo.toString()}');
    await ApplePay.completeApplePayAuthorization(isSuccess: false);
  }

  void _onApplePayComplete() {
    print('ApplePay closed');
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
