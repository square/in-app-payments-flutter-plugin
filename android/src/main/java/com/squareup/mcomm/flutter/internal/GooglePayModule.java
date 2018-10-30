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
import com.squareup.mcomm.flutter.internal.converter.CardConverter;
import com.squareup.mcomm.flutter.internal.converter.CardResultConverter;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import java.util.Arrays;
import java.util.List;

final public class GooglePayModule {

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
  private final CardResultConverter cardResultConverter;

  public GooglePayModule(PluginRegistry.Registrar registrar, MobileCommerceSdk mobileCommerceSdk, String environment, final MethodChannel channel) {
    currentActivity = registrar.activity();
    cardResultConverter = new CardResultConverter(new CardConverter());
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
          channel.invokeMethod("onGooglePayGetNonce", cardResultConverter.toMapObject(googlePayResult.getSuccessValue().getCardResult()));
        } else if (googlePayResult.isError()) {
          CreateNonceResult.Error error = ((CreateNonceResult.Error) googlePayResult);
          channel.invokeMethod("onGooglePayFailed", ErrorHandlerUtils.getGooglePayErorrInfo(error.getDebugMessage()));
        }
      }
    });

    // Register callback when google pay activity is dismissed
    registrar.addActivityResultListener(new PluginRegistry.ActivityResultListener() {
      @Override public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == LOAD_PAYMENT_DATA_REQUEST_CODE) {
          switch (resultCode) {
            case Activity.RESULT_OK:
              PaymentData paymentData = PaymentData.getFromIntent(data);
              String googlePayToken = paymentData.getPaymentMethodToken().getToken();
              googlePayManager.createNonce(googlePayToken);
              break;
            case Activity.RESULT_CANCELED:
              channel.invokeMethod("onGooglePayCanceled", null);
              break;
            case AutoResolveHelper.RESULT_ERROR:
              Status status = AutoResolveHelper.getStatusFromIntent(data);
              channel.invokeMethod("onGooglePayFailed", ErrorHandlerUtils.getGooglePayErorrInfo(status.getStatusMessage()));
              break;
            default:
              channel.invokeMethod("onGooglePayFailed", ErrorHandlerUtils.getGooglePayErorrInfo("Got unknown google pay activity result."));
          }
        }
        return false;
      }
    });
  }

  public void requestGooglePayNonce(MethodChannel.Result result, String merchantId, String price, String currencyCode) {
    AutoResolveHelper.resolveTask(
        googlePayClients.loadPaymentData(_createPaymentChargeRequest(merchantId, price, currencyCode)),
        currentActivity,
        LOAD_PAYMENT_DATA_REQUEST_CODE);
    result.success(null);
  }

  private PaymentDataRequest _createPaymentChargeRequest(String merchantId, String price, String currencyCode) {
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
