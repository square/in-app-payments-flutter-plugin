package com.squareup.mcomm.flutter;

import android.app.Activity;
import com.squareup.mcomm.MobileCommerceSdk;
import com.squareup.mcomm.flutter.internal.CardEntryModule;
import com.squareup.mcomm.flutter.internal.ErrorHandlerUtils;
import com.squareup.mcomm.flutter.internal.GooglePayModule;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** SquareMobileCommerceSdkFlutterPlugin */
public class SquareMobileCommerceSdkFlutterPlugin implements MethodCallHandler {
  private static MethodChannel channel;

  private final Activity currentActivity;
  private final Registrar currentRegistrar;

  private CardEntryModule cardEntryModule;
  private GooglePayModule googlePayModule;
  private MobileCommerceSdk mobileCommerceSdk;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    channel = new MethodChannel(registrar.messenger(), "square_mobile_commerce_sdk");
    channel.setMethodCallHandler(new SquareMobileCommerceSdkFlutterPlugin(registrar));
  }

  private SquareMobileCommerceSdkFlutterPlugin(Registrar registrar) {
    currentRegistrar = registrar;
    currentActivity = registrar.activity();
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("setApplicationId")) {
      String applicationId = call.argument("applicationId");
      mobileCommerceSdk = new MobileCommerceSdk(applicationId);
      cardEntryModule = new CardEntryModule(currentActivity, mobileCommerceSdk, channel);
      result.success(null);
    } else if (call.method.equals("startCardEntryFlow")) {
      cardEntryModule.startCardEntryFlow(result);
    } else if (call.method.equals("closeCardEntryForm")) {
      cardEntryModule.closeCardEntryForm(result);
    } else if (call.method.equals("showCardProcessingError")) {
      String errorMessage = call.argument("errorMessage");
      cardEntryModule.showCardProcessingError(result, errorMessage);
    } else if (call.method.equals("initializeGooglePay")) {
      if (googlePayModule != null) {
        result.error(ErrorHandlerUtils.USAGE_ERROR,
            ErrorHandlerUtils.getPluginErrorMessage("fl_mcomm_dup_google_pay_initialize"),
            ErrorHandlerUtils.getDebugErrorObject("fl_mcomm_dup_google_pay_initialize", "Initialize google pay twice is not allowed."));
        return;
      }
      String environment = call.argument("environment");
      googlePayModule = new GooglePayModule(currentRegistrar, mobileCommerceSdk, environment, channel);
      result.success(null);
    } else if (call.method.equals("requestGooglePayNonce")) {
      String merchantId = call.argument("merchantId");
      String price = call.argument("price");
      String currencyCode = call.argument("currencyCode");
      googlePayModule.requestGooglePayNonce(result, merchantId, price, currencyCode);
    } else {
      result.notImplemented();
    }
  }
}
