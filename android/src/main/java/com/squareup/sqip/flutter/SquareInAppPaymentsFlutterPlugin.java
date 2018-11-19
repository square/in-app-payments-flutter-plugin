package com.squareup.sqip.flutter;

import com.squareup.sqip.InAppPaymentsSdk;
import com.squareup.sqip.flutter.internal.CardEntryModule;
import com.squareup.sqip.flutter.internal.GooglePayModule;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class SquareInAppPaymentsFlutterPlugin implements MethodCallHandler {
  private static MethodChannel channel;

  private final CardEntryModule cardEntryModule;
  private final GooglePayModule googlePayModule;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    channel = new MethodChannel(registrar.messenger(), "square_in_app_payments");
    channel.setMethodCallHandler(new SquareInAppPaymentsFlutterPlugin(registrar));
  }

  private SquareInAppPaymentsFlutterPlugin(Registrar registrar) {
    cardEntryModule = new CardEntryModule(registrar, channel);
    googlePayModule = new GooglePayModule(registrar, channel);
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {
    if (call.method.equals("setApplicationId")) {
      String applicationId = call.argument("applicationId");
      InAppPaymentsSdk.INSTANCE.setSquareApplicationId(applicationId);
      result.success(null);
    } else if (call.method.equals("startCardEntryFlow")) {
      cardEntryModule.startCardEntryFlow(result);
    } else if (call.method.equals("completeCardEntry")) {
      cardEntryModule.completeCardEntry(result);
    } else if (call.method.equals("showCardNonceProcessingError")) {
      String errorMessage = call.argument("errorMessage");
      cardEntryModule.showCardNonceProcessingError(result, errorMessage);
    } else if (call.method.equals("initializeGooglePay")) {
      String merchantId = call.argument("merchantId");
      String environment = call.argument("environment");
      assert environment != null;
      googlePayModule.initializeGooglePay(environment, merchantId);
      result.success(null);
    } else if (call.method.equals("canUseGooglePay")) {
      googlePayModule.canUseGooglePay(result);
    } else if (call.method.equals("requestGooglePayNonce")) {
      String price = call.argument("price");
      String currencyCode = call.argument("currencyCode");
      googlePayModule.requestGooglePayNonce(result, price, currencyCode);
    } else {
      result.notImplemented();
    }
  }
}
