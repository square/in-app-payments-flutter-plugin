import 'dart:async';

import 'package:flutter/services.dart';

class SquareMobileCommerceSdkFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('square_mobile_commerce_sdk_flutter_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
