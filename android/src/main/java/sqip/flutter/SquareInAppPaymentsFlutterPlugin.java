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
        boolean sce_collectPostalCode = call.argument("collectPostalCode");
        cardEntryModule.startCardEntryFlow(result, sce_collectPostalCode);
        break;
      case "startCardEntryFlowWithBuyerVerification":
        boolean sce_bv_collectPostalCode = call.argument("collectPostalCode");
        String sce_bv_locationId = call.argument("squareLocationId");
        String sce_bv_buyerAction = call.argument("buyerAction");
        HashMap<String, Object> sce_bv_moneyMap = call.argument("money");
        HashMap<String, Object> sce_bv_contactMap = call.argument("contact");
        String sce_bv_paymentSourceId = call.argument("paymentSourceId");

        cardEntryModule.startCardEntryFlowWithBuyerVerification(
          result, 
          sce_bv_collectPostalCode, 
          sce_bv_locationId, 
          sce_bv_buyerAction, 
          sce_bv_moneyMap, 
          sce_bv_contactMap,
          sce_bv_paymentSourceId);
        break;
      case "startGiftCardEntryFlow":
        cardEntryModule.startGiftCardEntryFlow(result);
        break;
      case "startGiftCardEntryFlowWithBuyerVerification":
        String sge_bv_locationId = call.argument("squareLocationId");
        String sge_bv_buyerAction = call.argument("buyerAction");
        HashMap<String, Object> sge_bv_moneyMap = call.argument("money");
        HashMap<String, Object> sge_bv_contactMap = call.argument("contact");
        String sge_bv_paymentSourceId = call.argument("paymentSourceId");
        cardEntryModule.startGiftCardEntryFlowWithBuyerVerification(
          result,
          sge_bv_locationId,
          sge_bv_buyerAction,
          sge_bv_moneyMap,
          sge_bv_contactMap,
          sge_bv_paymentSourceId);
        break;
      case "completeCardEntry":
        cardEntryModule.completeCardEntry(result);
        break;
      case "showCardNonceProcessingError":
        String errorMessage = call.argument("errorMessage");
        cardEntryModule.showCardNonceProcessingError(result, errorMessage);
        break;
      case "initializeGooglePay":
        String igp_squareLocationId = call.argument("squareLocationId");
        int igp_environment = call.argument("environment");
        googlePayModule.initializeGooglePay(igp_squareLocationId, igp_environment);
        result.success(null);
        break;
      case "canUseGooglePay":
        googlePayModule.canUseGooglePay(result);
        break;
      case "requestGooglePayNonce":
        String rgp_price = call.argument("price");
        String rgp_currencyCode = call.argument("currencyCode");
        int rgp_priceStatus = call.argument("priceStatus");
        googlePayModule.requestGooglePayNonce(result, rgp_price, rgp_currencyCode, rgp_priceStatus);
        break;
      case "requestGooglePayNonceWithBuyerVerification":
        String rgp_bv_locationId = call.argument("squareLocationId");
        String rgp_bv_buyerAction = call.argument("buyerAction");
        HashMap<String, Object> rgp_bv_moneyMap = call.argument("money");
        HashMap<String, Object> rgp_bv_contactMap = call.argument("contact");
        String rgp_bv_paymentSourceId = call.argument("paymentSourceId");
        String rgp_bv_price = call.argument("price");
        String rgp_bv_currencyCode = call.argument("currencyCode");
        int rgp_bv_priceStatus = call.argument("priceStatus");

        googlePayModule.requestGooglePayNonceWithBuyerVerification(
          result,
          rgp_bv_buyerAction,
          rgp_bv_moneyMap,
          rgp_bv_locationId,
          rgp_bv_contactMap,
          rgp_bv_paymentSourceId,
          rgp_bv_price,
          rgp_bv_currencyCode,
          rgp_bv_priceStatus);
        break;
      case "startBuyerVerificationFlow":
        String bv_locationId = call.argument("squareLocationId");
        String bv_buyerAction = call.argument("buyerAction");
        HashMap<String, Object> bv_moneyMap = call.argument("money");
        HashMap<String, Object> bv_contactMap = call.argument("contact");
        String bv_paymentSourceId = call.argument("paymentSourceId");

        cardEntryModule.startBuyerVerificationFlow(
          result, 
          bv_buyerAction, 
          bv_moneyMap, 
          bv_locationId, 
          bv_contactMap, 
          bv_paymentSourceId);
        break;
      case "startSecureRemoteCommerce":
        int amount = call.argument("amount");
        // Not yet implemented
        result.notImplemented();
        break;
      case "startSecureRemoteCommerceWithBuyerVerification":
        // Not yet implemented
        result.notImplemented();
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}
