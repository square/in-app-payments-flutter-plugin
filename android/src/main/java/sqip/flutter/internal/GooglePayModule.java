package sqip.flutter.internal;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

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
import sqip.BuyerVerificationResult.Error;
import sqip.BuyerVerification;
import sqip.SquareIdentifier;
import sqip.BuyerAction;
import sqip.Contact;
import sqip.CardDetails;
import sqip.Money;
import sqip.VerificationParameters;
import sqip.Country;

public final class GooglePayModule {

  private static final String FL_GOOGLE_PAY_NOT_INITIALIZED = "fl_google_pay_not_initialized";
  private static final String FL_GOOGLE_PAY_RESULT_ERROR = "fl_google_pay_result_error";
  private static final String FL_GOOGLE_PAY_UNKNOWN_ERROR = "fl_google_pay_unknown_error";
  private static final String FL_MESSAGE_GOOGLE_PAY_NOT_INITIALIZED = "Please initialize Google Pay before you can call other methods.";
  private static final String FL_MESSAGE_GOOGLE_PAY_RESULT_ERROR = "Failed to launch Google Pay, please make sure you configured it correctly.";
  private static final String FL_MESSAGE_GOOGLE_PAY_UNKNOWN_ERROR = "Unknown Google Pay activity result status.";

  private static final int LOAD_PAYMENT_DATA_REQUEST_CODE = 4111;

  private boolean shouldListen = false;
  private boolean shouldContinueWithRequestGooglePay = false;

  private final CardDetailsConverter cardDetailsConverter;
  private PaymentsClient googlePayClients;
  private String squareLocationId;
  private SquareIdentifier squareIdentifier;
  private BuyerAction buyerAction;
  private Contact contact;
  private CardDetails cardResult;
  private String paymentSourceId;
  private String price;
  private String currencyCode;
  private int priceStatus;

  private Activity currentActivity;

  public GooglePayModule(Context context, MethodChannel channel) {
    this.cardDetailsConverter = new CardDetailsConverter(new CardConverter());
  }

  public void attachActivityResultListener(final ActivityPluginBinding activityPluginBinding, final MethodChannel channel) {
    this.currentActivity = activityPluginBinding.getActivity();

    activityPluginBinding.addActivityResultListener((requestCode, resultCode, data) -> {
      if (!shouldListen) {
        return false; 
      }
      shouldListen = false;

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

      if (requestCode == BuyerVerification.DEFAULT_BUYER_VERIFICATION_REQUEST_CODE) {
        BuyerVerification.handleActivityResult(data, result -> {
          if (result.isSuccess()) {
            Map<String, Object> payload = new LinkedHashMap<>();
            if (paymentSourceId == null) {
              payload = cardDetailsConverter.toMapObject(cardResult);
              payload.put("token", result.getSuccessValue().getVerificationToken());
            } else {
              payload.put("nonce", paymentSourceId);
              payload.put("token", result.getSuccessValue().getVerificationToken());
            }
            channel.invokeMethod("onBuyerVerificationSuccess", payload);
            if (shouldContinueWithRequestGooglePay) {
              shouldContinueWithRequestGooglePay = false;
              if (price != null && currencyCode != null && priceStatus != 0) {
                PaymentDataRequest request = createPaymentChargeRequest(
                  squareLocationId,
                  price, 
                  currencyCode, 
                  priceStatus
                );
                AutoResolveHelper.resolveTask(
                  googlePayClients.loadPaymentData(request),
                  currentActivity,
                  LOAD_PAYMENT_DATA_REQUEST_CODE);
              }
            }
          } else if (result.isError()) {
            shouldContinueWithRequestGooglePay = false;
            Error error = result.getErrorValue();
            Map<String, String> errorMap = ErrorHandlerUtils.getCallbackErrorObject(
                error.getCode().name(),
                error.getMessage(),
                error.getDebugCode(),
                error.getDebugMessage());
            channel.invokeMethod("onBuyerVerificationError", errorMap);
          }
        });

        this.contact = null;
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

    shouldListen = true;

    PaymentDataRequest request = createPaymentChargeRequest(squareLocationId, price, currencyCode, priceStatus);
    AutoResolveHelper.resolveTask(googlePayClients.loadPaymentData(request), currentActivity, LOAD_PAYMENT_DATA_REQUEST_CODE);
    result.success(null);
  }

  public void requestGooglePayNonceWithBuyerVerification(
    MethodChannel.Result result, 
    String buyerActionString, 
    HashMap<String, Object> moneyMap, 
    String locationId, 
    HashMap<String, Object> contactMap, 
    String paymentSourceId, 
    String price, 
    String currencyCode, 
    int priceStatus) {
    if (googlePayClients == null) {
      result.error(ErrorHandlerUtils.USAGE_ERROR,
          ErrorHandlerUtils.getPluginErrorMessage(FL_GOOGLE_PAY_NOT_INITIALIZED),
          ErrorHandlerUtils.getDebugErrorObject(FL_GOOGLE_PAY_NOT_INITIALIZED, FL_MESSAGE_GOOGLE_PAY_NOT_INITIALIZED));
      return;
    }

    shouldListen = true;

    this.squareLocationId = locationId;
    this.squareIdentifier = new SquareIdentifier.LocationToken(locationId);
    Money money = getMoney(moneyMap);
    this.buyerAction = getBuyerAction(buyerActionString, money);
    this.contact = getContact(contactMap);
    this.paymentSourceId = paymentSourceId;

    this.price = price;
    this.currencyCode = currencyCode;
    this.priceStatus = priceStatus;

    shouldContinueWithRequestGooglePay = true;

    VerificationParameters params = new VerificationParameters(paymentSourceId, buyerAction, squareIdentifier, contact);
    BuyerVerification.verify(currentActivity, params);
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

  private Contact getContact(Map<String, Object> contactMap) {
    Object givenName = contactMap.get("givenName");
    Object familyName = contactMap.get("familyName");
    Object addressLines = contactMap.get("addressLines");
    Object city = contactMap.get("city");
    Object countryCode = contactMap.get("countryCode");
    Object email = contactMap.get("email");
    Object phone = contactMap.get("phone");
    Object postalCode = contactMap.get("postalCode");
    Object region = contactMap.get("region");
    Country country = Country.valueOf((countryCode != null) ? countryCode.toString() : "US");

    return new Contact.Builder()
        .familyName((familyName != null) ? familyName.toString() : "")
        .email((email != null) ? email.toString() : "")
        .addressLines((addressLines != null) ? (ArrayList<String>) addressLines : new ArrayList<>())
        .city((city != null) ? city.toString() : "")
        .countryCode(country)
        .postalCode((postalCode != null) ? postalCode.toString() : "")
        .phone((phone != null) ? phone.toString() : "")
        .region((region != null) ? region.toString() : "")
        .build((givenName != null) ? givenName.toString() : "");
  }

  private Money getMoney(Map<String, Object> moneyMap) {
    return new Money((Integer) moneyMap.get("amount"), sqip.Currency.valueOf((String) moneyMap.get("currencyCode")));
  }

  private BuyerAction getBuyerAction(String buyerActionString, Money money) {
    return buyerActionString.equals("Store") ? new BuyerAction.Store() : new BuyerAction.Charge(money);
  }

}
