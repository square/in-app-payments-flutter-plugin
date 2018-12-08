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
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/google_pay_constants.dart'
    as google_pay_constants;
import 'constants.dart';
import 'dialog_modal.dart';
import 'order_sheet.dart';
import 'process_payment.dart';
import 'widgets/button_widget.dart';
import 'widgets/showModalBottomSheet.dart' as custom_modal_bottom_sheet;

const String squareApplicationId = "REPLACE_ME";
const String squareLocationId = "REPLACE_ME";
const String appleMerchantToken = "REPLACE_ME";

void main() => runApp(MaterialApp(
      title: 'Super Cookie',
      home: HomeScreen(),
    ));

class HomeScreen extends StatefulWidget {
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool paymentInitialized = false;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;

  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initSquareInAppPayments();
    _initSquarePayment();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  Future<void> _initSquarePayment() async {
    var canUseApplePay = false;
    var canUseGooglePay = false;
    if (Platform.isAndroid) {
      canUseGooglePay = await InAppPayments.canUseGooglePay;
    } else if (Platform.isIOS) {
      canUseApplePay = await InAppPayments.canUseApplePay;
    }

    paymentInitialized = true;
    applePayEnabled = canUseApplePay;
    googlePayEnabled = canUseGooglePay;
  }

    void _showBottomSheet() async {
      var selection = await custom_modal_bottom_sheet.showModalBottomSheet<int>(
          context: scaffoldKey.currentState.context,
          builder: (context) {
            return OrderSheet();
          });

      switch (selection) {
        case cardPayment:
          paymentInitialized
              ? await onStartCardEntryFlow()
              : null;
          break;
        case walletPayment:
          paymentInitialized &&
                  (applePayEnabled || googlePayEnabled)
              ? (Theme.of(context).platform == TargetPlatform.iOS)
                  ? onStartApplePay()
                  : onStartGooglePay()
              : null;
          break;
      }
  }

  void _initSquareInAppPayments() async {
    InAppPayments.setSquareApplicationId(squareApplicationId);
    if (Platform.isAndroid) {
      await InAppPayments.initializeGooglePay(
          squareLocationId, google_pay_constants.environmentTest);
      // Android's theme is set in /android/app/src/main/res/themes.xml
    } else if (Platform.isIOS) {
      await _setIOSCardEntryTheme();
      await InAppPayments.initializeApplePay(appleMerchantToken);
    }
  }

  Future _setIOSCardEntryTheme() async {
    var themeConfiguationBuilder = IOSThemeBuilder();
    themeConfiguationBuilder.saveButtonTitle = 'Pay';
    themeConfiguationBuilder.errorColor = RGBAColorBuilder()
      ..r = 255
      ..g = 0
      ..b = 0;
    themeConfiguationBuilder.tintColor = RGBAColorBuilder()
      ..r = 36
      ..g = 152
      ..b = 141;
    themeConfiguationBuilder.keyboardAppearance = KeyboardAppearance.light;
    themeConfiguationBuilder.messageColor = RGBAColorBuilder()
      ..r = 114
      ..g = 114
      ..b = 114;

    await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
  }

  void onCardEntryComplete() {
    showSuccess(context);
  }

  void onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    var errorMessage = await chargeCard(result);
    if (errorMessage == null) {
      InAppPayments.completeCardEntry(
        onCardEntryComplete: onCardEntryComplete);
    } else {
      InAppPayments.showCardNonceProcessingError(errorMessage);
    }
  }

  Future<void> onStartCardEntryFlow() async {
    try {
      await InAppPayments.startCardEntryFlow(
          onCardNonceRequestSuccess: await onCardEntryCardNonceRequestSuccess,
          onCardEntryCancel: await onCancelCardEntryFlow);
    } on PlatformException {
      showError(context, "Failed to start card entry");
    }
  }

  void onCancelCardEntryFlow() {
    _showBottomSheet();
  }

  void onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
          priceStatus: 1,
          price: '100',
          currencyCode: 'USD',
          onGooglePayNonceRequestSuccess: onGooglePayNonceRequestSuccess,
          onGooglePayNonceRequestFailure: onGooglePayNonceRequestFailure,
          onGooglePayCanceled: onGooglePayEntryCanceled);
    } on PlatformException catch (ex) {
      showError(context, '${ex.message}Failed to start GooglePay.\n ${ex.toString()}');
    }
  }

  void onGooglePayNonceRequestSuccess(CardDetails result) async {
    var errorMessage = await chargeCard(result);
    if (errorMessage == null) {
      InAppPayments.completeCardEntry(
        onCardEntryComplete: onCardEntryComplete);
    } else {
      InAppPayments.showCardNonceProcessingError(errorMessage);
    }
  }

  void onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    showError(context, 'Failed to start GooglePay.\n ${errorInfo.toString()}');
  }

  void onGooglePayEntryCanceled() {
    _showBottomSheet();
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
          onApplePayComplete: onApplePayEntryComplete);
    } on PlatformException catch (ex) {
      showError(context, 'Failed to start Apple Pay.\n ${ex.toString()}');
    }
  }

  void onApplePayNonceRequestSuccess(CardDetails result) async {
    var errorMessage = await chargeCard(result);
    if (errorMessage == null) {
      InAppPayments.completeCardEntry(
        onCardEntryComplete: onCardEntryComplete);
    } else {
      InAppPayments.showCardNonceProcessingError(errorMessage);
    }
  }

  void onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    await InAppPayments.completeApplePayAuthorization(isSuccess: false);
  }

  void onApplePayEntryComplete() {
    _showBottomSheet();
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Image(image: AssetImage("assets/iconCookie.png")),
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        'Super Cookie',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    Container(
                      height: 70,
                      child: Text(
                        "Instantly gain special powers \nwhen ordering a super cookie",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    CookieButton("Buy", _showBottomSheet)
                  ],
                )
              ),
          ),
        ),
      );
}
