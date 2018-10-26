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
package com.squareup.mcomm.flutter.internal;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
import com.google.android.gms.common.api.Status;
import com.google.android.gms.wallet.AutoResolveHelper;
import com.google.android.gms.wallet.CardRequirements;
import com.google.android.gms.wallet.PaymentData;
import com.google.android.gms.wallet.PaymentDataRequest;
import com.google.android.gms.wallet.PaymentMethodTokenizationParameters;
import com.google.android.gms.wallet.PaymentsClient;
import com.google.android.gms.wallet.TransactionInfo;
import com.google.android.gms.wallet.Wallet;
import com.google.android.gms.wallet.WalletConstants;
import com.squareup.mcomm.CreateNonceCallback;
import com.squareup.mcomm.CreateNonceResult;
import com.squareup.mcomm.GooglePayManager;
import com.squareup.mcomm.MobileCommerceSdk;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

final public class GooglePayModule {

  // Android only flutter plugin errors and messages
  private static final String FL_AUTHORIZE_ALREADY_IN_PROGRESS = "fl_authorize_already_in_progress";
  private static final String FL_DEAUTHORIZE_ALREADY_IN_PROGRESS = "fl_deauthorize_already_in_progress";
  private static final String FL_MESSAGE_AUTHORIZE_ALREADY_IN_PROGRESS = "Authorization is already in progress. Please wait for authorizeAsync to complete.";
  private static final String FL_MESSAGE_DEAUTHORIZE_ALREADY_IN_PROGRESS = "Deauthorization is already in progress. Please wait for deauthorizeAsync to complete.";

  private static final int LOAD_PAYMENT_DATA_REQUEST_CODE = 1;
  private static final List<Integer> CARD_NETWORKS = Arrays.asList(
      WalletConstants.CARD_NETWORK_AMEX,
      WalletConstants.CARD_NETWORK_DISCOVER,
      WalletConstants.CARD_NETWORK_JCB,
      WalletConstants.CARD_NETWORK_VISA,
      WalletConstants.CARD_NETWORK_MASTERCARD,
      WalletConstants.CARD_NETWORK_OTHER
  );

  private final Activity currentActivity;
  private final GooglePayManager googlePayManager;
  private final PaymentsClient googlePayClients;
  private final MethodChannel channel;
  private MethodChannel.Result googlePayPluginResult;

  public GooglePayModule(PluginRegistry.Registrar registrar, MobileCommerceSdk mobileCommerceSdk, String environment, final MethodChannel channel) {
    currentActivity = registrar.activity();
    this.channel = channel;
    int env = WalletConstants.ENVIRONMENT_TEST;
    if (environment.equals("PROD")) {
      env = WalletConstants.ENVIRONMENT_PRODUCTION;
    }
    googlePayManager = mobileCommerceSdk.googlePayManager(currentActivity.getApplication());
    googlePayClients = Wallet.getPaymentsClient(
        currentActivity,
        (new Wallet.WalletOptions.Builder())
            .setEnvironment(env)
            .build()
    );

    // Register callback when nonce is exchanged from square google pay service with google pay token
    googlePayManager.addCreateNonceCallback(new CreateNonceCallback() {
      @Override public void onResult(CreateNonceResult googlePayResult) {
        if (googlePayResult.isSuccess()) {
          HashMap<String, Object> mapToReturn = new HashMap<>();
          mapToReturn.put("nonce", googlePayResult.getSuccessValue().getCardResult().getNonce());
          mapToReturn.put("card", googlePayResult.getSuccessValue().getCardResult().getCard().toString());
          channel.invokeMethod("onGooglePayGetNonce", mapToReturn);
          //googlePayPluginResult.success(mapToReturn);
          Log.d("mCommPlugin", "nonce got: " + googlePayResult.getSuccessValue().getCardResult().getNonce());
        } else if (googlePayResult.isError()) {
          Map<String, String> errorInfo = new HashMap<>();
          // TOOD: get google pay token exchange failure information
          errorInfo.put("message", "Failed to exchange nonce with google pay token.");
          channel.invokeMethod("onGooglePayFailed", errorInfo);
          //googlePayPluginResult.error("fl_mcomm_google_pay_failed", "", null);
          Log.d("mCommPlugin", "failed to checkout");
        }
        //googlePayPluginResult = null;
      }
    });

    // Register callback when google pay activity is dismissed
    registrar.addActivityResultListener(new PluginRegistry.ActivityResultListener() {
      @Override public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == LOAD_PAYMENT_DATA_REQUEST_CODE) {
          Map<String, String> errorInfo;
          switch (resultCode) {
            case Activity.RESULT_OK:
              PaymentData paymentData = PaymentData.getFromIntent(data);
              String googlePayToken = paymentData.getPaymentMethodToken().getToken();
              googlePayManager.createNonce(googlePayToken);
              break;
            case Activity.RESULT_CANCELED:
              channel.invokeMethod("onGooglePayCanceled", null);
              //googlePayPluginResult.error("fl_mcomm_google_pay_canceled", "", null);
              //googlePayPluginResult = null;
              break;
            case AutoResolveHelper.RESULT_ERROR:
              Status status = AutoResolveHelper.getStatusFromIntent(data);
              errorInfo = new HashMap<>();
              errorInfo.put("message", status.getStatusMessage());
              channel.invokeMethod("onGooglePayFailed", errorInfo);
              // Log the status for debugging.
              // Generally, there is no need to show an error to the user.
              // The Google Pay payment sheet will present any account errors.
              Log.e("mCommPlugin", "google pay result error: " + status.getStatusMessage());
              //googlePayPluginResult.error("fl_mcomm_google_pay_error",  status.getStatusMessage(), null);
              //googlePayPluginResult = null;
              break;
            default:
              errorInfo = new HashMap<>();
              errorInfo.put("message", "Got unknown google pay activity result.");
              channel.invokeMethod("onGooglePayFailed", errorInfo);
              //googlePayPluginResult = null;
          }
        }
        return false;
      }
    });
  }

  public void requestGooglePayNonce(MethodChannel.Result result, String merchantId, String price, String currencyCode) {
    //if (googlePayPluginResult != null) {
    //  result.error("fl_mcomm_dup_google_pay", "A google pay session is in progress. Close it before start a new session.", null);
    //  return;
    //}

    //googlePayPluginResult = result;
    AutoResolveHelper.resolveTask(
        googlePayClients.loadPaymentData(createPaymentChargeRequest(merchantId, price, currencyCode)),
        currentActivity,
        LOAD_PAYMENT_DATA_REQUEST_CODE);
    result.success(null);
  }

  private PaymentDataRequest createPaymentChargeRequest(String merchantId, String price, String currencyCode) {
    PaymentDataRequest.Builder request = PaymentDataRequest
        .newBuilder().setTransactionInfo(
            TransactionInfo.newBuilder()
                .setTotalPriceStatus(
                    WalletConstants.TOTAL_PRICE_STATUS_FINAL)
                .setTotalPrice(price)
                .setCurrencyCode(currencyCode)
                .build()
        ).addAllowedPaymentMethod(WalletConstants.PAYMENT_METHOD_CARD)
        .setCardRequirements(
            CardRequirements.newBuilder()
                .addAllowedCardNetworks(CARD_NETWORKS)
                .build()
        );
    PaymentMethodTokenizationParameters params = PaymentMethodTokenizationParameters
        .newBuilder()
        .setPaymentMethodTokenizationType(
            WalletConstants.PAYMENT_METHOD_TOKENIZATION_TYPE_PAYMENT_GATEWAY)
        .addParameter("gateway","square")
        .addParameter("gatewayMerchantId", merchantId)
        .build();
    request.setPaymentMethodTokenizationParameters(params);
    return request.build();
  }
}
