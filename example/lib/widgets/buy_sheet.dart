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
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import '../colors.dart';
import '../main.dart';
import '../transaction_service.dart';
import 'cookie_button.dart';
import 'dialog_modal.dart';
// We use a custom modal bottom sheet to override the default height (and remove it).
import 'modal_bottom_sheet.dart' as custom_modal_bottom_sheet;
import 'order_sheet.dart';

class BuySheet extends StatelessWidget {
  String nonce;
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

  bool get chargeBackendDomainReplaced {
    return chargeBackendDomain != "REPLACE_ME";
  }

  void printCurlCommand() {
   var uuid = Uuid().v4();
   print('curl --request POST https://connect.squareup.com/v2/locations/${squareLocationId}/transactions \\' +
    '--header \"Content-Type: application/json\" \\' +
    '--header \"Authorization: Bearer YOUR_ACCESS_TOKEN\" \\' +
    '--header \"Accept: application/json\" \\' +
    '--data \'{' +
        '\"idempotency_key\": \"$uuid\",' +
        '\"amount_money\": {' +
        '\"amount\": $cookieAmount,' +
        '\"currency\": \"USD\"},' +
        '\"card_nonce\": \"$nonce\"' +
      '}\'');
  }

  void _onCardEntryComplete() {
    if (chargeBackendDomainReplaced) {
      showAlertDialog(context: scaffoldKey.currentContext, 
      title: "Your order was successful",
      description: "Go to your Square dashbord to see this order reflected in the sales tab.");
    } else {
      showAlertDialog(context: scaffoldKey.currentContext, 
      title: "Nonce generated, but URL not set",
      description: "You have not replaced your domain URL. Please check your log for a CURL command to charge the card.");
      printCurlCommand();
    }
  }

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    if (!chargeBackendDomainReplaced) {
      nonce = result.nonce;
      InAppPayments.completeCardEntry(
        onCardEntryComplete: _onCardEntryComplete);
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
        onCardNonceRequestSuccess: await _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: await _onCancelCardEntryFlow);
  }

  void _onCancelCardEntryFlow() {
    showPlaceOrderSheet();
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
      showPlaceOrderSheet();
    }
  }

  void _onGooglePayNonceRequestSuccess(CardDetails result) async {
    if (!chargeBackendDomainReplaced) {
      showAlertDialog(context: scaffoldKey.currentContext, 
      title: "Nonce generated, but URL not set",
      description: "You have not replaced your domain URL. Please check your log for a CURL command to charge the card.");
      nonce = result.nonce;
      printCurlCommand();
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
    } on SocketException {
      showAlertDialog(context: scaffoldKey.currentContext, 
      title: "Unable to contact host",
      description: "Could not contact host domain. Please try again later.");
    }
  }

  void _onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    showAlertDialog(context: scaffoldKey.currentContext,
    title: "Failed to start GooglePay",
    description: errorInfo.toString());
  }

  void onGooglePayEntryCanceled() {
    showPlaceOrderSheet();
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
      showPlaceOrderSheet();
    }
  }

  void _onApplePayNonceRequestSuccess(CardDetails result) async {
    if (!chargeBackendDomainReplaced) {
      showAlertDialog(context: scaffoldKey.currentContext, 
      title: "Nonce generated, but URL not set",
      description: "You have not replaced your domain URL. Please check your log for a CURL command to charge the card.");
      nonce = result.nonce;
      printCurlCommand();
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
    } on SocketException {
      showAlertDialog(context: scaffoldKey.currentContext, 
      title: "Unable to contact host",
      description: "Could not contact host domain. Please try again later.");
    }
  }

  void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    await InAppPayments.completeApplePayAuthorization(isSuccess: false);
  }

  void _onApplePayEntryComplete() {
    showPlaceOrderSheet();
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
                  CookieButton(text: "Buy", onPressed: showPlaceOrderSheet),
              ),
            ],
          )
        ),
      ),
    ),
  );
}