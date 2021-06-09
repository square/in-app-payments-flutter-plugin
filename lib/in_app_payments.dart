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
import 'package:flutter/services.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'models.dart';
import 'src/serializers.dart';

typedef CardEntryCancelCallback = void Function();
typedef CardEntryCompleteCallback = void Function();
typedef CardEntryCardNonceRequestSuccessCallback = void Function(
    CardDetails result);

typedef GooglePayNonceRequestSuccessCallback = void Function(
    CardDetails result);
typedef GooglePayNonceRequestFailureCallback = void Function(
    ErrorInfo errorInfo);
typedef GooglePayCancelCallback = void Function();

typedef ApplePayNonceRequestSuccessCallback = void Function(CardDetails result);
typedef ApplePayNonceRequestFailureCallback = void Function(
    ErrorInfo errorInfo);
typedef ApplePayCompleteCallback = void Function();

typedef BuyerVerificationSuccessCallback = void Function(
    BuyerVerificationDetails result);
typedef BuyerVerificationErrorCallback = void Function(ErrorInfo errorInfo);

typedef MasterCardNonceRequestSuccessCallback = void Function(CardDetails result);
typedef MasterCardNonceRequestFailureCallback = void Function(
    ErrorInfo errorInfo);

// ignore: avoid_classes_with_only_static_members
class InAppPayments {
  static final MethodChannel _channel =
      const MethodChannel('square_in_app_payments')
        ..setMethodCallHandler(_nativeCallHandler);

  static final _standardSerializers =
      (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

  static CardEntryCancelCallback? _cardEntryCancelCallback;
  static CardEntryCardNonceRequestSuccessCallback?
      _cardEntryCardNonceRequestSuccessCallback;
  static CardEntryCompleteCallback? _cardEntryCompleteCallback;

  static GooglePayNonceRequestSuccessCallback?
      _googlePayNonceRequestSuccessCallback;
  static GooglePayNonceRequestFailureCallback?
      _googlePayNonceRequestFailureCallback;
  static GooglePayCancelCallback? _googlePayCancelCallback;

  static ApplePayNonceRequestSuccessCallback?
      _applePayNonceRequestSuccessCallback;
  static ApplePayNonceRequestFailureCallback?
      _applePayNonceRequestFailureCallback;
  static ApplePayCompleteCallback? _applePayCompleteCallback;

  static BuyerVerificationSuccessCallback? _buyerVerificationSuccessCallback;
  static BuyerVerificationErrorCallback? _buyerVerificationErrorCallback;

  static MasterCardNonceRequestSuccessCallback? _masterCardNonceRequestSuccessCallback;
  static MasterCardNonceRequestFailureCallback? _masterCardNonceRequestFailureCallback;

  static Future<dynamic> _nativeCallHandler(MethodCall call) async {
    try {
      switch (call.method) {
        case 'cardEntryCancel':
          if (_cardEntryCancelCallback != null) {
            _cardEntryCancelCallback!();
          }
          break;
        case 'cardEntryDidObtainCardDetails':
          if (_cardEntryCardNonceRequestSuccessCallback != null) {
            var result = _standardSerializers.deserializeWith(
                CardDetails.serializer, call.arguments)!;
            _cardEntryCardNonceRequestSuccessCallback!(result);
          }
          break;
        case 'cardEntryComplete':
          if (_cardEntryCompleteCallback != null) {
            _cardEntryCompleteCallback!();
          }
          break;
        case 'onGooglePayCanceled':
          if (_googlePayCancelCallback != null) {
            _googlePayCancelCallback!();
          }
          break;
        case 'onGooglePayNonceRequestSuccess':
          if (_googlePayNonceRequestSuccessCallback != null) {
            var result = _standardSerializers.deserializeWith(
                CardDetails.serializer, call.arguments)!;
            _googlePayNonceRequestSuccessCallback!(result);
          }
          break;
        case 'onGooglePayNonceRequestFailure':
          if (_googlePayNonceRequestFailureCallback != null) {
            var errorInfo = _standardSerializers.deserializeWith(
                ErrorInfo.serializer, call.arguments)!;
            _googlePayNonceRequestFailureCallback!(errorInfo);
          }
          break;
        case 'onApplePayNonceRequestSuccess':
          if (_applePayNonceRequestSuccessCallback != null) {
            var result = _standardSerializers.deserializeWith(
                CardDetails.serializer, call.arguments)!;
            _applePayNonceRequestSuccessCallback!(result);
          }
          break;
        case 'onApplePayNonceRequestFailure':
          if (_applePayNonceRequestFailureCallback != null) {
            var errorInfo = _standardSerializers.deserializeWith(
                ErrorInfo.serializer, call.arguments)!;
            _applePayNonceRequestFailureCallback!(errorInfo);
          }
          break;
        case 'onApplePayComplete':
          if (_applePayCompleteCallback != null) {
            _applePayCompleteCallback!();
          }
          break;
        case 'onBuyerVerificationSuccess':
          if (_buyerVerificationSuccessCallback != null) {
            var result = _standardSerializers.deserializeWith(
                BuyerVerificationDetails.serializer, call.arguments)!;
            _buyerVerificationSuccessCallback!(result);
          }
          break;
        case 'onBuyerVerificationError':
          if (_buyerVerificationErrorCallback != null) {
            var errorInfo = _standardSerializers.deserializeWith(
                ErrorInfo.serializer, call.arguments)!;
            _buyerVerificationErrorCallback!(errorInfo);
          }
          break;
        case 'OnMasterCardNonceRequestSuccess':
          if (_masterCardNonceRequestSuccessCallback != null) {
            var result = _standardSerializers.deserializeWith(
                CardDetails.serializer, call.arguments)!;
            _masterCardNonceRequestSuccessCallback!(result);
          }
          break;
        case 'OnMasterCardNonceRequestFailure':
          if (_masterCardNonceRequestFailureCallback != null) {
            var errorInfo = _standardSerializers.deserializeWith(
                ErrorInfo.serializer, call.arguments)!;
            _masterCardNonceRequestFailureCallback!(errorInfo);
          }
          break;
        default:
          throw Exception('unknown method called from native');
      }
    } on Exception catch (ex) {
      // TOOD: report error
      print(ex);
    }
    return false;
  }

  static Future setSquareApplicationId(String applicationId) async {
    assert(applicationId.isNotEmpty,
        'application should not be empty.');
    var params = <String, dynamic>{
      'applicationId': applicationId,
    };
    await _channel.invokeMethod('setApplicationId', params);
  }

  static Future startCardEntryFlow(
      {required CardEntryCardNonceRequestSuccessCallback onCardNonceRequestSuccess,
      required CardEntryCancelCallback onCardEntryCancel,
      bool collectPostalCode = true}) async {
    _cardEntryCancelCallback = onCardEntryCancel;
    _cardEntryCardNonceRequestSuccessCallback = onCardNonceRequestSuccess;
    var params = <String, dynamic>{
      'collectPostalCode': collectPostalCode,
    };
    await _channel.invokeMethod('startCardEntryFlow', params);
  }

  static Future startGiftCardEntryFlow(
      {required CardEntryCardNonceRequestSuccessCallback onCardNonceRequestSuccess,
        required CardEntryCancelCallback onCardEntryCancel}) async {
    _cardEntryCancelCallback = onCardEntryCancel;
    _cardEntryCardNonceRequestSuccessCallback = onCardNonceRequestSuccess;
    await _channel.invokeMethod('startGiftCardEntryFlow');
  }


  static Future completeCardEntry(
      {required CardEntryCompleteCallback onCardEntryComplete}) async {
    _cardEntryCompleteCallback = onCardEntryComplete;
    await _channel.invokeMethod('completeCardEntry');
  }

  static Future showCardNonceProcessingError(String errorMessage) async {
    var params = <String, dynamic>{
      'errorMessage': errorMessage,
    };
    await _channel.invokeMethod('showCardNonceProcessingError', params);
  }

  static Future initializeGooglePay(
      String squareLocationId, int environment) async {
    assert(squareLocationId.isNotEmpty,
        'squareLocationId should not be empty.');
    var params = <String, dynamic>{
      'environment': environment,
      'squareLocationId': squareLocationId,
    };
    await _channel.invokeMethod('initializeGooglePay', params);
  }

  static Future<bool> get canUseGooglePay async {
    try {
      return await (_channel.invokeMethod('canUseGooglePay'));
    } on PlatformException catch (ex) {
      throw InAppPaymentsException(
          ex.code,
          ex.message,
          ex.details[InAppPaymentsException.debugCodeKey],
          ex.details[InAppPaymentsException.debugMessageKey]);
    }
  }

  static Future requestGooglePayNonce(
      {required String price,
      required String currencyCode,
      required int priceStatus,
      required GooglePayNonceRequestSuccessCallback onGooglePayNonceRequestSuccess,
      required GooglePayNonceRequestFailureCallback onGooglePayNonceRequestFailure,
      required GooglePayCancelCallback onGooglePayCanceled}) async {
    assert(price.isNotEmpty,
        'price should not be empty.');
    assert(currencyCode.isNotEmpty,
        'currencyCode should not be empty.');
    _googlePayNonceRequestSuccessCallback = onGooglePayNonceRequestSuccess;
    _googlePayNonceRequestFailureCallback = onGooglePayNonceRequestFailure;
    _googlePayCancelCallback = onGooglePayCanceled;

    try {
      var params = <String, dynamic>{
        'price': price,
        'currencyCode': currencyCode,
        'priceStatus': priceStatus,
      };
      await _channel.invokeMethod('requestGooglePayNonce', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentsException(
          ex.code,
          ex.message,
          ex.details[InAppPaymentsException.debugCodeKey],
          ex.details[InAppPaymentsException.debugMessageKey]);
    }
  }

  static Future initializeApplePay(String applePayMerchantId) async {
    assert(applePayMerchantId.isNotEmpty,
        'applePayMerchantId should not be empty.');
    var params = <String, dynamic>{
      'merchantId': applePayMerchantId,
    };
    await _channel.invokeMethod('initializeApplePay', params);
  }

  static Future<bool> get canUseApplePay async =>
      await (_channel.invokeMethod('canUseApplePay'));

  static Future requestApplePayNonce(
      {required String price,
      required String summaryLabel,
      required String countryCode,
      required String currencyCode,
      required ApplePayPaymentType paymentType,
      required ApplePayNonceRequestSuccessCallback onApplePayNonceRequestSuccess,
      required ApplePayNonceRequestFailureCallback onApplePayNonceRequestFailure,
      required ApplePayCompleteCallback onApplePayComplete}) async {
    assert(summaryLabel.isNotEmpty,
        'summaryLabel should not be empty.');
    assert(price.isNotEmpty,
        'price should not be empty.');
    assert(countryCode.isNotEmpty,
        'countryCode should not be empty.');
    assert(currencyCode.isNotEmpty,
        'currencyCode should not be empty.');

    _applePayNonceRequestSuccessCallback = onApplePayNonceRequestSuccess;
    _applePayNonceRequestFailureCallback = onApplePayNonceRequestFailure;
    _applePayCompleteCallback = onApplePayComplete;

    var paymentTypeString = _standardSerializers.serializeWith(
        ApplePayPaymentType.serializer, paymentType);
    try {
      var params = <String, dynamic>{
        'price': price,
        'summaryLabel': summaryLabel,
        'countryCode': countryCode,
        'currencyCode': currencyCode,
        'paymentType': paymentTypeString,
      };
      await _channel.invokeMethod('requestApplePayNonce', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentsException(
          ex.code,
          ex.message,
          ex.details[InAppPaymentsException.debugCodeKey],
          ex.details[InAppPaymentsException.debugMessageKey]);
    }
  }

  static Future completeApplePayAuthorization(
      {required bool isSuccess, String errorMessage = ''}) async {
    var params = <String, dynamic>{
      'isSuccess': isSuccess,
      'errorMessage': errorMessage,
    };
    await _channel.invokeMethod('completeApplePayAuthorization', params);
  }

  static Future startCardEntryFlowWithBuyerVerification(
      {required BuyerVerificationSuccessCallback onBuyerVerificationSuccess,
      required BuyerVerificationErrorCallback onBuyerVerificationFailure,
      required CardEntryCancelCallback onCardEntryCancel,
      required String buyerAction,
      required Money money,
      required String squareLocationId,
      required Contact contact,
      bool collectPostalCode = true}) async {
    _buyerVerificationSuccessCallback = onBuyerVerificationSuccess;
    _buyerVerificationErrorCallback = onBuyerVerificationFailure;
    _cardEntryCancelCallback = onCardEntryCancel;
    var params = <String, dynamic>{
      'buyerAction': buyerAction,
      'money': _standardSerializers.serializeWith(Money.serializer, money),
      'contact':
          _standardSerializers.serializeWith(Contact.serializer, contact),
      'squareLocationId': squareLocationId,
      'collectPostalCode': collectPostalCode,
    };
    await _channel.invokeMethod(
        'startCardEntryFlowWithBuyerVerification', params);
  }

  static Future startBuyerVerificationFlow(
      {required BuyerVerificationSuccessCallback onBuyerVerificationSuccess,
      required BuyerVerificationErrorCallback onBuyerVerificationFailure,
      required String buyerAction,
      required Money money,
      required String squareLocationId,
      required Contact contact,
      required String paymentSourceId}) async {
    _buyerVerificationSuccessCallback = onBuyerVerificationSuccess;
    _buyerVerificationErrorCallback = onBuyerVerificationFailure;
    var params = <String, dynamic>{
      'buyerAction': buyerAction,
      'money': _standardSerializers.serializeWith(Money.serializer, money),
      'contact':
      _standardSerializers.serializeWith(Contact.serializer, contact),
      'squareLocationId': squareLocationId,
      'paymentSourceId': paymentSourceId,
    };
    await _channel.invokeMethod('startBuyerVerificationFlow', params);
  }

  static Future setIOSCardEntryTheme(IOSTheme theme) async {
    var params = <String, dynamic>{
      'theme': _standardSerializers.serializeWith(IOSTheme.serializer, theme),
    };
    await _channel.invokeMethod('setFormTheme', params);
  }

  static Future startSecureRemoteCommerce(
      {required int amount,
      required MasterCardNonceRequestSuccessCallback
          onMaterCardNonceRequestSuccess,
      required MasterCardNonceRequestFailureCallback
          onMasterCardNonceRequestFailure}) async {
    _masterCardNonceRequestSuccessCallback = onMaterCardNonceRequestSuccess;
    _masterCardNonceRequestFailureCallback = onMasterCardNonceRequestFailure;
    var params = <String, dynamic>{'amount': amount};
    await _channel.invokeMethod('startSecureRemoteCommerce', params);
  }
}

class InAppPaymentsException implements Exception {
  static const String debugCodeKey = 'debugCode';
  static const String debugMessageKey = 'debugMessage';

  static final _standardSerializers =
      (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

  final String _code;

  final String? message;

  final String debugCode;

  final String? debugMessage;

  ErrorCode? get code =>
      _standardSerializers.deserializeWith(ErrorCode.serializer, _code);

  InAppPaymentsException(
    this._code,
    this.message,
    this.debugCode,
    this.debugMessage);

  @override
  String toString() =>
      'InAppPaymentException($code, $message, $debugCode, $debugMessage)';
}
