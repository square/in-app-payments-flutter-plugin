package com.squareup.mcomm.flutter;

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
import com.squareup.mcomm.CallbackReference;
import com.squareup.mcomm.CardEntryManager;
import com.squareup.mcomm.CreateNonceCallback;
import com.squareup.mcomm.CreateNonceResult;
import com.squareup.mcomm.GooglePayManager;
import com.squareup.mcomm.MobileCommerceSdk;
import com.squareup.mcomm.flutter.internal.CardEntryModule;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

/** SquareMobileCommerceSdkFlutterPlugin */
public class SquareMobileCommerceSdkFlutterPlugin implements MethodCallHandler {
  private final Activity currentActivity;

  // Google pay
  private static final int LOAD_PAYMENT_DATA_REQUEST_CODE = 1;
  private static final List<Integer> CARD_NETWORKS = Arrays.asList(
      WalletConstants.CARD_NETWORK_AMEX,
      WalletConstants.CARD_NETWORK_DISCOVER,
      WalletConstants.CARD_NETWORK_JCB,
      WalletConstants.CARD_NETWORK_VISA,
      WalletConstants.CARD_NETWORK_MASTERCARD,
      WalletConstants.CARD_NETWORK_OTHER
  );
  private static MethodChannel channel;
  private CardEntryModule cardEntryModule;

  private MobileCommerceSdk mobileCommerceSdk;
  private CardEntryManager cardEntryManager;
  private CallbackReference cardEntryFlowCallbackRef;

  private GooglePayManager googlePayManager;
  private PaymentsClient googlePayClients;
  private Result googlePayPluginResult;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    channel = new MethodChannel(registrar.messenger(), "square_mobile_commerce_sdk");
    channel.setMethodCallHandler(new SquareMobileCommerceSdkFlutterPlugin(registrar));
  }

  private SquareMobileCommerceSdkFlutterPlugin(Registrar registrar) {
    this.currentActivity = registrar.activity();
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
              googlePayPluginResult.error("fl_mcomm_google_pay_canceled", "", null);
              googlePayPluginResult = null;
              break;
            case AutoResolveHelper.RESULT_ERROR:
              Status status = AutoResolveHelper.getStatusFromIntent(data);
              // Log the status for debugging.
              // Generally, there is no need to show an error to the user.
              // The Google Pay payment sheet will present any account errors.
              Log.d("mCommPlugin", "google pay result error: " + status.getStatusMessage());
              googlePayPluginResult.error("fl_mcomm_google_pay_error",  status.getStatusMessage(), null);
              googlePayPluginResult = null;
              break;
            default:
              googlePayPluginResult.error("fl_mcomm_google_pay_unknown",  "", null);
              googlePayPluginResult = null;
              // Do nothing.
          }
          Log.d("mCommPlugin", "google pay returned");
        }
        return false;
      }
    });
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
      if (googlePayManager != null) {
        result.error("fl_mcomm_dup_google_pay_initialize", "", null);
        return;
      }
      String environment = call.argument("environment");
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
      googlePayManager.addCreateNonceCallback(new CreateNonceCallback() {
        @Override public void onResult(CreateNonceResult googlePayResult) {
          if (googlePayResult.isSuccess()) {
            HashMap<String, Object> mapToReturn = new HashMap<>();
            mapToReturn.put("nonce", googlePayResult.getSuccessValue().getCardResult().getNonce());
            mapToReturn.put("card", googlePayResult.getSuccessValue().getCardResult().getCard().toString());
            googlePayPluginResult.success(mapToReturn);
            Log.d("mCommPlugin", "nonce got: " + googlePayResult.getSuccessValue().getCardResult().getNonce());
          } else if (googlePayResult.isError()) {
            googlePayPluginResult.error("fl_mcomm_google_pay_failed", "", null);
            Log.d("mCommPlugin", "failed to checkout");
          }
          googlePayPluginResult = null;
        }
      });
      result.success(null);
    } else if (call.method.equals("payWithGooglePay")) {
      if (googlePayPluginResult != null) {
        result.error("fl_mcomm_dup_google_pay", "", null);
        return;
      }

      googlePayPluginResult = result;
      String merchantId = call.argument("merchantId");
      String price = call.argument("price");
      String currencyCode = call.argument("currencyCode");
      AutoResolveHelper.resolveTask(
          googlePayClients.loadPaymentData(createPaymentChargeRequest(merchantId, price, currencyCode)),
          currentActivity,
          LOAD_PAYMENT_DATA_REQUEST_CODE);
    } else {
      result.notImplemented();
    }
  }

  // Google pay implementation
  /*
   * Create a GooglePay payment charge request object to give payment details
   * to the GooglePay activity
   */
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
