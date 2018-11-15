package com.squareup.sqip.flutter;

import com.squareup.sqip.InAppPaymentsSdk;
import com.squareup.sqip.flutter.internal.CardEntryModule;
import com.squareup.sqip.flutter.internal.ErrorHandlerUtils;
import com.squareup.sqip.flutter.internal.GooglePayModule;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class SquareInAppPaymentsFlutterPlugin implements MethodCallHandler {
  private static MethodChannel channel;

  private final Registrar currentRegistrar;

  private CardEntryModule cardEntryModule;
  private GooglePayModule googlePayModule;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    channel = new MethodChannel(registrar.messenger(), "square_in_app_payments");
    channel.setMethodCallHandler(new SquareInAppPaymentsFlutterPlugin(registrar));
  }

  private SquareInAppPaymentsFlutterPlugin(Registrar registrar) {
    currentRegistrar = registrar;
    cardEntryModule = new CardEntryModule(currentRegistrar, channel);
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("setApplicationId")) {
      String applicationId = call.argument("applicationId");
      InAppPaymentsSdk.INSTANCE.setSquareApplicationId(applicationId);
      result.success(null);
    } else if (call.method.equals("startCardEntryFlow")) {
      cardEntryModule.startCardEntryFlow(result);
    } else if (call.method.equals("completeCardEntry")) {
      cardEntryModule.completeCardEntry(result);
    } else if (call.method.equals("showCardProcessingError")) {
      String errorMessage = call.argument("errorMessage");
      cardEntryModule.showCardProcessingError(result, errorMessage);
    } else if (call.method.equals("initializeGooglePay")) {
      String environment = call.argument("environment");
      googlePayModule = new GooglePayModule(currentRegistrar, environment, channel);
      result.success(null);
    } else if (call.method.equals("canUseGooglePay")) {
      if (googlePayModule == null) {
        result.error(ErrorHandlerUtils.USAGE_ERROR,
            ErrorHandlerUtils.getPluginErrorMessage("fl_mcomm_google_pay_not_initialize"),
            ErrorHandlerUtils.getDebugErrorObject("fl_mcomm_google_pay_not_initialize", "You must initialize google pay before use it."));
        return;
      }
      googlePayModule.canUserGooglePay(result);
    } else if (call.method.equals("requestGooglePayNonce")) {
      if (googlePayModule == null) {
        result.error(ErrorHandlerUtils.USAGE_ERROR,
            ErrorHandlerUtils.getPluginErrorMessage("fl_mcomm_google_pay_not_initialize"),
            ErrorHandlerUtils.getDebugErrorObject("fl_mcomm_google_pay_not_initialize", "You must initialize google pay before use it."));
        return;
      }
      String merchantId = call.argument("merchantId");
      String price = call.argument("price");
      String currencyCode = call.argument("currencyCode");
      googlePayModule.requestGooglePayNonce(result, merchantId, price, currencyCode);
    } else {
      result.notImplemented();
    }
  }
}
