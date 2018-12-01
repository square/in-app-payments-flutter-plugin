import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/google_pay_constants.dart' as google_pay_constants;
import 'package:http/http.dart' as http;

class ProcessPayment {

  bool paymentInitialized = false;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;

  ProcessPayment(context) {
    initSquarePayment(context);
  }

  Future setIOSCardEntryTheme() async {
    var themeConfiguationBuilder = IOSThemeBuilder();
    themeConfiguationBuilder.saveButtonTitle = 'Pay';

    await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
  }

  Future<void> initSquarePayment(context) async {
    await InAppPayments.setSquareApplicationId('sq0idp-yqrzNS_5RBpkYBdxCT3tIQ');
    var canUseApplePay = false;
    var canUseGooglePay = false;
    if(Theme.of(context).platform == TargetPlatform.android) {
      await InAppPayments.initializeGooglePay('7270VTEWZABAJ', google_pay_constants.environmentTest);
      canUseGooglePay = await InAppPayments.canUseGooglePay;
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      await setIOSCardEntryTheme();
      await InAppPayments.initializeApplePay('merchant.com.mcomm.flutter');
      canUseApplePay = await InAppPayments.canUseApplePay;
    }

    paymentInitialized = true;
    applePayEnabled = canUseApplePay;
    googlePayEnabled = canUseGooglePay;
  }

  Future<void> _checkout(CardDetails result) async {
    var url = "https://26brjd4ue9.execute-api.us-east-1.amazonaws.com/default/chargeForCookie";
    var body = jsonEncode({"nonce": result.nonce});
    await http.post(url, body: body, headers: {
        "Accept": "application/json",
        "content-type": "application/json"
      })
      .then((response) {

      if (response.statusCode == 200) {
        InAppPayments.completeCardEntry(onCardEntryComplete: onCardEntryComplete);
      } else {
        InAppPayments.showCardNonceProcessingError('Failed to process payment.');
      }
    });
  }

  void onCardEntryComplete() {
    print('entry is closed');
  }

  void onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    await _checkout(result);
  }

  void onCardEntryCancel() async {
    print('card entry flow is canceled.');
  }

  Future<void> onStartCardEntryFlow() async {
    try {
      await InAppPayments.startCardEntryFlow(onCardNonceRequestSuccess: onCardEntryCardNonceRequestSuccess, onCardEntryCancel: onCardEntryCancel);
    } on PlatformException {
      print('Failed to startCardEntryFlow.');
    }
  }

  void onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
        price: '100',
        currencyCode: 'USD',
        onGooglePayNonceRequestSuccess: onGooglePayNonceRequestSuccess,
        onGooglePayNonceRequestFailure: onGooglePayNonceRequestFailure,
        onGooglePayCanceled: onGooglePayCancel);
    } on PlatformException catch(ex) {
        print('Failed to onStartGooglePay. \n ${ex.toString()}');
    }
  }

  void onGooglePayNonceRequestSuccess(CardDetails result) async {
      await _checkout(result);
  }

  void onGooglePayCancel() {
    print('GooglePay is canceled');
  }

  void onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    print('GooglePay failed. \n ${errorInfo.toString()}');
  }

  void onStartApplePay() async {
    try {
      await InAppPayments.requestApplePayNonce(
        price: '100', 
        summaryLabel: 'My Checkout',
        countryCode: 'US', 
        currencyCode: 'USD', 
        onApplePayNonceRequestSuccess: onApplePayNonceRequestSuccess,
        onApplePayNonceRequestFailure: onApplePayNonceRequestFailure,
        onApplePayComplete: onApplePayComplete);
    } on PlatformException catch(ex) {
        print('Failed to onStartApplePay. \n ${ex.toString()}');
    }
  }

  void onApplePayNonceRequestSuccess(CardDetails result) async {
    await _checkout(result);
  } 

  void onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    print('ApplePay failed. \n ${errorInfo.toString()}');
    await InAppPayments.completeApplePayAuthorization(isSuccess: false);
  }

  void onApplePayComplete() {
    print('ApplePay closed');
  }
}