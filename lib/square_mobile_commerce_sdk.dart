import 'dart:async';

import 'package:flutter/services.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'models.dart';
import 'serializers.dart';

typedef CardEntryDidCancelCallback = void Function();
typedef CardEntryDidSucceedWithResultCallback = void Function(CardResult result);
typedef GooglePayCancelCallback = void Function();
typedef GooglePayDidSucceedWithResultCallback = void Function(CardResult result);
typedef GooglePayFailedCallback = void Function(ErrorInfo errorInfo);
typedef ApplePayDidSucceedWithResultCallback = void Function(CardResult result);
typedef ApplePayFailedCallback = void Function(ErrorInfo errorInfo);

// ignore: avoid_classes_with_only_static_members
class SquareMobileCommerceSdkFlutterPlugin {
  static const String googlePayEnvProdKey = 'PROD';
  static const String googlePayEnvTestKey = 'TEST';
  static const String debugCodeKey = 'debugCode';
  static const String debugMessageKey = 'debugMessage';

  static final MethodChannel _channel =
      const MethodChannel('square_mobile_commerce_sdk')..setMethodCallHandler(_nativeCallHandler);

  static final _standardSerializers = (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

  static CardEntryDidCancelCallback _cardEntryDidCancelCallback;
  static CardEntryDidSucceedWithResultCallback _cardEntryDidSucceedWithResultCallback;

  static GooglePayCancelCallback _googlePayCancelCallback;
  static GooglePayDidSucceedWithResultCallback _googlePayDidSucceedWithResultCallback;
  static GooglePayFailedCallback _googlePayFailedCallback;

  static ApplePayDidSucceedWithResultCallback _applePayDidSucceedWithResultCallback;
  static ApplePayFailedCallback _applePayFailedCallback;

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
            var result = _standardSerializers.deserializeWith(CardResult.serializer, call.arguments);
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
            var result = _standardSerializers.deserializeWith(CardResult.serializer, call.arguments);
            _googlePayDidSucceedWithResultCallback(result);
          }
          break;
        case 'onGooglePayFailed':
          if (_googlePayFailedCallback != null) {
            var errorInfo = _standardSerializers.deserializeWith(ErrorInfo.serializer, call.arguments);
            _googlePayFailedCallback(errorInfo);
          }
          break;
        case 'onApplePayGetNonce':
          if (_applePayDidSucceedWithResultCallback != null) {
            var result = _standardSerializers.deserializeWith(CardResult.serializer, call.arguments);
            _applePayDidSucceedWithResultCallback(result);
          }
          break;
        case 'onApplePayFailed':
          if (_applePayFailedCallback != null) {
            var errorInfo = _standardSerializers.deserializeWith(ErrorInfo.serializer, call.arguments);
            _applePayFailedCallback(errorInfo);
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
      var params = <String, dynamic> {
        'applicationId': applicationId,
      };
      await _channel.invokeMethod('setApplicationId', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[debugCodeKey], ex.details[debugMessageKey]);
    }
  }

  static Future startCardEntryFlow(CardEntryDidSucceedWithResultCallback onCardEntrySuccess, CardEntryDidCancelCallback onCardEntryCancel) async {
    _cardEntryDidCancelCallback = onCardEntryCancel;
    _cardEntryDidSucceedWithResultCallback = onCardEntrySuccess;
    try {
      await _channel.invokeMethod('startCardEntryFlow');
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[debugCodeKey], ex.details[debugMessageKey]);
    }
  }

  static Future closeCardEntryForm() async {
    try {
      await _channel.invokeMethod('closeCardEntryForm');
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[debugCodeKey], ex.details[debugMessageKey]);
    }
  }

  static Future showCardProcessingError(String errorMessage) async {
    try {
      var params = <String, dynamic> {
        'errorMessage': errorMessage,
      };
      await _channel.invokeMethod('showCardProcessingError', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[debugCodeKey], ex.details[debugMessageKey]);
    }
  }

  static Future initializeGooglePay(String environment) async {
    assert(environment == googlePayEnvProdKey || environment == googlePayEnvTestKey, 'environment should be either GOOGLE_PAY_ENV_PROD or GOOGLE_PAY_ENV_TEST.');
    try {
      var params = <String, dynamic> {
        'environment': environment,
      };
      await _channel.invokeMethod('initializeGooglePay', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[debugCodeKey], ex.details[debugMessageKey]);
    }
  }

  static Future requestGooglePayNonce(String merchantId, String price, String currencyCode, GooglePayDidSucceedWithResultCallback onGooglePayDidSucceedWithResult, GooglePayCancelCallback onGooglePayCanceled, GooglePayFailedCallback onGooglePayFailed) async {
    assert(merchantId != null && merchantId.isNotEmpty, 'merchantId should not be null or empty.');
    assert(price != null && price.isNotEmpty, 'price should not be null or empty.');
    assert(currencyCode != null && currencyCode.isNotEmpty, 'currencyCode should not be null or empty.');

    _googlePayDidSucceedWithResultCallback = onGooglePayDidSucceedWithResult;
    _googlePayCancelCallback = onGooglePayCanceled;
    _googlePayFailedCallback = onGooglePayFailed;

    try {
      var params = <String, dynamic> {
        'merchantId': merchantId,
        'price': price,
        'currencyCode': currencyCode,
      };
      await _channel.invokeMethod('requestGooglePayNonce', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[debugCodeKey], ex.details[debugMessageKey]);
    }
  }
  
  static Future initializeApplePay(String merchantId) async {
     try {
      var params = <String, dynamic> {
        'merchantId': merchantId,
      };
      await _channel.invokeMethod('initializeApplePay', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[debugCodeKey], ex.details[debugMessageKey]);
    }
  }

  static Future requestApplePayNonce(String price, String summaryLabel, String countryCode, String currencyCode, ApplePayDidSucceedWithResultCallback onApplePayDidSucceedWithResult, ApplePayFailedCallback onApplePayFailed) async {
    assert(summaryLabel != null && summaryLabel.isNotEmpty, 'summaryLabel should not be null or empty.');
    assert(price != null && price.isNotEmpty, 'price should not be null or empty.');
    assert(countryCode != null && countryCode.isNotEmpty, 'countryCode should not be null or empty.');
    assert(currencyCode != null && currencyCode.isNotEmpty, 'currencyCode should not be null or empty.');

    _applePayDidSucceedWithResultCallback = onApplePayDidSucceedWithResult;
    _applePayFailedCallback = onApplePayFailed;

    try {
      var params = <String, dynamic> {
        'price': price,
        'summaryLabel': summaryLabel,
        'countryCode': countryCode,
        'currencyCode': currencyCode,
      };
      await _channel.invokeMethod('requestApplePayNonce', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[debugCodeKey], ex.details[debugMessageKey]);
    }
  }

  static Future completeApplePayAuthorization() async {
    try {
      await _channel.invokeMethod('completeApplePayAuthorization');
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[debugCodeKey], ex.details[debugMessageKey]);
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
