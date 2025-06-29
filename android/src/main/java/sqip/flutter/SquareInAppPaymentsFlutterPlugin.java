/*
 Copyright 2018 Square Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

package sqip.flutter;

import android.content.Context;
import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import sqip.InAppPaymentsSdk;
import sqip.flutter.internal.CardEntryModule;
import sqip.flutter.internal.GooglePayModule;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class SquareInAppPaymentsFlutterPlugin implements MethodCallHandler, FlutterPlugin, ActivityAware {

  private MethodChannel channel;
  private CardEntryModule cardEntryModule;
  private GooglePayModule googlePayModule;
  private Context applicationContext;

  public SquareInAppPaymentsFlutterPlugin() {}

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    this.applicationContext = binding.getApplicationContext();
    channel = new MethodChannel(binding.getBinaryMessenger(), "square_in_app_payments");
    // MethodCallHandler is set in onAttachedToActivity to avoid NPE issues
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    cardEntryModule = null;
    googlePayModule = null;
    channel = null;
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding activityBinding) {
    channel.setMethodCallHandler(this);
    cardEntryModule = new CardEntryModule(applicationContext, channel);
    googlePayModule = new GooglePayModule(applicationContext, channel);

    googlePayModule.attachActivityResultListener(activityBinding, channel);
    cardEntryModule.attachActivityResultListener(activityBinding, channel);
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding activityBinding) {
    onAttachedToActivity(activityBinding);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    cardEntryModule = null;
    googlePayModule = null;
    channel = null;
  }

  @Override
  public void onDetachedFromActivity() {
    cardEntryModule = null;
    googlePayModule = null;
    channel = null;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    switch (call.method) {
      case "setApplicationId":
        String applicationId = call.argument("applicationId");
        InAppPaymentsSdk.INSTANCE.setSquareApplicationId(applicationId);
        result.success(null);
        break;
      case "startCardEntryFlow":
        boolean collectPostalCode = call.argument("collectPostalCode");
        cardEntryModule.startCardEntryFlow(result, collectPostalCode);
        break;
      case "startGiftCardEntryFlow":
        cardEntryModule.startGiftCardEntryFlow(result);
        break;
      case "completeCardEntry":
        cardEntryModule.completeCardEntry(result);
        break;
      case "showCardNonceProcessingError":
        String errorMessage = call.argument("errorMessage");
        cardEntryModule.showCardNonceProcessingError(result, errorMessage);
        break;
      case "initializeGooglePay":
        String squareLocationId = call.argument("squareLocationId");
        int environment = call.argument("environment");
        googlePayModule.initializeGooglePay(squareLocationId, environment);
        result.success(null);
        break;
      case "canUseGooglePay":
        googlePayModule.canUseGooglePay(result);
        break;
      case "requestGooglePayNonce":
        String price = call.argument("price");
        String currencyCode = call.argument("currencyCode");
        int priceStatus = call.argument("priceStatus");
        googlePayModule.requestGooglePayNonce(result, price, currencyCode, priceStatus);
        break;
      case "startCardEntryFlowWithBuyerVerification":
        boolean collectPostal = call.argument("collectPostalCode");
        String locationId = call.argument("squareLocationId");
        String buyerAction = call.argument("buyerAction");
        HashMap<String, Object> moneyMap = call.argument("money");
        HashMap<String, Object> contactMap = call.argument("contact");

        cardEntryModule.startCardEntryFlowWithBuyerVerification(result, collectPostal, locationId, buyerAction, moneyMap, contactMap);
        break;
      case "startBuyerVerificationFlow":
        String locationId2 = call.argument("squareLocationId");
        String buyerAction2 = call.argument("buyerAction");
        HashMap<String, Object> moneyMap2 = call.argument("money");
        HashMap<String, Object> contactMap2 = call.argument("contact");
        String paymentSourceId = call.argument("paymentSourceId");

        cardEntryModule.startBuyerVerificationFlow(result, buyerAction2, moneyMap2, locationId2, contactMap2, paymentSourceId);
        break;
      case "startSecureRemoteCommerce":
        int amount = call.argument("amount");
        // Not yet implemented
        result.notImplemented();
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}
