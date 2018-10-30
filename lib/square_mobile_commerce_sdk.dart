import 'dart:async';

import 'package:flutter/services.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'models.dart';
import 'serializers.dart';

typedef void CardEntryDidCancelCallback();
typedef void CardEntryDidSucceedWithResultCallback(CardResult result);
typedef void GooglePayCancelCallback();
typedef void GooglePayDidSucceedWithResultCallback(CardResult result);
typedef void GooglePayFailedCallback(ErrorInfo errorInfo);

class SquareMobileCommerceSdkFlutterPlugin {
  static const String GOOGLE_PAY_ENV_PROD = "PROD";
  static const String GOOGLE_PAY_ENV_TEST = "TEST";

  static final MethodChannel _channel =
      const MethodChannel('square_mobile_commerce_sdk')..setMethodCallHandler(_nativeCallHandler);

  static final _standardSerializers = (serializers.toBuilder()..addPlugin(new StandardJsonPlugin())).build();

  static CardEntryDidCancelCallback _cardEntryDidCancelCallback;
  static CardEntryDidSucceedWithResultCallback _cardEntryDidSucceedWithResultCallback;

  static GooglePayCancelCallback _googlePayCancelCallback;
  static GooglePayDidSucceedWithResultCallback _googlePayDidSucceedWithResultCallback;
  static GooglePayFailedCallback _googlePayFailedCallback;

  static Future<dynamic> _nativeCallHandler(MethodCall call) async {
    try {
      switch (call.method) {
        case 'cardEntryDidCancel':
          if (_cardEntryDidCancelCallback != null) {
            _cardEntryDidCancelCallback();
          }
          break;
        case 'cardEntryDidSucceedWithResult':
          if (_cardEntryDidSucceedWithResultCallback != null) {
            CardResult result = _standardSerializers.deserializeWith(CardResult.serializer, call.arguments);
            _cardEntryDidSucceedWithResultCallback(result);
          }
          break;
        case 'onGooglePayCanceled':
          if (_googlePayCancelCallback != null) {
            _googlePayCancelCallback();
          }
          break;
        case 'onGooglePayGetNonce':
          if (_googlePayDidSucceedWithResultCallback != null) {
            CardResult result = _standardSerializers.deserializeWith(CardResult.serializer, call.arguments);
            _googlePayDidSucceedWithResultCallback(result);
          }
          break;
        case 'onGooglePayFailed':
          if (_googlePayFailedCallback != null) {
            ErrorInfo errorInfo = _standardSerializers.deserializeWith(ErrorInfo.serializer, call.arguments);
            _googlePayFailedCallback(errorInfo);
          }
          break;
        default:
          throw Exception('unknown method called from native');
      }
    } catch (ex) {
      // TOOD: report error
      print(ex);
    }
    return false;
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> payWithEWallet() async {
    final String version = await _channel.invokeMethod('payWithEWallet');
    return version;
  }

  static Future setApplicationId(String applicationId) async {
    assert(applicationId != null && applicationId.isNotEmpty, 'application should not be null or empty.');
    try {
      Map<String, dynamic> params = <String, dynamic> {
        'applicationId': applicationId,
      };
      await _channel.invokeMethod('setApplicationId', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details['debugCode'], ex.details['debugMessage']);
    }
  }

  static Future startCardEntryFlow(CardEntryDidSucceedWithResultCallback onCardEntrySuccess, CardEntryDidCancelCallback onCardEntryCancel) async {
    _cardEntryDidCancelCallback = onCardEntryCancel;
    _cardEntryDidSucceedWithResultCallback = onCardEntrySuccess;
    try {
      await _channel.invokeMethod('startCardEntryFlow');
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details['debugCode'], ex.details['debugMessage']);
    }
  }

  static Future closeCardEntryForm() async {
    try {
      await _channel.invokeMethod('closeCardEntryForm');
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details['debugCode'], ex.details['debugMessage']);
    }
  }

  static Future showCardProcessingError(String errorMessage) async {
    try {
      Map<String, dynamic> params = <String, dynamic> {
        'errorMessage': errorMessage,
      };
      await _channel.invokeMethod('showCardProcessingError', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details['debugCode'], ex.details['debugMessage']);
    }
  }

  static Future initializeGooglePay(String environment) async {
    assert(environment == GOOGLE_PAY_ENV_PROD || environment == GOOGLE_PAY_ENV_TEST, 'environment should be either GOOGLE_PAY_ENV_PROD or GOOGLE_PAY_ENV_TEST.');
    try {
      Map<String, dynamic> params = <String, dynamic> {
        'environment': environment,
      };
      await _channel.invokeMethod('initializeGooglePay', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details['debugCode'], ex.details['debugMessage']);
    }
  }

  static Future requestGooglePayNonce(String merchantId, String price, String currencyCode, GooglePayDidSucceedWithResultCallback onGooglePayDidSucceedWithResult, GooglePayCancelCallback onGooglePayCanceled, GooglePayFailedCallback onGooglePayFailed) async {
    assert(merchantId != null && merchantId.isNotEmpty, 'merChantId should not be null or empty.');
    assert(price != null && price.isNotEmpty, 'price should not be null or empty.');
    assert(currencyCode != null && currencyCode.isNotEmpty, 'currencyCode should not be null or empty.');

    _googlePayDidSucceedWithResultCallback = onGooglePayDidSucceedWithResult;
    _googlePayCancelCallback = onGooglePayCanceled;
    _googlePayFailedCallback = onGooglePayFailed;
    try {
      Map<String, dynamic> params = <String, dynamic> {
        'merchantId': merchantId,
        'price': price,
        'currencyCode': currencyCode,
      };
      await _channel.invokeMethod('requestGooglePayNonce', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details['debugCode'], ex.details['debugMessage']);
    }
  }
  
  static Future initializeApplePay(String merchantId) async {
     try {
      Map<String, dynamic> params = <String, dynamic> {
        'merchantId': merchantId,
      };
      await _channel.invokeMethod('initializeApplePay', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details['debugCode'], ex.details['debugMessage']);
    }
  }

  static Future<Map> payWithApplePay(String price, String summaryLabel, String countryCode, String currencyCode, ) async {
    try {
      Map<String, dynamic> params = <String, dynamic> {
        'price': price,
        'summaryLabel': summaryLabel,
        'countryCode': countryCode,
        'currencyCode': currencyCode,
      };
      Map cardResult = await _channel.invokeMethod('payWithApplePay', params);
      return cardResult;
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details['debugCode'], ex.details['debugMessage']);
    }
  }
}

class InAppPaymentException implements Exception {

  final String code;

  final String message;

  final String debugCode;

  final String debugMessage;

  InAppPaymentException(
    this.code,
    this.message,
    this.debugCode,
    this.debugMessage,
  ) : assert(code != null), assert(debugCode != null);

  @override
  String toString() => 'PlatformException($code, $message, $debugCode, $debugMessage)';
}
