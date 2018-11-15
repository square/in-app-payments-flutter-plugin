import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _paymentInitialized = false;
  bool _applePayEnabled = false;
  bool _googlePayEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSquarePayment();
  }

  Future<void> _initSquarePayment() async {
    await InAppPayments.setSquareApplicationId('sq0idp-aDbtFl--b2VU5pcqQD7wmg');
    var canUseApplePay = false;
    var canUseGooglePay = false;
    if(Theme.of(context).platform == TargetPlatform.android) {
      await InAppPayments.initializeGooglePay('0ZXKWWD1CB2T6', GooglePayEnvironment.test);
      canUseGooglePay = await InAppPayments.canUseGooglePay;
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      await InAppPayments.initializeApplePay('merchant.com.mcomm.flutter');
      canUseApplePay = await InAppPayments.canUseApplePay;
    }

    setState(() {
      _paymentInitialized = true;
      _applePayEnabled = canUseApplePay;
      _googlePayEnabled = canUseGooglePay;
    });
  }

  Future<bool> _checkout(CardDetails result) async => true;

  void _onCardEntryComplete() {
    print('entry is closed');
  }

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    print(result);
    var success = await _checkout(result);
    if (!success) {
      await InAppPayments.showCardNonceProcessingError('failed to checkout.');
    } else {
      await InAppPayments.completeCardEntry(onCardEntryComplete: _onCardEntryComplete);
    }
  }

  void _onCardEntryCancel() async {
    print('card entry flow is canceled.');
  }

  Future<void> _onStartCardEntryFlow() async {
    try {
      await InAppPayments.startCardEntryFlow(onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess, onCardEntryCancel: _onCardEntryCancel);
    } on PlatformException {
      print('Failed to startCardEntryFlow.');
    }
  }

  void _onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
        price: '100',
        currencyCode: 'USD',
        onGooglePayNonceRequestSuccess: _onGooglePayNonceRequestSuccess,
        onGooglePayNonceRequestFailure: _onGooglePayNonceRequestFailure,
        onGooglePayCanceled: _onGooglePayCancel);
    } on PlatformException catch(ex) {
       print('Failed to onStartGooglePay. \n ${ex.toString()}');
    }
  }

  void _onGooglePayNonceRequestSuccess(CardDetails result) {
      print(result);
  }

  void _onGooglePayCancel() {
    print('GooglePay is canceled');
  }

  void _onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    print('GooglePay failed. \n ${errorInfo.toString()}');
  }

  void _onStartApplePay() async {
    try {
      await InAppPayments.requestApplePayNonce(
        price: '100', 
        summaryLabel: 'My Checkout',
        countryCode: 'US', 
        currencyCode: 'USD', 
        onApplePayNonceRequestSuccess: _onApplePayNonceRequestSuccess,
        onApplePayNonceRequestFailure: _onApplePayNonceRequestFailure,
        onApplePayComplete: _onApplePayComplete);
    } on PlatformException catch(ex) {
       print('Failed to onStartApplePay. \n ${ex.toString()}');
    }
  }

  void _onApplePayNonceRequestSuccess(CardDetails result) async {
    print(result);
    var success = await _checkout(result);
    if (success) {
      await InAppPayments.completeApplePayAuthorization(isSuccess: true);
    } else {
      await InAppPayments.completeApplePayAuthorization(isSuccess: false, errorMessage: "failed to charge amount.");
    }
  } 

  void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    print('ApplePay failed. \n ${errorInfo.toString()}');
    await InAppPayments.completeApplePayAuthorization(isSuccess: false);
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
                onPressed: _paymentInitialized && (_applePayEnabled || _googlePayEnabled) ? 
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
