package sqip.flutter;

import java.util.HashMap;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


import io.flutter.plugin.common.PluginRegistry;
import sqip.InAppPaymentsSdk;
import sqip.flutter.internal.CardEntryModule;
import sqip.flutter.internal.GooglePayModule;

import android.content.Context;
import android.support.annotation.Nullable;
import android.support.annotation.NonNull;
import android.app.Activity;

class CallHandler implements MethodChannel.MethodCallHandler {
    private final CardEntryModule cardEntryModule;
    private final GooglePayModule googlePayModule;
    private PluginActivityLink activityLink;
    private final MethodChannel methodChannel;
    private ActivityPluginBinding activityBinding;

    CallHandler(
            @Nullable PluginActivityLink activityLink,
            @NonNull MethodChannel methodChannel) {
        this.activityLink = activityLink;
        this.methodChannel = methodChannel;
        this.cardEntryModule = new CardEntryModule(this.activityLink,methodChannel);
        this.googlePayModule =  new GooglePayModule(this.activityLink,methodChannel);
    }

    /**
     * Sets the activitylink. Should be called as soon as the the activity is available. When the activity
     * becomes unavailable, call this method again with {@code null}.
     */
    public void setActivityLink (@Nullable PluginActivityLink activityLink) {
        this.activityLink = activityLink;
    }

    @Override
    public void onMethodCall(MethodCall call, final MethodChannel.Result result) {
        if (activityLink.equals(null)) {
            result.error("500", "activity is null", "Caused by activity being null");
        }

        if (call.method.equals("setApplicationId")) {
            String applicationId = call.argument("applicationId");
            InAppPaymentsSdk.INSTANCE.setSquareApplicationId(applicationId);
            result.success(null);
        } else if (call.method.equals("startCardEntryFlow") ) {
            boolean collectPostalCode = call.argument("collectPostalCode");
            cardEntryModule.startCardEntryFlow(result, collectPostalCode);
        } else if (call.method.equals("completeCardEntry")) {
            cardEntryModule.completeCardEntry(result);
        } else if (call.method.equals("showCardNonceProcessingError")) {
            String errorMessage = call.argument("errorMessage");
            cardEntryModule.showCardNonceProcessingError(result, errorMessage);
        } else if (call.method.equals("initializeGooglePay")) {
            String squareLocationId = call.argument("squareLocationId");
            int environment = call.argument("environment");
            googlePayModule.initializeGooglePay(squareLocationId, environment);
            result.success(null);
        } else if (call.method.equals("canUseGooglePay")) {
            googlePayModule.canUseGooglePay(result);
        } else if (call.method.equals("requestGooglePayNonce")) {
            String price = call.argument("price");
            String currencyCode = call.argument("currencyCode");
            int priceStatus = call.argument("priceStatus");
            googlePayModule.requestGooglePayNonce(result, price, currencyCode, priceStatus);
        } else if (call.method.equals("startCardEntryFlowWithBuyerVerification")) {
            boolean collectPostalCode = call.argument("collectPostalCode");
            String squareLocationId = call.argument("squareLocationId");
            String buyerActionString = call.argument("buyerAction");
            HashMap<String, Object> moneyMap = call.argument("money");
            HashMap<String, Object> contactMap = call.argument("contact");

            cardEntryModule.startCardEntryFlowWithBuyerVerification(result, collectPostalCode, squareLocationId, buyerActionString, moneyMap, contactMap);
        } else {
            result.notImplemented();
        }
    }
}
