import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/google_pay_constants.dart' as google_pay_constants;

class ProcessPayment {

  bool paymentInitialized = false;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;

  ProcessPayment(context) {
    initSquarePayment(context);
  }

  Future setIOSCardEntryTheme() async {
      var themeConfiguationBuilder = IOSThemeBuilder();
      // themeConfiguationBuilder.font = FontBuilder()..size = 24.0;
      // themeConfiguationBuilder.backgroundColor = RGBAColorBuilder()..r=142..g=11..b=123;
      // themeConfiguationBuilder.keyboardAppearance = KeyboardAppearance.light;
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

  Future<bool> _checkout(CardDetails result) async => true;

  void onCardEntryComplete() {
    print('entry is closed');
  }

  void onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    print(result);
    var success = await _checkout(result);
    if (!success) {
      await InAppPayments.showCardNonceProcessingError('failed to checkout.');
    } else {
      await InAppPayments.completeCardEntry(onCardEntryComplete: onCardEntryComplete);
    }
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

  void onGooglePayNonceRequestSuccess(CardDetails result) {
      print(result);
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
    print(result);
    var success = await _checkout(result);
    if (success) {
      await InAppPayments.completeApplePayAuthorization(isSuccess: true);
    } else {
      await InAppPayments.completeApplePayAuthorization(isSuccess: false, errorMessage: "failed to charge amount.");
    }
  } 

  void onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    print('ApplePay failed. \n ${errorInfo.toString()}');
    await InAppPayments.completeApplePayAuthorization(isSuccess: false);
  }

  void onApplePayComplete() {
    print('ApplePay closed');
  }
}