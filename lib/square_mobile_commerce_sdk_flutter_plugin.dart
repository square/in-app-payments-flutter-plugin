import 'dart:async';

import 'package:flutter/services.dart';

class SquareMobileCommerceSdkFlutterPlugin {
  static const String GOOGLE_PAY_ENV_PROD = "PROD";
  static const String GOOGLE_PAY_ENV_TEST = "TEST";

  static const MethodChannel _channel =
      const MethodChannel('square_mobile_commerce_sdk_flutter_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> payWithEWallet() async {
    final String version = await _channel.invokeMethod('payWithEWallet');
    return version;
  }

  static Future initialize(String applicationId) async {
    if (applicationId == null) {
      throw Exception("applicationId shouldn't be null");
    }
    try {
      Map<String, dynamic> params = <String, dynamic> {
        'applicationId': applicationId,
      };
      await _channel.invokeMethod('initialize', params);
    } on PlatformException catch (ex) {
      print(ex.toString());
      throw ex;
    }
  }

  static Future<Map> startCardEntryFlow() async {
    try {
      Map cardResult = await _channel.invokeMethod('startCardEntryFlow');
      return cardResult;
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
