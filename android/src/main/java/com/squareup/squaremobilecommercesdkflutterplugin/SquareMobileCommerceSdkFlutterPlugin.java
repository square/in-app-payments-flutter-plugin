package com.squareup.squaremobilecommercesdkflutterplugin;

import android.app.Activity;
import android.content.Intent;
import android.util.Log;
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
import com.squareup.mcomm.CardEntryActivityCallback;
import com.squareup.mcomm.CardEntryActivityResult;
import com.squareup.mcomm.CardEntryManager;
import com.squareup.mcomm.CreateNonceCallback;
import com.squareup.mcomm.CreateNonceResult;
import com.squareup.mcomm.GooglePayManager;
import com.squareup.mcomm.MobileCommerceSdk;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.Arrays;
import java.util.List;

/** SquareMobileCommerceSdkFlutterPlugin */
public class SquareMobileCommerceSdkFlutterPlugin implements MethodCallHandler {
  private final static String APPLICATION_ID = "sq0idp-279w1ejUbhuatNoaumEidg";
  private final Activity currentActivity;

  private CallbackReference cardEntryActivityCallbackRef;
  private final CardEntryManager cardEntryManager;

  // Google pay
  private static final String MERCHANT_LOCATION_ID = "abcdefg";
  private static final int LOAD_PAYMENT_DATA_REQUEST_CODE = 1;
  private static final List<Integer> CARD_NETWORKS = Arrays.asList(
      WalletConstants.CARD_NETWORK_AMEX,
      WalletConstants.CARD_NETWORK_DISCOVER,
      WalletConstants.CARD_NETWORK_JCB,
      WalletConstants.CARD_NETWORK_VISA,
      WalletConstants.CARD_NETWORK_MASTERCARD,
      WalletConstants.CARD_NETWORK_OTHER
  );
  private final GooglePayManager googlePayManager;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "square_mobile_commerce_sdk_flutter_plugin");
    channel.setMethodCallHandler(new SquareMobileCommerceSdkFlutterPlugin(registrar));
  }

  private SquareMobileCommerceSdkFlutterPlugin(Registrar registrar) {
    this.currentActivity = registrar.activity();
    MobileCommerceSdk mobileCommerceSdk = new MobileCommerceSdk(APPLICATION_ID);
    cardEntryManager = mobileCommerceSdk.cardEntryManager();
    cardEntryActivityCallbackRef =
        cardEntryManager.addCardEntryActivityCallback(new CardEntryActivityCallback() {
          @Override public void onResult(CardEntryActivityResult cardEntryActivityResult) {
            Log.d("mCommPlugin", "cardEntryFinished");
          }
        });
    googlePayManager = mobileCommerceSdk.googlePayManager(registrar.activity().getApplication());
    googlePayManager.addCreateNonceCallback(new CreateNonceCallback() {
      @Override public void onResult(CreateNonceResult googlePayResult) {
        if (googlePayResult.isSuccess()) {
          // saveCard(googlePayResult.cardResult);
          Log.d("mCommPlugin", "nonce got: " + googlePayResult.getSuccessValue().getCardResult().getNonce());
        } else if (googlePayResult.isError()) {
          Log.d("mCommPlugin", "failed to checkout");
        }
      }
    });

    registrar.addActivityResultListener(new PluginRegistry.ActivityResultListener() {
      @Override public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == LOAD_PAYMENT_DATA_REQUEST_CODE) {
          PaymentData paymentData = PaymentData.getFromIntent(data);
          String googlePayToken = paymentData.getPaymentMethodToken().getToken();

          //Request to exchange GooglePay token for Square payment nonce
          googlePayManager.createNonce(googlePayToken);
        }
        return false;
      }
    });
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("startCardEntryFlow")) {
      cardEntryManager.startCardEntryActivity(this.currentActivity);
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("payWithEWallet")) {
      PaymentsClient paymentsClient = Wallet.getPaymentsClient(
          currentActivity,
          (new Wallet.WalletOptions.Builder())
              .setEnvironment(WalletConstants.ENVIRONMENT_TEST)
              .build()
      );
      AutoResolveHelper.resolveTask(
          paymentsClient.loadPaymentData(createPaymentChargeRequest()),
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
  private PaymentDataRequest createPaymentChargeRequest() {
    PaymentDataRequest.Builder request = PaymentDataRequest
        .newBuilder().setTransactionInfo(
            TransactionInfo.newBuilder()
                .setTotalPriceStatus(
                    WalletConstants.TOTAL_PRICE_STATUS_FINAL)
                .setTotalPrice("1000") // $10
                .setCurrencyCode("USD")
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
        .addParameter("gatewayMerchantId",MERCHANT_LOCATION_ID)
        .build();
    request.setPaymentMethodTokenizationParameters(params);
    return request.build();
  }

}
