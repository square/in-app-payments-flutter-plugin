import 'dart:async';

import 'package:flutter/services.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'models.dart';
import 'serializers.dart';
import 'square_mobile_commerce_sdk.dart';

typedef ApplePayNonceRequestSuccessCallback = void Function(CardDetails result);
typedef ApplePayNonceRequestFailureCallback = void Function(ErrorInfo errorInfo);
typedef ApplePayCompleteCallback = void Function();

// ignore: avoid_classes_with_only_static_members
class ApplePay {

  static final MethodChannel _channel =
      const MethodChannel('square_mobile_commerce_sdk')..setMethodCallHandler(_nativeCallHandler);

  static final _standardSerializers = (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

  static ApplePayNonceRequestSuccessCallback _applePayNonceRequestSuccessCallback;
  static ApplePayNonceRequestFailureCallback _applePayNonceRequestFailureCallback;
  static ApplePayCompleteCallback _applePayCompleteCallback;

  static Future<dynamic> _nativeCallHandler(MethodCall call) async {
    try {
      switch (call.method) {
        case 'onApplePayNonceRequestSuccess':
          if (_applePayNonceRequestSuccessCallback != null) {
            var result = _standardSerializers.deserializeWith(CardDetails.serializer, call.arguments);
            _applePayNonceRequestSuccessCallback(result);
          }
          break;
        case 'onApplePayNonceRequestFailure':
          if (_applePayNonceRequestFailureCallback != null) {
            var errorInfo = _standardSerializers.deserializeWith(ErrorInfo.serializer, call.arguments);
            _applePayNonceRequestFailureCallback(errorInfo);
          }
          break;
        case 'onApplePayComplete':
          if (_applePayCompleteCallback != null) {
            _applePayCompleteCallback();
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

  static Future<bool> get canUseApplePay async {
     try {
      return await _channel.invokeMethod('canUseApplePay');
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[InAppPaymentException.debugCodeKey], ex.details[InAppPaymentException.debugMessageKey]);
    }
  }
  
  static Future initializeApplePay(String merchantId) async {
     try {
      var params = <String, dynamic> {
        'merchantId': merchantId,
      };
      await _channel.invokeMethod('initializeApplePay', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[InAppPaymentException.debugCodeKey], ex.details[InAppPaymentException.debugMessageKey]);
    }
  }

  static Future requestApplePayNonce(String price, String summaryLabel, String countryCode, String currencyCode,
    ApplePayNonceRequestSuccessCallback onApplePayNonceRequestSuccess, ApplePayNonceRequestFailureCallback onApplePayNonceRequestFailure, ApplePayCompleteCallback onApplePayComplete) async {
    assert(summaryLabel != null && summaryLabel.isNotEmpty, 'summaryLabel should not be null or empty.');
    assert(price != null && price.isNotEmpty, 'price should not be null or empty.');
    assert(countryCode != null && countryCode.isNotEmpty, 'countryCode should not be null or empty.');
    assert(currencyCode != null && currencyCode.isNotEmpty, 'currencyCode should not be null or empty.');

    _applePayNonceRequestSuccessCallback = onApplePayNonceRequestSuccess;
    _applePayNonceRequestFailureCallback = onApplePayNonceRequestFailure;
    _applePayCompleteCallback = onApplePayComplete;

    try {
      var params = <String, dynamic> {
        'price': price,
        'summaryLabel': summaryLabel,
        'countryCode': countryCode,
        'currencyCode': currencyCode,
      };
      await _channel.invokeMethod('requestApplePayNonce', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[InAppPaymentException.debugCodeKey], ex.details[InAppPaymentException.debugMessageKey]);
    }
  }

  static Future completeApplePayAuthorization({bool isSuccess, String errorMessage = ''}) async {
    try {
      var params = <String, dynamic> {
        'isSuccess': isSuccess,
        'errorMessage': errorMessage,
      };
      await _channel.invokeMethod('completeApplePayAuthorization', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[InAppPaymentException.debugCodeKey], ex.details[InAppPaymentException.debugMessageKey]);
    }
  }
}
