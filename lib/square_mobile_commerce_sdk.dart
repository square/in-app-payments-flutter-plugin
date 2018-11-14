import 'dart:async';

import 'package:flutter/services.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'models.dart';
import 'serializers.dart';

typedef CardEntryDidCancelCallback = void Function();
typedef CardEntryCompleteCallback = void Function();
typedef CardEntryGetCardDetailsCallback = void Function(CardDetails result);

// ignore: avoid_classes_with_only_static_members
class InAppPayments {
  static final MethodChannel _channel =
      const MethodChannel('square_mobile_commerce_sdk')..setMethodCallHandler(_nativeCallHandler);

  static final _standardSerializers = (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

  static CardEntryDidCancelCallback _cardEntryDidCancelCallback;
  static CardEntryGetCardDetailsCallback _cardEntryGetCardDetailsCallback;
  static CardEntryCompleteCallback _cardEntryCompleteCallback;

  static Future<dynamic> _nativeCallHandler(MethodCall call) async {
    try {
      switch (call.method) {
        case 'cardEntryDidCancel':
          if (_cardEntryDidCancelCallback != null) {
            _cardEntryDidCancelCallback();
          }
          break;
        case 'didObtainCardDetails':
          if (_cardEntryGetCardDetailsCallback != null) {
            var result = _standardSerializers.deserializeWith(CardDetails.serializer, call.arguments);
            _cardEntryGetCardDetailsCallback(result);
          }
          break;
        case 'cardEntryComplete':
          if (_cardEntryCompleteCallback != null) {
            _cardEntryCompleteCallback();
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
    assert(applicationId != null && applicationId.isNotEmpty, 'application should not be null or empty.');
    try {
      var params = <String, dynamic> {
        'applicationId': applicationId,
      };
      await _channel.invokeMethod('setApplicationId', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[InAppPaymentException.debugCodeKey], ex.details[InAppPaymentException.debugMessageKey]);
    }
  }

  static Future startCardEntryFlow(CardEntryGetCardDetailsCallback onCardEntryGetCardDetails, CardEntryDidCancelCallback onCardEntryCancel) async {
    _cardEntryDidCancelCallback = onCardEntryCancel;
    _cardEntryGetCardDetailsCallback = onCardEntryGetCardDetails;
    try {
      await _channel.invokeMethod('startCardEntryFlow');
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[InAppPaymentException.debugCodeKey], ex.details[InAppPaymentException.debugMessageKey]);
    }
  }

  static Future completeCardEntry(CardEntryCompleteCallback onCardEntryCompelete) async {
    _cardEntryCompleteCallback = onCardEntryCompelete;
    try {
      await _channel.invokeMethod('completeCardEntry');
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[InAppPaymentException.debugCodeKey], ex.details[InAppPaymentException.debugMessageKey]);
    }
  }

  static Future showCardProcessingError(String errorMessage) async {
    try {
      var params = <String, dynamic> {
        'errorMessage': errorMessage,
      };
      await _channel.invokeMethod('showCardProcessingError', params);
    } on PlatformException catch (ex) {
      throw InAppPaymentException(ex.code, ex.message, ex.details[InAppPaymentException.debugCodeKey], ex.details[InAppPaymentException.debugMessageKey]);
    }
  }
}

class InAppPaymentException implements Exception {
  static const String debugCodeKey = 'debugCode';
  static const String debugMessageKey = 'debugMessage';

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
