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
import 'package:square_in_app_payments/google_pay_constants.dart'
    as google_pay_constants;
import '../colors.dart';
import '../transaction_service.dart';
import 'cookie_button.dart';
import 'dialog_modal.dart';
// We use a custom modal bottom sheet to override the default height (and remove it).
import 'modal_bottom_sheet.dart' as custom_modal_bottom_sheet;
import 'order_sheet.dart';

enum ApplePayStatus { success, fail, unknown }

class BuySheet extends StatefulWidget {
  final bool applePayEnabled;
  final bool googlePayEnabled;
  final String squareLocationId;
  final String applePayMerchantId;
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();


  BuySheet(
      {this.applePayEnabled,
      this.googlePayEnabled,
      this.applePayMerchantId,
      this.squareLocationId});

  @override
  BuySheetState createState() {
    return BuySheetState();
  }
}

class BuySheetState extends State<BuySheet> {
  ApplePayStatus _applePayStatus = ApplePayStatus.unknown;

  bool get _chargeServerHostReplaced => chargeServerHost != "REPLACE_ME";

  bool get _squareLocationSet => widget.squareLocationId != "REPLACE_ME";

  bool get _applePayMerchantIdSet => widget.applePayMerchantId != "REPLACE_ME";

  void _showOrderSheet() async {
    var selection =
        await custom_modal_bottom_sheet.showModalBottomSheet<PaymentType>(
            context: BuySheet.scaffoldKey.currentState.context,
            builder: (context) => OrderSheet(applePayEnabled: widget.applePayEnabled, googlePayEnabled: widget.googlePayEnabled,));

    switch (selection) {
      case PaymentType.cardPayment:
        await _onStartCardEntryFlow();
        break;
      case PaymentType.googlePay:
        if (_squareLocationSet && widget.googlePayEnabled) {
          _onStartGooglePay();
        } else {
          _showSquareLocationIdNotSet();
        }
        break;
      case PaymentType.applePay:
        if (_applePayMerchantIdSet && widget.applePayEnabled) {
          _onStartApplePay();
        } else {
          _showapplePayMerchantIdNotSet();
        }
        break;
    }
  }

  void printCurlCommand(String nonce) {
    var uuid = Uuid().v4();
    print(
        'curl --request POST https://connect.squareup.com/v2/locations/SQUARE_LOCATION_ID/transactions \\'
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

  void _showUrlNotSetAndPrintCurlCommand(String nonce) {
    showAlertDialog(
        context: BuySheet.scaffoldKey.currentContext,
        title: "Nonce generated but not charged",
        description:
            "Check your console for a CURL command to charge the nonce, or replace CHARGE_SERVER_HOST with your server host.");
    printCurlCommand(nonce);
  }

  void _showSquareLocationIdNotSet() {
    showAlertDialog(
        context: BuySheet.scaffoldKey.currentContext,
        title: "Missing Square Location ID",
        description:
            "To request a Google Pay nonce, replace squareLocationId in main.dart with a Square Location ID.");
  }

  void _showapplePayMerchantIdNotSet() {
    showAlertDialog(
        context: BuySheet.scaffoldKey.currentContext,
        title: "Missing Apple Merchant ID",
        description:
            "To request an Apple Pay nonce, replace applePayMerchantId in main.dart with an Apple Merchant ID.");
  }

  void _onCardEntryComplete() {
    if (_chargeServerHostReplaced) {
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Your order was successful",
          description:
              "Go to your Square dashbord to see this order reflected in the sales tab.");
    }
  }

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    if (!_chargeServerHostReplaced) {
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);

      _showUrlNotSetAndPrintCurlCommand(result.nonce);
      return;
    }
    try {
      await chargeCard(result);
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
    } on ChargeException catch (ex) {
      InAppPayments.showCardNonceProcessingError(ex.errorMessage);
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
          priceStatus: google_pay_constants.totalPriceStatusFinal,
          price: getCookieAmount(),
          currencyCode: 'USD',
          onGooglePayNonceRequestSuccess: _onGooglePayNonceRequestSuccess,
          onGooglePayNonceRequestFailure: _onGooglePayNonceRequestFailure,
          onGooglePayCanceled: onGooglePayEntryCanceled);
    } on PlatformException catch (ex) {
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Failed to start GooglePay",
          description: ex.toString());
    }
  }

  void _onGooglePayNonceRequestSuccess(CardDetails result) async {
    if (!_chargeServerHostReplaced) {
      _showUrlNotSetAndPrintCurlCommand(result.nonce);
      return;
    }
    try {
      await chargeCard(result);
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Your order was successful",
          description:
              "Go to your Square dashbord to see this order reflected in the sales tab.");
    } on ChargeException catch (ex) {
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Error processing GooglePay payment",
          description: ex.errorMessage);
    }
  }

  void _onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    showAlertDialog(
        context: BuySheet.scaffoldKey.currentContext,
        title: "Failed to request GooglePay nonce",
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
    } on PlatformException catch (ex) {
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Failed to start ApplePay",
          description: ex.toString());
    }
  }

  void _onApplePayNonceRequestSuccess(CardDetails result) async {
    if (!_chargeServerHostReplaced) {
      _showUrlNotSetAndPrintCurlCommand(result.nonce);
      return;
    }
    try {
      await chargeCard(result);
      _applePayStatus = ApplePayStatus.success;
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Your order was successful",
          description:
              "Go to your Square dashbord to see this order reflected in the sales tab.");
      await InAppPayments.completeApplePayAuthorization(isSuccess: true);
    } on ChargeException catch (ex) {
      showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Error processing ApplePay payment",
          description: ex.errorMessage);
      _applePayStatus = ApplePayStatus.fail;
      await InAppPayments.completeApplePayAuthorization(
          isSuccess: false, errorMessage: ex.errorMessage);
    }
  }

  void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    _applePayStatus = ApplePayStatus.fail;
    showAlertDialog(
          context: BuySheet.scaffoldKey.currentContext,
          title: "Error request ApplePay nonce",
          description: errorInfo.toString());
    await InAppPayments.completeApplePayAuthorization(
        isSuccess: false, errorMessage: errorInfo.message);
  }

  void _onApplePayEntryComplete() {
    if (_applePayStatus == ApplePayStatus.unknown) {
      // the apple pay is canceled
      _showOrderSheet();
    }
  }

  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData(canvasColor: Colors.transparent),
        home: Scaffold(
          backgroundColor: mainBackgroundColor,
          key: BuySheet.scaffoldKey,
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
                )),
          ),
        ),
      );
}
