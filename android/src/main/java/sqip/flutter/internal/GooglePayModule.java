package sqip.flutter.internal;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.google.android.gms.tasks.Task;
import com.google.android.gms.wallet.AutoResolveHelper;
import com.google.android.gms.wallet.IsReadyToPayRequest;
import com.google.android.gms.wallet.PaymentData;
import com.google.android.gms.wallet.PaymentDataRequest;
import com.google.android.gms.wallet.PaymentsClient;
import com.google.android.gms.wallet.TransactionInfo;
import com.google.android.gms.wallet.Wallet;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;
import sqip.Callback;
import sqip.GooglePay;
import sqip.GooglePayNonceResult;
import sqip.flutter.internal.converter.CardConverter;
import sqip.flutter.internal.converter.CardDetailsConverter;

public final class GooglePayModule {

  private static final String FL_GOOGLE_PAY_NOT_INITIALIZED = "fl_google_pay_not_initialized";
  private static final String FL_GOOGLE_PAY_RESULT_ERROR = "fl_google_pay_result_error";
  private static final String FL_GOOGLE_PAY_UNKNOWN_ERROR = "fl_google_pay_unknown_error";
  private static final String FL_MESSAGE_GOOGLE_PAY_NOT_INITIALIZED = "Please initialize Google Pay before you can call other methods.";
  private static final String FL_MESSAGE_GOOGLE_PAY_RESULT_ERROR = "Failed to launch Google Pay, please make sure you configured it correctly.";
  private static final String FL_MESSAGE_GOOGLE_PAY_UNKNOWN_ERROR = "Unknown Google Pay activity result status.";

  private static final int LOAD_PAYMENT_DATA_REQUEST_CODE = 4111;

  private final CardDetailsConverter cardDetailsConverter;
  private PaymentsClient googlePayClients;
  private String squareLocationId;

  private Activity currentActivity;

  public GooglePayModule(Context context, MethodChannel channel) {
    this.cardDetailsConverter = new CardDetailsConverter(new CardConverter());
  }

  public void attachActivityResultListener(final ActivityPluginBinding activityPluginBinding, final MethodChannel channel) {
    this.currentActivity = activityPluginBinding.getActivity();

    activityPluginBinding.addActivityResultListener((requestCode, resultCode, data) -> {
      if (requestCode == LOAD_PAYMENT_DATA_REQUEST_CODE) {
        switch (resultCode) {
          case Activity.RESULT_OK:
            PaymentData paymentData = PaymentData.getFromIntent(data);
            ErrorHandlerUtils.checkNotNull(paymentData, "paymentData should never be null.");
            String googlePayToken = paymentData.getPaymentMethodToken().getToken();
            GooglePay.requestGooglePayNonce(googlePayToken).enqueue(new Callback<GooglePayNonceResult>() {
              @Override
              public void onResult(GooglePayNonceResult result) {
                if (result.isSuccess()) {
                  channel.invokeMethod("onGooglePayNonceRequestSuccess", cardDetailsConverter.toMapObject(result.getSuccessValue()));
                } else if (result.isError()) {
                  GooglePayNonceResult.Error error = result.getErrorValue();
                  channel.invokeMethod("onGooglePayNonceRequestFailure", ErrorHandlerUtils.getCallbackErrorObject(
                      error.getCode().name(), error.getMessage(), error.getDebugCode(), error.getDebugMessage()));
                }
              }
            });
            break;
          case Activity.RESULT_CANCELED:
            channel.invokeMethod("onGooglePayCanceled", null);
            break;
          case AutoResolveHelper.RESULT_ERROR:
            channel.invokeMethod("onGooglePayNonceRequestFailure", ErrorHandlerUtils.getCallbackErrorObject(
                ErrorHandlerUtils.USAGE_ERROR, FL_MESSAGE_GOOGLE_PAY_RESULT_ERROR,
                FL_GOOGLE_PAY_RESULT_ERROR, FL_MESSAGE_GOOGLE_PAY_RESULT_ERROR));
            break;
          default:
            channel.invokeMethod("onGooglePayNonceRequestFailure", ErrorHandlerUtils.getCallbackErrorObject(
                ErrorHandlerUtils.USAGE_ERROR, FL_MESSAGE_GOOGLE_PAY_UNKNOWN_ERROR,
                FL_GOOGLE_PAY_UNKNOWN_ERROR, FL_MESSAGE_GOOGLE_PAY_UNKNOWN_ERROR));
            break;
        }
      }
      return false;
    });
  }

  public void initializeGooglePay(String squareLocationId, int environment) {
    this.squareLocationId = squareLocationId;

    googlePayClients = Wallet.getPaymentsClient(
        currentActivity,
        new Wallet.WalletOptions.Builder().setEnvironment(environment).build()
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
    googlePayClients.isReadyToPay(isReadyToPayRequest).addOnCompleteListener((Task<Boolean> task) -> {
      result.success(task.isSuccessful());
    });
  }

  public void requestGooglePayNonce(MethodChannel.Result result, String price, String currencyCode, int priceStatus) {
    if (googlePayClients == null) {
      result.error(ErrorHandlerUtils.USAGE_ERROR,
          ErrorHandlerUtils.getPluginErrorMessage(FL_GOOGLE_PAY_NOT_INITIALIZED),
          ErrorHandlerUtils.getDebugErrorObject(FL_GOOGLE_PAY_NOT_INITIALIZED, FL_MESSAGE_GOOGLE_PAY_NOT_INITIALIZED));
      return;
    }

    PaymentDataRequest request = createPaymentChargeRequest(squareLocationId, price, currencyCode, priceStatus);
    AutoResolveHelper.resolveTask(googlePayClients.loadPaymentData(request), currentActivity, LOAD_PAYMENT_DATA_REQUEST_CODE);
    result.success(null);
  }

  private PaymentDataRequest createPaymentChargeRequest(String squareLocationId, String price, String currencyCode, int priceStatus) {
    TransactionInfo transactionInfo = TransactionInfo.newBuilder()
        .setTotalPriceStatus(priceStatus)
        .setTotalPrice(price)
        .setCurrencyCode(currencyCode)
        .build();
    return GooglePay.createPaymentDataRequest(squareLocationId, transactionInfo);
  }
}
