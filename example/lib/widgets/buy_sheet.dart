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
import 'package:uuid/uuid.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import '../colors.dart';
import '../transaction_service.dart';
import 'cookie_button.dart';
import 'dialog_modal.dart';
// We use a custom modal bottom sheet to override the default height (and remove it).
import 'modal_bottom_sheet.dart' as custom_modal_bottom_sheet;
import 'order_sheet.dart';

class BuySheet extends StatelessWidget {
  final bool applePayEnabled;
  final bool googlePayEnabled;
  final String squareLocationId;
  static final GlobalKey<ScaffoldState> scaffoldKey =
    GlobalKey<ScaffoldState>();

  BuySheet({this.applePayEnabled, this.googlePayEnabled, this.squareLocationId});

  void _showOrderSheet() async {
    var selection = await custom_modal_bottom_sheet.showModalBottomSheet<paymentType>(
        context: scaffoldKey.currentState.context,
        builder: (context) => OrderSheet()
    );

    switch (selection) {
      case paymentType.cardPayment:
        await _onStartCardEntryFlow();
        break;
      case paymentType.googlePay:
        googlePayEnabled ? _onStartGooglePay() : null;
        break;
      case paymentType.applePay:
        applePayEnabled ? _onStartApplePay() : null;
        break;
    }
  }

  bool get _chargeBackendDomainReplaced =>
    chargeBackendDomain != "REPLACE_ME";

  void printCurlCommand(String nonce) {
   var uuid = Uuid().v4();
   print('curl --request POST https://connect.squareup.com/v2/locations/$squareLocationId/transactions \\'
    '--header \"Content-Type: application/json\" \\'
    '--header \"Authorization: Bearer YOUR_ACCESS_TOKEN\" \\'
    '--header \"Accept: application/json\" \\'
    '--data \'{'
        '\"idempotency_key\": \"$uuid\",'
        '\"amount_money\": {'
        '\"amount\": $cookieAmount,'
        '\"currency\": \"USD\"},'
        '\"card_nonce\": \"$nonce\"'
      '}\'');
  }

  void _onCardEntryComplete() {
    if (_chargeBackendDomainReplaced) {
      showAlertDialog(context: scaffoldKey.currentContext, 
      title: "Your order was successful",
      description: "Go to your Square dashbord to see this order reflected in the sales tab.");
    }
  }

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    if (!_chargeBackendDomainReplaced) {
      InAppPayments.completeCardEntry(
        onCardEntryComplete: _onCardEntryComplete);

      showUrlNotSetAndPrintCurlCommand(result.nonce);
      return;
    }
    try {
      await chargeCard(result);
      InAppPayments.completeCardEntry(
        onCardEntryComplete: _onCardEntryComplete);
    } on ChargeException catch (e) {
      InAppPayments.showCardNonceProcessingError(e.errorMessage);
    }
  }

  Future<void> _onStartCardEntryFlow() async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow);
  }

  void _onCancelCardEntryFlow() {
    _showOrderSheet();
  }

  void _onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
          priceStatus: 1,
          price: getCookieAmount(),
          currencyCode: 'USD',
          onGooglePayNonceRequestSuccess: _onGooglePayNonceRequestSuccess,
          onGooglePayNonceRequestFailure: _onGooglePayNonceRequestFailure,
          onGooglePayCanceled: onGooglePayEntryCanceled);
    } on PlatformException {
      _showOrderSheet();
    }
  }

  void _onGooglePayNonceRequestSuccess(CardDetails result) async {
    if (!_chargeBackendDomainReplaced) {
      showUrlNotSetAndPrintCurlCommand(result.nonce);
      return;
    }
    try {
      await chargeCard(result);
      showAlertDialog(context: scaffoldKey.currentContext, 
      title: "Your order was successful",
      description: "Go to your Square dashbord to see this order reflected in the sales tab.");
    } on ChargeException catch (e) {
      showAlertDialog(context: scaffoldKey.currentContext,
      title: "Error processing GooglePay payment",
      description: e.errorMessage);
    }
  }

  void _onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    showAlertDialog(context: scaffoldKey.currentContext,
    title: "Failed to start GooglePay",
    description: errorInfo.toString());
  }

  void onGooglePayEntryCanceled() {
    _showOrderSheet();
  }

  void _onStartApplePay() async {
    try {
      await InAppPayments.requestApplePayNonce(
          price: getCookieAmount(),
          summaryLabel: 'Cookie',
          countryCode: 'US',
          currencyCode: 'USD',
          onApplePayNonceRequestSuccess: _onApplePayNonceRequestSuccess,
          onApplePayNonceRequestFailure: _onApplePayNonceRequestFailure,
          onApplePayComplete: _onApplePayEntryComplete);
    } on PlatformException {
      _showOrderSheet();
    }
  }

  void _onApplePayNonceRequestSuccess(CardDetails result) async {
    if (!_chargeBackendDomainReplaced) {
      showUrlNotSetAndPrintCurlCommand(result.nonce);
      return;
    }
    try {
      await chargeCard(result);
      showAlertDialog(context: scaffoldKey.currentContext, 
      title: "Your order was successful",
      description: "Go to your Square dashbord to see this order reflected in the sales tab.");
    } on ChargeException catch (e) {
      showAlertDialog(context: scaffoldKey.currentContext,
      title: "Error processing ApplePay payment",
      description: e.errorMessage);
    }
  }

  void showUrlNotSetAndPrintCurlCommand(String nonce) {
    showAlertDialog(context: scaffoldKey.currentContext, 
    title: "Nonce generated, but URL not set",
    description: "You have not replaced your domain URL. Please check your log for a CURL command to charge the card.");
    printCurlCommand(nonce);
  }

  void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    await InAppPayments.completeApplePayAuthorization(isSuccess: false);
  }

  void _onApplePayEntryComplete() {
    _showOrderSheet();
  }

  Widget build(BuildContext context) => MaterialApp(
    theme: ThemeData(canvasColor: Colors.transparent),
    home: Scaffold(
      backgroundColor: mainBackgroundColor,
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
                  CookieButton(text: "Buy", onPressed: _showOrderSheet),
              ),
            ],
          )
        ),
      ),
    ),
  );
}