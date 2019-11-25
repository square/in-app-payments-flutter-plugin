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
package sqip.flutter;

import java.util.HashMap;
import java.util.ArrayList;

import sqip.InAppPaymentsSdk;
import sqip.Currency;
import sqip.Country;
import sqip.Money;
import sqip.BuyerAction;
import sqip.SquareIdentifier;
import sqip.Contact;
import sqip.SquareIdentifier.LocationToken;
import sqip.flutter.internal.CardEntryModule;
import sqip.flutter.internal.GooglePayModule;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class SquareInAppPaymentsFlutterPlugin implements MethodCallHandler {
  private static MethodChannel channel;

  private final CardEntryModule cardEntryModule;
  private final GooglePayModule googlePayModule;

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    channel = new MethodChannel(registrar.messenger(), "square_in_app_payments");
    channel.setMethodCallHandler(new SquareInAppPaymentsFlutterPlugin(registrar));
  }

  private SquareInAppPaymentsFlutterPlugin(Registrar registrar) {
    cardEntryModule = new CardEntryModule(registrar, channel);
    googlePayModule = new GooglePayModule(registrar, channel);
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {
    if (call.method.equals("setApplicationId")) {
      String applicationId = call.argument("applicationId");
      InAppPaymentsSdk.INSTANCE.setSquareApplicationId(applicationId);
      result.success(null);
    } else if (call.method.equals("startCardEntryFlow")) {
      boolean collectPostalCode = call.argument("collectPostalCode");
      cardEntryModule.startCardEntryFlow(result, collectPostalCode);
    } else if (call.method.equals("completeCardEntry")) {
      cardEntryModule.completeCardEntry(result);
    } else if (call.method.equals("showCardNonceProcessingError")) {
      String errorMessage = call.argument("errorMessage");
      cardEntryModule.showCardNonceProcessingError(result, errorMessage);
    } else if (call.method.equals("initializeGooglePay")) {
      String squareLocationId = call.argument("squareLocationId");
      int environment = call.argument("environment");
      googlePayModule.initializeGooglePay(squareLocationId, environment);
      result.success(null);
    } else if (call.method.equals("canUseGooglePay")) {
      googlePayModule.canUseGooglePay(result);
    } else if (call.method.equals("requestGooglePayNonce")) {
      String price = call.argument("price");
      String currencyCode = call.argument("currencyCode");
      int priceStatus = call.argument("priceStatus");
      googlePayModule.requestGooglePayNonce(result, price, currencyCode, priceStatus);
    } else if (call.method.equals("startCardEntryFlowWithBuyerVerification")) {
      boolean collectPostalCode = call.argument("collectPostalCode");

      HashMap<String, Object> moneyMap = call.argument("money");
      Money money = new Money(
        ((Integer)moneyMap.get("amount")).intValue(),
        sqip.Currency.valueOf((String)moneyMap.get("currencyCode")));

      String buyerActionString = call.argument("buyerAction");
      BuyerAction buyerAction;
      if (buyerActionString.equals("Store")) {
        buyerAction = new BuyerAction.Store();
      } else {
        buyerAction = new BuyerAction.Charge(money);
      }

      String squareLocationId = call.argument("squareLocationId");
      SquareIdentifier squareIdentifier = new SquareIdentifier.LocationToken(squareLocationId);

      // Contact info
      String givenName = call.argument("givenName");
      String familyName = call.argument("familyName");
      ArrayList<String> addressLines = call.argument("addressLines");
      String city = call.argument("city");
      String countryCode = call.argument("countryCode");
      String email = call.argument("email");
      String phone = call.argument("phone");
      String postalCode = call.argument("postalCode");
      String region = call.argument("region");
      Country country = Country.valueOf((countryCode != null) ? countryCode : "US");
      Contact contact = new Contact.Builder()
        .familyName((familyName != null) ? familyName : "")
        .email((email != null) ? email : "")
        .addressLines((addressLines != null) ? addressLines : new ArrayList<String>())
        .city((city != null) ? city : "")
        .countryCode(country)
        .postalCode((postalCode != null) ? postalCode : "")
        .phone((phone != null) ? phone : "")
        .region((region != null) ? region : "")
        .build(givenName);

      cardEntryModule.startCardEntryFlowWithBuyerVerification(result, collectPostalCode, squareIdentifier, buyerAction, contact);
    } else {
      result.notImplemented();
    }
  }
}
