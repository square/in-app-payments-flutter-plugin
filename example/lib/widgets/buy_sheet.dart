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
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import '../order_sheet.dart';
import '../transaction_service.dart';
import 'cookie_button.dart';
import 'dialog_modal.dart';
// We use a custom modal bottom sheet to override the default height (and remove it).
import 'modal_bottom_sheet.dart' as custom_modal_bottom_sheet;

class BuySheet extends StatelessWidget {
    final bool applePayEnabled;
    final bool googlePayEnabled;
    static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

    BuySheet({this.applePayEnabled, this.googlePayEnabled});

    void showPlaceOrderSheet() async {
      var selection = await custom_modal_bottom_sheet.showModalBottomSheet<paymentType>(
          context: scaffoldKey.currentState.context,
          builder: (context) => OrderSheet()
      );

      switch (selection) {
        case paymentType.cardPayment:
          await onStartCardEntryFlow();
          break;
        case paymentType.googlePay:
          googlePayEnabled ? onStartGooglePay() : null;
          break;
        case paymentType.applePay:
          applePayEnabled ? onStartApplePay() : null;
          break;
      }
  }

  void onCardEntryComplete() {
    showSuccess(scaffoldKey.currentContext, "Go to your Square dashbord to see this order reflected in the sales tab.");
  }

  void onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    try {
      await chargeCard(result);
      InAppPayments.completeCardEntry(
        onCardEntryComplete: onCardEntryComplete);
    } on ChargeException catch (e) {
      InAppPayments.showCardNonceProcessingError(e.errorMessage);
    }
  }

  Future<void> onStartCardEntryFlow() async {
    try {
      await InAppPayments.startCardEntryFlow(
          onCardNonceRequestSuccess: await onCardEntryCardNonceRequestSuccess,
          onCardEntryCancel: await onCancelCardEntryFlow);
    } on PlatformException {
      showPlaceOrderSheet();
    }
  }

  void onCancelCardEntryFlow() {
    showPlaceOrderSheet();
  }

  void onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
          priceStatus: 1,
          price: getCookieAmount(),
          currencyCode: 'USD',
          onGooglePayNonceRequestSuccess: onGooglePayNonceRequestSuccess,
          onGooglePayNonceRequestFailure: onGooglePayNonceRequestFailure,
          onGooglePayCanceled: onGooglePayEntryCanceled);
    } on PlatformException catch (ex) {
      showPlaceOrderSheet();
    }
  }

  void onGooglePayNonceRequestSuccess(CardDetails result) async {
    try {
      await chargeCard(result);
      showSuccess(scaffoldKey.currentContext, "Go to your Square dashbord to see this order reflected in the sales tab.");
    } on ChargeException catch (e) {
      showError(scaffoldKey.currentContext, e.errorMessage);
    }
  }

  void onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    showError(scaffoldKey.currentContext, 'Failed to start GooglePay.\n ${errorInfo.toString()}');
  }

  void onGooglePayEntryCanceled() {
    showPlaceOrderSheet();
  }

  void onStartApplePay() async {
    try {
      await InAppPayments.requestApplePayNonce(
          price: getCookieAmount(),
          summaryLabel: 'Cookie',
          countryCode: 'US',
          currencyCode: 'USD',
          onApplePayNonceRequestSuccess: onApplePayNonceRequestSuccess,
          onApplePayNonceRequestFailure: onApplePayNonceRequestFailure,
          onApplePayComplete: onApplePayEntryComplete);
    } on PlatformException catch (ex) {
      showPlaceOrderSheet();
    }
  }

  void onApplePayNonceRequestSuccess(CardDetails result) async {

    try {
      await chargeCard(result);
      showSuccess(scaffoldKey.currentContext, "Go to your Square dashbord to see this order reflected in the sales tab.");
    } on ChargeException catch (e) {
      showError(scaffoldKey.currentContext, e.errorMessage);
    }
  }

  void onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    await InAppPayments.completeApplePayAuthorization(isSuccess: false);
  }

  void onApplePayEntryComplete() {
    showPlaceOrderSheet();
  }

  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(canvasColor: Colors.transparent),
    home: Scaffold(
      backgroundColor: Color(0xFF78CCC5),
      key: scaffoldKey,
      body: Builder(
        builder: (context) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image(image: AssetImage("assets/iconCookie.png")),
              ),
              Container(
                child: Text(
                  'Super Cookie',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
              Container(
                child: Text(
                  "Instantly gain special powers \nwhen ordering a super cookie",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 32),
                child:
                  CookieButton(text: "Buy", onPressed: showPlaceOrderSheet),
              ),
            ],
          )
        ),
      ),
    ),
  );
}