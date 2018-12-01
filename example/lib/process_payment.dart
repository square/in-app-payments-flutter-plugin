import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/google_pay_constants.dart' as google_pay_constants;
import 'package:http/http.dart' as http;
import 'home_screen.dart';

class ProcessPayment {

  bool paymentInitialized = false;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;
  BuildContext context;

  ProcessPayment(this.context) {
    initSquarePayment();
  }

  Future setIOSCardEntryTheme() async {
    var themeConfiguationBuilder = IOSThemeBuilder();
    themeConfiguationBuilder.saveButtonTitle = 'Pay';

    await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
  }

  Future<void> initSquarePayment() async {
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
    Navigator.pop(context, true);
  }

  void onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    await _checkout(result);
  }

  Future<void> onStartCardEntryFlow() async {
    try {
      await InAppPayments.startCardEntryFlow(onCardNonceRequestSuccess: onCardEntryCardNonceRequestSuccess, onCardEntryCancel: onCardEntryCancel);
    } on PlatformException {
      showError("Failed to start card entry");
    }
  }

  void onCardEntryCancel() {
    Navigator.pop(context, false);
  }

  void onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
        priceStatus: 1,
        price: '100',
        currencyCode: 'USD',
        onGooglePayNonceRequestSuccess: onGooglePayNonceRequestSuccess,
        onGooglePayNonceRequestFailure: onGooglePayNonceRequestFailure,
        onGooglePayCanceled: onGooglePayCancel);
    } on PlatformException catch(ex) {
        showError('Failed to start GooglePay.\n ${ex.toString()}');
    }
  }


  void onGooglePayNonceRequestSuccess(CardDetails result) async {
      await _checkout(result);
  }

  void onGooglePayCancel() {
    
  }

  void onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    showError('GooglePay failed.\n ${errorInfo.toString()}');
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
      showError('Failed to start ApplePay.\n ${ex.toString()}');
    }
  }

  void onApplePayNonceRequestSuccess(CardDetails result) async {
    await _checkout(result);
  } 

  void onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    await InAppPayments.completeApplePayAuthorization(isSuccess: false);
  }

  void onApplePayComplete() {
  }

  static Future<void> showSuccess(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your order was successful'),
          content: SingleChildScrollView(
            child:
                Text("Go to your Square dashbord to see this order reflected in the sales tab."),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showError(String errorMessage) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error occurred'),
          content: SingleChildScrollView(
            child:
                Text(errorMessage),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}