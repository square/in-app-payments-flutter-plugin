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
import android.content.res.Resources;
import android.content.res.TypedArray;
import android.os.Handler;
import android.os.Looper;
import android.view.animation.Animation;

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
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
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

import java.lang.reflect.Method;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicReference;
import java.util.function.Function;

import static android.view.animation.AnimationUtils.loadAnimation;

final public class CardEntryModule {

  private Activity currentActivity;
  private PluginRegistry.ActivityResultListener activityResultListener;
  private final CardDetailsConverter cardDetailsConverter;
  private final AtomicReference<CardEntryActivityCommand> reference;
  private final Handler handler;
  private volatile CountDownLatch countDownLatch;
  private SquareIdentifier squareIdentifier;
  private BuyerAction buyerAction;
  private Contact contact;
  private CardDetails cardResult;
  private String paymentSourceId;

  public CardEntryModule(PluginRegistry.Registrar registrar, final MethodChannel channel) {
    this(channel);
    currentActivity = registrar.activity();
    registrar.addActivityResultListener(activityResultListener);
  }

  public CardEntryModule(final MethodChannel channel) {
    reference = new AtomicReference<>();
    handler = new Handler(Looper.getMainLooper());

    cardDetailsConverter = new CardDetailsConverter(new CardConverter());
    activityResultListener = createActivityResultListener(channel);

    CardEntry.setCardNonceBackgroundHandler(new CardNonceBackgroundHandler() {
      @Override
      public CardEntryActivityCommand handleEnteredCardInBackground(CardDetails cardDetails) {
        if (CardEntryModule.this.contact != null) {
          // If buyer verification needed, finish the card entry activity so we can verify buyer
          return new CardEntryActivityCommand.Finish();
        }

        final Map<String, Object> mapToReturn = cardDetailsConverter.toMapObject(cardDetails);
        countDownLatch = new CountDownLatch(1);
        // must be run on the UI thread to prevent an exception
        currentActivity.runOnUiThread(
                new Runnable() {
                  public void run() {
                    channel.invokeMethod("cardEntryDidObtainCardDetails", mapToReturn);
                  }
                }
        );
        try {
          // completeCardEntry or showCardNonceProcessingError must be called,
          // otherwise the thread will be leaked.
          countDownLatch.await();
        } catch (InterruptedException e) {
          throw new RuntimeException(e);
        }

        return reference.get();
      }
    });
  }

  public void attachActivityResultListener(final ActivityPluginBinding activityPluginBinding, final MethodChannel channel) {
    if (activityResultListener == null) {
      activityResultListener = createActivityResultListener(channel);
    }
    activityPluginBinding.addActivityResultListener(activityResultListener);
    this.currentActivity = activityPluginBinding.getActivity();
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
    SquareIdentifier squareIdentifier = new SquareIdentifier.LocationToken(squareLocationId);

    Money money = getMoney(moneyMap);
    BuyerAction buyerAction = getBuyerAction(buyerActionString, money);
    Contact contact = getContact(contactMap);

    this.squareIdentifier = squareIdentifier;
    this.buyerAction = buyerAction;
    this.contact = contact;
    this.paymentSourceId = null;
    CardEntry.startCardEntryActivity(currentActivity, collectPostalCode);
    result.success(null);
  }

  public void startBuyerVerificationFlow(MethodChannel.Result result, String buyerActionString, Map<String, Object> moneyMap, String squareLocationId, Map<String, Object> contactMap, String paymentSourceId) {
    SquareIdentifier squareIdentifier = new SquareIdentifier.LocationToken(squareLocationId);

    Money money = getMoney(moneyMap);
    BuyerAction buyerAction = getBuyerAction(buyerActionString, money);
    Contact contact = getContact(contactMap);

    this.squareIdentifier = squareIdentifier;
    this.buyerAction = buyerAction;
    this.contact = contact;
    this.paymentSourceId = paymentSourceId;
    VerificationParameters verificationParameters = new VerificationParameters(this.paymentSourceId, this.buyerAction, this.squareIdentifier, this.contact);
    BuyerVerification.verify(currentActivity, verificationParameters);
    result.success(null);
  }

  private Contact getContact(Map<String, Object> contactMap) {
    // Contact info
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
            .addressLines((addressLines != null) ? (ArrayList<String>) addressLines : new ArrayList<String>())
            .city((city != null) ? city.toString() : "")
            .countryCode(country)
            .postalCode((postalCode != null) ? postalCode.toString() : "")
            .phone((phone != null) ? phone.toString() : "")
            .region((region != null) ? region.toString() : "")
            .build((givenName != null) ? givenName.toString() : "");
  }

  private Money getMoney(Map<String, Object> moneyMap) {
    return new Money(
            ((Integer) moneyMap.get("amount")).intValue(),
            sqip.Currency.valueOf((String) moneyMap.get("currencyCode")));
  }

  private BuyerAction getBuyerAction(String buyerActionString, Money money) {
    BuyerAction buyerAction;
    if (buyerActionString.equals("Store")) {
      buyerAction = new BuyerAction.Store();
    } else {
      buyerAction = new BuyerAction.Charge(money);
    }
    return buyerAction;
  }

  private PluginRegistry.ActivityResultListener createActivityResultListener(MethodChannel channel) {
    return new PluginRegistry.ActivityResultListener() {
      @Override public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == CardEntry.DEFAULT_CARD_ENTRY_REQUEST_CODE) {
          CardEntry.handleActivityResult(data, new Callback<CardEntryActivityResult>() {
            @Override
            public void onResult(final CardEntryActivityResult cardEntryActivityResult) {
              if (cardEntryActivityResult.isSuccess() && CardEntryModule.this.contact != null) {
                cardResult = cardEntryActivityResult.getSuccessValue();
                String paymentSourceId = cardResult.getNonce();
                VerificationParameters verificationParameters = new VerificationParameters(paymentSourceId, CardEntryModule.this.buyerAction, CardEntryModule.this.squareIdentifier, CardEntryModule.this.contact);
                BuyerVerification.verify(currentActivity, verificationParameters);
              } else {
                // flutter UI doesn't know the context of fade_out animation
                // so that the next action from flutter can be triggered too soon before
                // card entry activity is closed completely.
                // So this is a workaround to delay the callback until animation finished.
                long delayDurationMs = readCardEntryCloseExitAnimationDurationMs();
                handler.postDelayed(new Runnable() {
                  @Override
                  public void run() {
                    if (cardEntryActivityResult.isCanceled()) {
                      channel.invokeMethod("cardEntryCancel", null);
                    } else if (cardEntryActivityResult.isSuccess()) {
                      channel.invokeMethod("cardEntryComplete", null);
                    }
                  }
                }, delayDurationMs);
              }
            }
          });
        }

        if (requestCode == BuyerVerification.DEFAULT_BUYER_VERIFICATION_REQUEST_CODE) {
          BuyerVerification.handleActivityResult(data, result -> {
            if (result.isSuccess()) {
              if(CardEntryModule.this.paymentSourceId == null) {
                Map<String, Object> mapToReturn = cardDetailsConverter.toMapObject(CardEntryModule.this.cardResult);
                mapToReturn.put("token", result.getSuccessValue().getVerificationToken());
                channel.invokeMethod("onBuyerVerificationSuccess", mapToReturn);
              }else{
                Map<String, Object> mapToReturn = new LinkedHashMap<>();
                mapToReturn.put("nonce", CardEntryModule.this.paymentSourceId);
                mapToReturn.put("token", result.getSuccessValue().getVerificationToken());
                channel.invokeMethod("onBuyerVerificationSuccess", mapToReturn);
              }
            } else if (result.isError()) {
              Error error = result.getErrorValue();
              Map<String, String> errorMap = ErrorHandlerUtils.getCallbackErrorObject(error.getCode().name(), error.getMessage(), error.getDebugCode(), error.getDebugMessage());
              channel.invokeMethod("onBuyerVerificationError", errorMap);
            }
          });

          CardEntryModule.this.contact = null;
        }
        return false;
      }
    };
  }

  private long readCardEntryCloseExitAnimationDurationMs() {
    long delayDurationMs = 0;
    Resources.Theme theme = currentActivity.getResources().newTheme();
    theme.applyStyle(R.style.sqip_Theme_CardEntry, true);
    int[] attrs = { android.R.attr.activityCloseExitAnimation };
    TypedArray typedArray = theme.obtainStyledAttributes(null, attrs, android.R.attr.windowAnimationStyle, 0);
    int resId = typedArray.getResourceId(0, -1);
    if (resId != -1) {
      try {
        Animation animation = loadAnimation(currentActivity, resId);
        delayDurationMs = animation.getDuration();
      } catch (Resources.NotFoundException ignored) {
      }
    }

    typedArray.recycle();
    return delayDurationMs;
  }
}
