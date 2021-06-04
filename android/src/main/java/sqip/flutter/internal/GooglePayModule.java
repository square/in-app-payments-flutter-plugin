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
package sqip.flutter.internal;

import android.app.Activity;
import android.content.Intent;
import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.android.gms.wallet.AutoResolveHelper;
import com.google.android.gms.wallet.IsReadyToPayRequest;
import com.google.android.gms.wallet.PaymentData;
import com.google.android.gms.wallet.PaymentDataRequest;
import com.google.android.gms.wallet.PaymentsClient;
import com.google.android.gms.wallet.TransactionInfo;
import com.google.android.gms.wallet.Wallet;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import sqip.Callback;
import sqip.GooglePay;
import sqip.GooglePayNonceResult;
import sqip.flutter.internal.converter.CardConverter;
import sqip.flutter.internal.converter.CardDetailsConverter;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

final public class GooglePayModule {

  // Android only sqip.flutter plugin errors and messages
  private static final String FL_GOOGLE_PAY_NOT_INITIALIZED = "fl_google_pay_not_initialized";
  private static final String FL_GOOGLE_PAY_RESULT_ERROR = "fl_google_pay_result_error";
  private static final String FL_GOOGLE_PAY_UNKNOWN_ERROR = "fl_google_pay_unknown_error";
  private static final String FL_MESSAGE_GOOGLE_PAY_NOT_INITIALIZED = "Please initialize google pay before you can call other methods.";
  private static final String FL_MESSAGE_GOOGLE_PAY_RESULT_ERROR = "Failed to launch google pay, please make sure you configured google pay correctly.";
  private static final String FL_MESSAGE_GOOGLE_PAY_UNKNOWN_ERROR = "Unknown google pay activity result status.";

  private static final int LOAD_PAYMENT_DATA_REQUEST_CODE = 4111;

  private PluginRegistry.ActivityResultListener activityResultListener;
  private Activity currentActivity;
  private final CardDetailsConverter cardDetailsConverter;

  private String squareLocationId;
  private PaymentsClient googlePayClients;

  @SuppressWarnings("deprecation")
  public GooglePayModule(PluginRegistry.Registrar registrar, final MethodChannel channel) {
    this(channel);
    currentActivity = registrar.activity();
    // Register callback when google pay activity is dismissed
    registrar.addActivityResultListener(activityResultListener);
  }
  public GooglePayModule(final MethodChannel channel) {
    activityResultListener = createActivityResultListener(channel);
    cardDetailsConverter = new CardDetailsConverter(new CardConverter());
  }

  public void attachActivityResultListener(final ActivityPluginBinding activityPluginBinding, final MethodChannel channel) {
    if (activityResultListener == null) {
      activityResultListener = createActivityResultListener(channel);
    }
    activityPluginBinding.addActivityResultListener(activityResultListener);
    this.currentActivity = activityPluginBinding.getActivity();
  }

  public void initializeGooglePay(String squareLocationId, int environment) {
    this.squareLocationId = squareLocationId;

    googlePayClients = Wallet.getPaymentsClient(
        currentActivity,
        (new Wallet.WalletOptions.Builder())
            .setEnvironment(environment)
            .build()
    );
  }

  public void canUseGooglePay(final MethodChannel.Result result) {
    if (googlePayClients == null) {
      result.error(ErrorHandlerUtils.USAGE_ERROR,
          ErrorHandlerUtils.getPluginErrorMessage(FL_GOOGLE_PAY_NOT_INITIALIZED),
          ErrorHandlerUtils.getDebugErrorObject(FL_GOOGLE_PAY_NOT_INITIALIZED, FL_MESSAGE_GOOGLE_PAY_NOT_INITIALIZED));
      return;
    }
    IsReadyToPayRequest isReadyToPayRequest = GooglePay.createIsReadyToPayRequest();
    googlePayClients.isReadyToPay(isReadyToPayRequest).addOnCompleteListener(new OnCompleteListener<Boolean>() {
      @Override
      public void onComplete(Task<Boolean> task) {
        result.success(task.isSuccessful());
      }
    });
  }

  public void requestGooglePayNonce(MethodChannel.Result result, String price, String currencyCode, int priceStatus) {
    if (googlePayClients == null) {
      result.error(ErrorHandlerUtils.USAGE_ERROR,
          ErrorHandlerUtils.getPluginErrorMessage(FL_GOOGLE_PAY_NOT_INITIALIZED),
          ErrorHandlerUtils.getDebugErrorObject(FL_GOOGLE_PAY_NOT_INITIALIZED, FL_MESSAGE_GOOGLE_PAY_NOT_INITIALIZED));
      return;
    }
    AutoResolveHelper.resolveTask(
        googlePayClients.loadPaymentData(createPaymentChargeRequest(squareLocationId, price, currencyCode, priceStatus)),
        currentActivity,
        LOAD_PAYMENT_DATA_REQUEST_CODE);
    result.success(null);
  }

  private PluginRegistry.ActivityResultListener createActivityResultListener(MethodChannel channel) {
    return (requestCode, resultCode, data) -> {
      if (requestCode == LOAD_PAYMENT_DATA_REQUEST_CODE) {
        switch (resultCode) {
          case Activity.RESULT_OK:
            PaymentData paymentData = PaymentData.getFromIntent(data);
            ErrorHandlerUtils.checkNotNull(paymentData, "paymentData should never be null.");
            String googlePayToken = paymentData.getPaymentMethodToken().getToken();
            GooglePay.requestGooglePayNonce(googlePayToken).enqueue(
                    new Callback<GooglePayNonceResult>() {
                      @Override public void onResult(GooglePayNonceResult googlePayNonceResult) {
                        if (googlePayNonceResult.isSuccess()) {
                          channel.invokeMethod("onGooglePayNonceRequestSuccess", cardDetailsConverter.toMapObject(googlePayNonceResult.getSuccessValue()));
                        } else if (googlePayNonceResult.isError()) {
                          GooglePayNonceResult.Error error = ((GooglePayNonceResult.Error) googlePayNonceResult);
                          channel.invokeMethod("onGooglePayNonceRequestFailure", ErrorHandlerUtils.getCallbackErrorObject(error.getCode().name(), error.getMessage(), error.getDebugCode(), error.getDebugMessage()));
                        }
                      }
                    });
            break;
          case Activity.RESULT_CANCELED:
            channel.invokeMethod("onGooglePayCanceled", null);
            break;
          case AutoResolveHelper.RESULT_ERROR:
            channel.invokeMethod("onGooglePayNonceRequestFailure",
                    ErrorHandlerUtils.getCallbackErrorObject(ErrorHandlerUtils.USAGE_ERROR, ErrorHandlerUtils.getPluginErrorMessage(FL_GOOGLE_PAY_RESULT_ERROR), FL_GOOGLE_PAY_RESULT_ERROR, FL_MESSAGE_GOOGLE_PAY_RESULT_ERROR));
            break;
          default:
            channel.invokeMethod("onGooglePayNonceRequestFailure",
                    ErrorHandlerUtils.getCallbackErrorObject(ErrorHandlerUtils.USAGE_ERROR, ErrorHandlerUtils.getPluginErrorMessage(FL_GOOGLE_PAY_UNKNOWN_ERROR), FL_GOOGLE_PAY_UNKNOWN_ERROR, FL_MESSAGE_GOOGLE_PAY_UNKNOWN_ERROR));
        }
      }
      return false;
    };
  }

  private PaymentDataRequest createPaymentChargeRequest(String squareLocationId, String price, String currencyCode, int priceStatus) {
    TransactionInfo transactionInfo = TransactionInfo.newBuilder()
        .setTotalPriceStatus(priceStatus)
        .setTotalPrice(price)
        .setCurrencyCode(currencyCode).build();
    return GooglePay.createPaymentDataRequest(squareLocationId, transactionInfo);
  }
}
