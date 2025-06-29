package sqip.flutter.internal;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.os.Handler;
import android.os.Looper;
import android.view.animation.Animation;

import java.lang.reflect.Method;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicReference;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodChannel;
import sqip.BuyerVerification;
import sqip.Callback;
import sqip.CardDetails;
import sqip.CardEntry;
import sqip.CardEntryActivityCommand;
import sqip.CardEntryActivityResult;
import sqip.CardNonceBackgroundHandler;
import sqip.BuyerVerificationResult.Error;
import sqip.SquareIdentifier;
import sqip.BuyerAction;
import sqip.Contact;
import sqip.Country;
import sqip.Money;
import sqip.VerificationParameters;
import sqip.flutter.R;
import sqip.flutter.internal.converter.CardConverter;
import sqip.flutter.internal.converter.CardDetailsConverter;

import static android.view.animation.AnimationUtils.loadAnimation;

public final class CardEntryModule {

  private Activity currentActivity;
  private MethodChannel channel;
  private final CardDetailsConverter cardDetailsConverter;
  private final AtomicReference<CardEntryActivityCommand> reference;
  private final Handler handler;
  private volatile CountDownLatch countDownLatch;
  private SquareIdentifier squareIdentifier;
  private BuyerAction buyerAction;
  private Contact contact;
  private CardDetails cardResult;
  private String paymentSourceId;

  public CardEntryModule(Context context, MethodChannel channel) {
    this.channel = channel;
    this.reference = new AtomicReference<>();
    this.handler = new Handler(Looper.getMainLooper());
    this.cardDetailsConverter = new CardDetailsConverter(new CardConverter());

    CardEntry.setCardNonceBackgroundHandler(new CardNonceBackgroundHandler() {
      @Override
      public CardEntryActivityCommand handleEnteredCardInBackground(CardDetails cardDetails) {
        if (CardEntryModule.this.contact != null) {
          return new CardEntryActivityCommand.Finish();
        }

        final Map<String, Object> mapToReturn = cardDetailsConverter.toMapObject(cardDetails);
        countDownLatch = new CountDownLatch(1);
        currentActivity.runOnUiThread(() -> channel.invokeMethod("cardEntryDidObtainCardDetails", mapToReturn));

        try {
          countDownLatch.await();
        } catch (InterruptedException e) {
          throw new RuntimeException(e);
        }

        return reference.get();
      }
    });
  }

  public void attachActivityResultListener(ActivityPluginBinding activityPluginBinding, MethodChannel channel) {
    this.currentActivity = activityPluginBinding.getActivity();
    activityPluginBinding.addActivityResultListener((requestCode, resultCode, data) -> {
      if (requestCode == CardEntry.DEFAULT_CARD_ENTRY_REQUEST_CODE) {
        CardEntry.handleActivityResult(data, cardEntryActivityResult -> {
          if (cardEntryActivityResult.isSuccess() && CardEntryModule.this.contact != null) {
            cardResult = cardEntryActivityResult.getSuccessValue();
            String nonce = cardResult.getNonce();
            VerificationParameters params = new VerificationParameters(nonce, buyerAction, squareIdentifier, contact);
            BuyerVerification.verify(currentActivity, params);
          } else {
            long delayMs = readCardEntryCloseExitAnimationDurationMs();
            handler.postDelayed(() -> {
              if (cardEntryActivityResult.isCanceled()) {
                channel.invokeMethod("cardEntryCancel", null);
              } else if (cardEntryActivityResult.isSuccess()) {
                channel.invokeMethod("cardEntryComplete", null);
              }
            }, delayMs);
          }
        });
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
          } else if (result.isError()) {
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

  public void startCardEntryFlow(MethodChannel.Result result, boolean collectPostalCode) {
    CardEntry.startCardEntryActivity(currentActivity, collectPostalCode);
    result.success(null);
  }

  public void completeCardEntry(MethodChannel.Result result) {
    reference.set(new CardEntryActivityCommand.Finish());
    countDownLatch.countDown();
    result.success(null);
  }

  public void showCardNonceProcessingError(MethodChannel.Result result, String errorMessage) {
    reference.set(new CardEntryActivityCommand.ShowError(errorMessage));
    countDownLatch.countDown();
    result.success(null);
  }

  public void startGiftCardEntryFlow(MethodChannel.Result result) {
    CardEntry.startGiftCardEntryActivity(currentActivity);
    result.success(null);
  }

  public void startCardEntryFlowWithBuyerVerification(MethodChannel.Result result, boolean collectPostalCode, String squareLocationId, String buyerActionString, Map<String, Object> moneyMap, Map<String, Object> contactMap) {
    this.squareIdentifier = new SquareIdentifier.LocationToken(squareLocationId);
    Money money = getMoney(moneyMap);
    this.buyerAction = getBuyerAction(buyerActionString, money);
    this.contact = getContact(contactMap);
    this.paymentSourceId = null;

    CardEntry.startCardEntryActivity(currentActivity, collectPostalCode);
    result.success(null);
  }

  public void startBuyerVerificationFlow(MethodChannel.Result result, String buyerActionString, Map<String, Object> moneyMap, String squareLocationId, Map<String, Object> contactMap, String paymentSourceId) {
    this.squareIdentifier = new SquareIdentifier.LocationToken(squareLocationId);
    Money money = getMoney(moneyMap);
    this.buyerAction = getBuyerAction(buyerActionString, money);
    this.contact = getContact(contactMap);
    this.paymentSourceId = paymentSourceId;

    VerificationParameters params = new VerificationParameters(paymentSourceId, buyerAction, squareIdentifier, contact);
    BuyerVerification.verify(currentActivity, params);
    result.success(null);
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

  private long readCardEntryCloseExitAnimationDurationMs() {
    long delay = 0;
    Resources.Theme theme = currentActivity.getResources().newTheme();
    theme.applyStyle(sqip.cardentry.R.style.sqip_Theme_CardEntry, true);
    int[] attrs = { android.R.attr.activityCloseExitAnimation };
    TypedArray typedArray = theme.obtainStyledAttributes(null, attrs, android.R.attr.windowAnimationStyle, 0);
    int resId = typedArray.getResourceId(0, -1);
    if (resId != -1) {
      try {
        Animation animation = loadAnimation(currentActivity, resId);
        delay = animation.getDuration();
      } catch (Resources.NotFoundException ignored) {}
    }
    typedArray.recycle();
    return delay;
  }
}
