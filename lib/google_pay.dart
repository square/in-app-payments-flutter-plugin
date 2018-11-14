import 'dart:async';

import 'package:flutter/services.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'models.dart';
import 'serializers.dart';
import 'square_mobile_commerce_sdk.dart';

typedef GooglePayNonceRequestSuccessCallback = void Function(CardDetails result);
typedef GooglePayNonceRequestFailureCallback = void Function(ErrorInfo errorInfo);
typedef GooglePayCancelCallback = void Function();

// ignore: avoid_classes_with_only_static_members
class GooglePay {
  static const String googlePayEnvProdKey = 'PROD';
  static const String googlePayEnvTestKey = 'TEST';

  static final MethodChannel _channel =
      const MethodChannel('square_mobile_commerce_sdk')..setMethodCallHandler(_nativeCallHandler);

  static final _standardSerializers = (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

  static GooglePayNonceRequestSuccessCallback _googlePayNonceRequestSuccessCallback;
  static GooglePayNonceRequestFailureCallback _googlePayNonceRequestFailureCallback;
  static GooglePayCancelCallback _googlePayCancelCallback;


  static Future<dynamic> _nativeCallHandler(MethodCall call) async {
    try {
      switch (call.method) {
        case 'onGooglePayCanceled':
          if (_googlePayCancelCallback != null) {
            _googlePayCancelCallback();
          }
          break;
        case 'onGooglePayNonceRequestSuccess':
          if (_googlePayNonceRequestSuccessCallback != null) {
            var result = _standardSerializers.deserializeWith(CardDetails.serializer, call.arguments);
            _googlePayNonceRequestSuccessCallback(result);
          }
          break;
        case 'onGooglePayNonceRequestFailure':
          if (_googlePayNonceRequestFailureCallback != null) {
            var errorInfo = _standardSerializers.deserializeWith(ErrorInfo.serializer, call.arguments);
            _googlePayNonceRequestFailureCallback(errorInfo);
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

  static Future initializeGooglePay(String environment) async {
    assert(environment == googlePayEnvProdKey || environment == googlePayEnvTestKey, 'environment should be either GOOGLE_PAY_ENV_PROD or GOOGLE_PAY_ENV_TEST.');
    try {
      var params = <String, dynamic> {
        'environment': environment,
      };
      await _channel.invokeMethod('initializeGooglePay', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[InAppPaymentException.debugCodeKey], ex.details[InAppPaymentException.debugMessageKey]);
    }
  }

  static Future requestGooglePayNonce(String merchantId, String price, String currencyCode, GooglePayNonceRequestSuccessCallback onGooglePayNonceRequestSuccess, GooglePayNonceRequestFailureCallback onGooglePayNonceRequestFailure, GooglePayCancelCallback onGooglePayCanceled) async {
    assert(merchantId != null && merchantId.isNotEmpty, 'merchantId should not be null or empty.');
    assert(price != null && price.isNotEmpty, 'price should not be null or empty.');
    assert(currencyCode != null && currencyCode.isNotEmpty, 'currencyCode should not be null or empty.');

    _googlePayNonceRequestSuccessCallback = onGooglePayNonceRequestSuccess;
    _googlePayNonceRequestFailureCallback = onGooglePayNonceRequestFailure;
    _googlePayCancelCallback = onGooglePayCanceled;

    try {
      var params = <String, dynamic> {
        'merchantId': merchantId,
        'price': price,
        'currencyCode': currencyCode,
      };
      await _channel.invokeMethod('requestGooglePayNonce', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[InAppPaymentException.debugCodeKey], ex.details[InAppPaymentException.debugMessageKey]);
    }
  }
}