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
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:http/http.dart' as http;

enum STATE {inProgress, paymentComplete, canceled, error}


class ProcessPayment {
  bool paymentInitialized = false;
  bool applePayEnabled = false;
  bool googlePayEnabled = false;
  String errorMessage;
  VoidCallback callback;
  STATE state;

  ProcessPayment(this.callback) {
    initSquarePayment();
  }

  Future<void> initSquarePayment() async {
    var canUseApplePay = false;
    var canUseGooglePay = false;
    state = STATE.inProgress;
    if(Platform.isAndroid) {
      canUseGooglePay = await InAppPayments.canUseGooglePay;
    } else if (Platform.isIOS) {
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
        var body = json.decode(response.body);
        if (response.statusCode == 200) {
          InAppPayments.completeCardEntry(onCardEntryComplete: onCardEntryComplete);
        } else {
          InAppPayments.showCardNonceProcessingError(body["errorMessage"]);
        }
    });
  }

  void onCardEntryComplete() {
    state = STATE.paymentComplete;
    callback();
  }

  void onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    await _checkout(result);
  }

  Future<void> onStartCardEntryFlow() async {
    state = STATE.inProgress;
    errorMessage = null;
    try {
      await InAppPayments.startCardEntryFlow(onCardNonceRequestSuccess: await onCardEntryCardNonceRequestSuccess, onCardEntryCancel: await onCancelCardEntryFlow);
    } on PlatformException {
      state = STATE.error;
      errorMessage = "Failed to start card entry";
      callback();
    }
  }

  void onCancelCardEntryFlow() {
    state = STATE.canceled;
    callback();
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
    } on PlatformException catch(ex) {
        state = STATE.error;
        errorMessage = 'Failed to start GooglePay.\n ${ex.toString()}';
        callback();
    }
  }


  void onGooglePayNonceRequestSuccess(CardDetails result) async {
      await _checkout(result);
  }

  void onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    state = STATE.error;
    errorMessage = 'Failed to start GooglePay.\n ${errorInfo.toString()}';
    callback();
  }

  void onGooglePayEntryCanceled() {
    state = STATE.canceled;
    callback();
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
    } on PlatformException catch(ex) {
      state = STATE.error;
      errorMessage = 'Failed to start GooglePay.\n ${ex.toString()}';
      callback();
    }
  }

  void onApplePayNonceRequestSuccess(CardDetails result) async {
    await _checkout(result);
  } 

  void onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    await InAppPayments.completeApplePayAuthorization(isSuccess: false);
  }

  void onApplePayEntryComplete() {
    state = STATE.canceled;
    callback();
  }
}