import 'dart:async';

import 'package:flutter/services.dart';

typedef void CardEntryDidCancelCallback();
typedef void CardEntryDidSucceedWithResultCallback(Map result);

class SquareMobileCommerceSdkFlutterPlugin {
  static const String GOOGLE_PAY_ENV_PROD = "PROD";
  static const String GOOGLE_PAY_ENV_TEST = "TEST";

  static final MethodChannel _channel =
      const MethodChannel('square_mobile_commerce_sdk_flutter_plugin')..setMethodCallHandler(_nativeCallHandler);

  static CardEntryDidCancelCallback _cardEntryDidCancelCallback;
  static CardEntryDidSucceedWithResultCallback _cardEntryDidSucceedWithResultCallback;

  static Future<dynamic> _nativeCallHandler(MethodCall call) async {
    switch (call.method) {
      case 'cardEntryDidCancel':
        print('cardEntryDidCancel is called');
        if (_cardEntryDidCancelCallback != null) {
          _cardEntryDidCancelCallback();
        }
        break;
      case 'cardEntryDidSucceedWithResult':
        print('cardEntryDidSucceedWithResult is called');
        if (_cardEntryDidSucceedWithResultCallback != null) {
          _cardEntryDidSucceedWithResultCallback(call.arguments);
        }
        break;
      default:
        throw Exception('unknown method called from native');
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
    if (applicationId == null) {
      throw Exception("applicationId shouldn't be null");
    }
    try {
      Map<String, dynamic> params = <String, dynamic> {
        'applicationId': applicationId,
      };
      await _channel.invokeMethod('setApplicationId', params);
    } on PlatformException catch (ex) {
      print(ex.toString());
      throw ex;
    }
  }

  static Future<Map> startCardEntryFlow(CardEntryDidSucceedWithResultCallback cardEntrySuccessCallback, CardEntryDidCancelCallback cardEntryCancelCallback) async {
    _cardEntryDidCancelCallback = cardEntryCancelCallback;
    _cardEntryDidSucceedWithResultCallback = cardEntrySuccessCallback;
    try {
      Map cardResult = await _channel.invokeMethod('startCardEntryFlow');
      return cardResult;
    } on PlatformException catch (ex) {
      print(ex.toString());
      throw ex;
    }
  }

  static Future<void> closeCardEntryForm() async {
    try {
      await _channel.invokeMethod('closeCardEntryForm');
    } on PlatformException catch (ex) {
      print(ex.toString());
      throw ex;
    }
  }

  static Future<void> showCardProcessingError(String errorMessage) async {
    try {
      Map<String, dynamic> params = <String, dynamic> {
        'errorMessage': errorMessage,
      };
      await _channel.invokeMethod('showCardProcessingError', params);
    } on PlatformException catch (ex) {
      print(ex.toString());
      throw ex;
    }
  }

  static Future initializeGooglePay(String environment) async {
    try {
      Map<String, dynamic> params = <String, dynamic> {
        'environment': environment,
      };
      await _channel.invokeMethod('initializeGooglePay', params);
    } on PlatformException catch (ex) {
      print(ex.toString());
      throw ex;
    }
  }

  static Future<Map> payWithGooglePay(String merchantId, String price, String currencyCode) async {
    try {
      Map<String, dynamic> params = <String, dynamic> {
        'merchantId': merchantId,
        'price': price,
        'currencyCode': currencyCode,
      };
      Map cardResult = await _channel.invokeMethod('payWithGooglePay', params);
      return cardResult;
    } on PlatformException catch (ex) {
      print(ex.toString());
      throw ex;
    }
  }
  
  static Future initializeApplePay(String merchantId) async {
     try {
      Map<String, dynamic> params = <String, dynamic> {
        'merchantId': merchantId,
      };
      await _channel.invokeMethod('initializeApplePay', params);
    } on PlatformException catch (ex) {
      print(ex.toString());
      throw ex;
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
      print(ex.toString());
      throw ex;
    }
  }
}
