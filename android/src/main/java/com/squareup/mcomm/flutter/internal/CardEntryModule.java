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
import android.util.Log;
import com.squareup.mcomm.CardEntryActivityCallback;
import com.squareup.mcomm.CardEntryActivityResult;
import com.squareup.mcomm.MobileCommerceSdk;
import com.squareup.mcomm.flutter.internal.converter.CardConverter;
import com.squareup.mcomm.flutter.internal.converter.CardResultConverter;
import io.flutter.plugin.common.MethodChannel;
import java.util.Map;

final public class CardEntryModule {

  private final Activity currentActivity;
  private final MobileCommerceSdk mobileCommerceSdk;
  private final CardResultConverter cardResultConverter;

  public CardEntryModule(Activity activity, MobileCommerceSdk mobileCommerceSdk, final MethodChannel channel) {
    currentActivity = activity;
    cardResultConverter = new CardResultConverter(new CardConverter());
    this.mobileCommerceSdk = mobileCommerceSdk;

    this.mobileCommerceSdk.cardEntryManager().addCardEntryActivityCallback(new CardEntryActivityCallback() {
      @Override public void onResult(CardEntryActivityResult cardEntryActivityResult) {
        if (cardEntryActivityResult.isCanceled()) {
          channel.invokeMethod("cardEntryDidCancel", null);
          return;
        }
        Map<String, Object> mapToReturn = cardResultConverter.toMapObject(cardEntryActivityResult.getSuccessValue().getCardResult());
        channel.invokeMethod("cardEntryDidSucceedWithResult", mapToReturn);
      }
    });
  }

  public void startCardEntryFlow(MethodChannel.Result result) {
    this.mobileCommerceSdk.cardEntryManager().startCardEntryActivity(this.currentActivity);
    result.success(null);
  }

  public void closeCardEntryForm(MethodChannel.Result result) {
    // TOOD: this is not doing any in alpha 0.2 because activity has been closed.
    Log.i("mcomm_plugin", "closeCardEntryForm");
    result.success(null);
  }

  public void showCardProcessingError(MethodChannel.Result result, String errorMessage) {
    // TOOD: this is not doing any in alpha 0.2 because activity has been closed.
    Log.e("mcomm_plugin", errorMessage);
    result.success(null);
  }
}
