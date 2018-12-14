# In-App Payments SDK Flutter Plugin Technical Reference

This technical reference documents methods available in the Flutter
plugin for In-App Payments SDK. For detailed documentation on In-App Payments SDK, please see
[docs.connect.squareup.com].

---

* [Methods at a glance](#methods-at-a-glance)
* [Method details](#method-details)
* [Type definitions](#type-definitions)
* [Objects](#objects)
* [Constants](#constants)
* [Enumerations](#enumerations)
* [Errors](#errors)

---


## Methods at a glance


### Card entry methods
Method                                                       | Return Object             | Description
:----------------------------------------------------------- | :------------------------ | :------------------------------
[setSquareApplicationId](#setsquareapplicationid)            | void                      | Sets the Square Application ID.
[startCardEntryFlow](#startcardentryflow)                    | void                      | Displays a full-screen card entry view.
[completeCardEntry](#completecardentry)                      | void                      | Closes the card entry form on success.
[showCardNonceProcessingError](#showcardnonceprocessingerror)| void                      | Shows an error in the card entry form without closing the form.

### Apple Pay methods
Method                                                          | Return Object             | Description
:-------------------------------------------------------------- | :------------------------ | :-------------------------------
[setSquareApplicationId](#setsquareapplicationid)               | void                      | Sets the Square Application ID.
[initializeApplePay](#initializeapplepay)                       | void                      | Initializes the In-App Payments flutter plugin for Apple Pay.
[canUseApplePay](#canuseapplepay)                               | bool                      | Returns `true` if the device supports Apple Pay and the user has added at least one card that Square supports.
[requestApplePayNonce](#requestapplepaynonce)                   | void                      | Starts the Apple Pay payment authorization and returns a nonce based on the authorized Apple Pay payment token.
[completeApplePayAuthorization](#completeapplepayauthorization) | void                      | Notifies the native layer to close the Apple Pay sheet with success or failure status.
[setIOSCardEntryTheme](#setioscardentrytheme)                   | void                      | Sets the customization theme for the card entry view controller in the native layer.


### Google Pay methods
Method                                                       | Return Object                     | Description
:----------------------------------------------------------- | :-------------------------------- | :-------------------------------------
[setSquareApplicationId](#setsquareapplicationid)            | void                              | Sets the Square Application ID.
[initalizeGooglePay](#initializegooglepay)                   | void                              | Initializes the flutter plugin for Google Pay.
[canUseGooglePay](#canusegooglepay)                          | bool                              | Returns `true` if the device supports Google Pay and the user has added at least one card that Square supports.
[requestGooglePayNonce](#requestgooglepaynonce)              | void                              | Starts the Google Pay payment authorization and returns a nonce based on the authorized Google Pay payment token.




## Method details

### setSquareApplicationId

Used to set a Square Application ID on the `InAppPaymentsSDK` object.

---
**Note:** This method must be called before any other operations.

---

Parameter      | Type    | Description
:------------- | :------ | :-----------
applicationId  | String  | The Square Application ID otained from the developer portal


#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';

class _MyAppState extends State<MyApp> {
  ...
  Future<void> _initSquarePayment() async {
    InAppPayments.setSquareApplicationId(squareApplicationId);
   ...
    setState(() {
          isLoading = false;
    });
  }
  ...
}  
```


---

### startCardEntryFlow

Displays a full-screen card entry view. The method takes two callback parameters which correspond
to the possible results of the request. 

Parameter       | Type                                     | Description
:-------------- | :--------------------------------------- | :-----------
onCardNonceRequestSuccess | [CardEntryNonceRequestSuccessCallback](#cardentrynoncerequestsuccesscallback) | Invoked when card entry is completed and the SDK has processed the payment card information.
onCardEntryCancel | [CardEntryDidCancelCallback](#cardentrydidcancelcallback) | Invoked when card entry is canceled.

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';

  Future<void> onStartCardEntryFlow() async {
    try {
      await InAppPayments.startCardEntryFlow(
          onCardNonceRequestSuccess: await onCardEntryCardNonceRequestSuccess,
          onCardEntryCancel: await onCancelCardEntryFlow);
    } on PlatformException {
      showPlaceOrderSheet();
    }
  }
```
---
### completeCardEntry

Called in the `onCardNonceRequestSuccess` callback. Closes the card entry form. 

Parameter       | Type                                     | Description
:-------------- | :--------------------------------------- | :-----------
cardEntryCompleteCallback | [CardEntryCompleteCallback](#cardentrycompletecallback)| The callback invoked when card entry is completed and is closed. 


`completeCardEntry` should be called after all other callback logic is executed. 
If callback logic makes a server call to process the supplied nonce, 
this method is called after getting a success response from the server.  

If any nonce processing logic is to be executed _after_ the card entry form is closed, 
call `completeCardEntry` after getting the card nonce from the `onCardNonceRequestSuccess` 
`cardDetails` parameter. 

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';
    try {

      //chargeCard is an example of an asynchronous method that uses a card
      //nonce to take a payment by making a call on the Square Connect v2 
      //Charge endpoint. The call is awaited for results and then the 
      //card entry form is closed on success or left open for the user to 
      //update payment card information and resubmit.
      await chargeCard(result);
      InAppPayments.completeCardEntry(
        onCardEntryComplete: onCardEntryComplete);
    } on Exception catch (e) {
      InAppPayments.showCardNonceProcessingError(e.errorMessage);
    }
```


---
### showCardNonceProcessingError

Called in the `onCardNonceRequestSuccess` callback. Returns execution to the card entry form 
with an error string to be shown in the form. 

`showCardNonceProcessingError` should be called after all other callback logic is executed. 
If callback logic makes a server call to request a payment with the supplied nonce, 
this method is called after getting an error response from the server call.  


Parameter       | Type       | Description
:-------------- | :--------- | :-----------
errorMessage    | String     | The error message to be shown in the card entry form.

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';

   Future<Response> _processNonce(String cardNonce) async {
      final String url = 'https://api.supercookie.com/processnonce';
      final m = Map<String,String>();
      m.addAll({'Content-Type':'application/json'});
      return await http.post(
        url,
        headers: m,
        body: {'nonce': cardNonce, 'amount':'100'})
   }

   void _onCardNonceRequestSuccess(CardDetails cardDetails) async {
     Response response = await _processNonce(cardDetails.nonce);
     if (response.statusCode != 201) {
       await InAppPayments.showCardNonceProcessingError(
         'Payment card was not accepted.');
     } 
   }
```
---

### initializeApplePay

**iOS Only**

Initializes the In-App Payments flutter plugin for Apple Pay. 

This is a method called only once when flutter app is being initialized on an iOS device. 
Call this method only on an iOS device and when your app is intended to support Apple Pay.

Parameter          | Type          | Description
:----------------- | :------------ | :-----------
applePayMerchantId | String        | Registered Apple Pay merchant ID

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';
import 'dart:io' show Platform;

  if (Platform.isIOS) {
      await _setIOSCardEntryTheme();
      await InAppPayments.initializeApplePay(appleMerchantId);
      canUseApplePay = await InAppPayments.canUseApplePay;
  }
```


---

### canUseApplePay
**iOS Only**


Returns `true` if the device supports Apple Pay and the user has added at least one card that Square supports.
Not all brands supported by Apple Pay are supported by Square.

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';
import 'dart:io' show Platform;

  if (Platform.isIOS) {
      canUseApplePay = await InAppPayments.canUseApplePay;
  }
```


---

### requestApplePayNonce
**iOS Only**


Starts the Apple Pay payment authorization and returns a nonce based on the authorized Apple Pay payment token.

Parameter       | Type                                     | Description
:-------------- | :--------------------------------------- | :-----------
price           | String                                   | The payment authorization amount as a string.
summaryLabel    | String                                   | A label that displays the checkout summary in the Apple Pay view.
countryCode     | String                                   | The Apple Pay country code.
currencyCode    | String                                   | ISO currency code of the payment amount.
onApplePayNonceRequestSuccess | [ApplePayNonceRequestSuccessCallback](#applepaynoncerequestsuccesscallback) | Invoked before Apple Pay sheet is closed. The success callback carries the generated nonce
onApplePayNonceRequestFailure| [ApplePayNonceRequestFailureCallback](#applepaynoncerequestfailurecallback) | Invoked before Apple Pay sheet is closed. The failure callback carries information about the failure.
onApplePayComplete | [ApplePayCompleteCallback](#applepaycompletecallback) | Invoked when Apple Pay sheet is closed after success, failure, or cancellation.

Throws [InAppPaymentsException](#inapppaymentsexception)


#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';
  void onStartApplePay() async {
    try {
      await InAppPayments.requestApplePayNonce(
          price: getCookieAmount(),
          summaryLabel: 'Cookie',
          countryCode: 'US',
          currencyCode: 'USD',
          onApplePayNonceRequestSuccess: onApplePayNonceRequestSuccess,
          onApplePayNonceRequestFailure: onApplePayNonceRequestFailure,
          onApplePayComplete: onApplePayEntryComplete);
    } on PlatformException {
      showPlaceOrderSheet();
    }
  }
```

---

### completeApplePayAuthorization
**iOS Only**


Notifies the native layer to close the Apple Pay sheet with success or failure status.

Parameter                     | Type         | Description
:---------------------------- | :----------- | :-----------
isSuccess                     | bool         | Indicates success or failure.
**Optional**: errorMessage    | String       | The error message that Apple Pay displays in the native layer card entry view controller. 

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';

  void onApplePayNonceRequestSuccess(CardDetails result) async {
    try {

      //chargeCard is an example of an asynchronous method that uses a card
      //nonce to take a payment by making a call on the Square Connect v2 
      //Charge endpoint. The call is awaited for results and then the 
      //card entry form is closed on success or left open for the user to 
      //update payment card information and resubmit.

      await chargeCard(result);
      showAlertDialog(scaffoldKey.currentContext, "Your order was successful", "Go to your Square dashbord to see this order reflected in the sales tab.");
    } on ChargeException catch (e) {
      showAlertDialog(scaffoldKey.currentContext, "Error occurred", e.errorMessage);
    }
  }
```
---

### setIOSCardEntryTheme
**iOS Only**


Sets the customization theme for the card entry view controller in the native layer.

It is not necessary to call this method before starting Apple Pay. The SDK provides a default 
theme which can be customized to match the theme of your app. 

Parameter          | Type                                    | Description
:----------------- |:--------------------------------------- |:-----------
themeConfiguration | [IOSTheme](#iostheme)                   | An object that defines the theme of an iOS card entry view controller.

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';

  Future _setIOSCardEntryTheme() async {
    var themeConfiguationBuilder = IOSThemeBuilder();
    themeConfiguationBuilder.saveButtonTitle = 'Pay';
    themeConfiguationBuilder.errorColor = RGBAColorBuilder()
      ..r = 255
      ..g = 0
      ..b = 0;
    themeConfiguationBuilder.tintColor = RGBAColorBuilder()
      ..r = 36
      ..g = 152
      ..b = 141;
    themeConfiguationBuilder.keyboardAppearance = KeyboardAppearance.light;
    themeConfiguationBuilder.messageColor = RGBAColorBuilder()
      ..r = 114
      ..g = 114
      ..b = 114;

    await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
  }
```
--- 

### initializeGooglePay

**Android Only**


**Optional**: Used to enable Google Pay in an Android app. Initialize flutter plugin for google pay. 
This is a method called only once when flutter app is being initialized on an Android device. 

---
Note: The location ID is found in the Square developer dashboard, on the **locations** page.

---

Parameter          | Type            | Description
:----------------- | :-------------- | :-----------------------------------------------
squareLocationId   | String          | The Square Location ID from the developer portal. 
environment        | Int             | Specifies the Google Pay environment to run Google Pay in: `google_pay_constants.environmentTest`, `google_pay_constants.environmentProduction`



#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';
import 'dart:io' show Platform;

    if (Platform.isAndroid) {
      await InAppPayments.initializeGooglePay(
          squareLocationId, google_pay_constants.environmentTest);
    }
```


---

### canUseGooglePay
**Android Only**

Returns true if the device supports Google Pay and the user has added at least one 
card that Square supports. Square doesn't support all the brands apple pay supports.


* **Google Pay supported**: returns `true`.
* **Google Pay not supported**: returns `false`.

Throws [InAppPaymentsException](#inapppaymentsexception)

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';
import 'dart:io' show Platform;

    if (Platform.isAndroid) {
      canUseGooglePay = await InAppPayments.canUseGooglePay;
    }
```


---

### requestGooglePayNonce
**Android Only**

Starts the Google Pay payment authorization and returns a nonce based on the authorized Google Pay payment token.

Parameter                      | Type                                   | Description
:----------------------------- | :------------------------------------- | :-----------
price                          | String                                 | The payment authorization amount as a string. 
currencyCode                   | String                                 | The ISO currency code
priceStatus                    | [google_pay_constants](#google-pay-price-status-values).totalPriceStatusFinal | The status of the total price used
onGooglePayNonceRequestSuccess | [GooglePayNonceRequestSuccessCallback](#googlepaynoncerequestsuccesscallback)| Success callback invoked when a nonce is available.
onGooglePayNonceRequestFailure | [GooglePayNonceRequestFailureCallback](#googlepaynoncerequestfailurecallback) |Failure callback invoked when SDK failed to produce a nonce.
onGooglePayCanceled | [GooglePayCancelCallback](#googlepaycancelcallback) | Cancel callback invoked when user cancels payment authorization.


Throws [InAppPaymentsException](#inapppaymentsexception)
#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';

  void onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
          priceStatus: 1,
          price: getCookieAmount(),
          currencyCode: 'USD',
          onGooglePayNonceRequestSuccess: onGooglePayNonceRequestSuccess,
          onGooglePayNonceRequestFailure: onGooglePayNonceRequestFailure,
          onGooglePayCanceled: onGooglePayEntryCanceled);
    } on PlatformException {
      showPlaceOrderSheet();
    }
  }
```


---

## Type definitions
### CardEntryNonceRequestSuccessCallback

Callback invoked when card entry is returned successfully with card details.

Parameter       | Type                                     | Description
:-------------- | :--------------------------------------- | :-----------
cardDetails     | [CardDetails](#carddetails)              | The results of a successful card entry 
#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:http/http.dart' as http;

  void onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    if (chargeBackendDomain == "REPLACE_ME") {

    }
    try {

      //chargeCard is an example of an asynchronous method that uses a card
      //nonce to take a payment by making a call on the Square Connect v2 
      //Charge endpoint. The call is awaited for results and then the 
      //card entry form is closed on success or left open for the user to 
      //update payment card information and resubmit.
      await chargeCard(result);
      InAppPayments.completeCardEntry(
        onCardEntryComplete: onCardEntryComplete);
    } on ChargeException catch (e) {
      InAppPayments.showCardNonceProcessingError(e.errorMessage);
    }
  }
   
```
---
### CardEntryDidCancelCallback

Callback invoked when card entry canceled. 

Do not call [completeCardEntry](#completecardentry) because the operation is complete and the card entry form is closed.

#### Example usage
```dart
import 'package:square_in_app_payments/in_app_payments.dart';

  void onCancelCardEntryFlow() {
    //Return to calling activity
  }
```
---

### CardEntryCompleteCallback
Callback invoked when card entry is completed and has been closed.

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';

  void onCardEntryComplete() {
    showAlertDialog(scaffoldKey.currentContext, "Your order was successful", "Go to your Square dashbord to see this order reflected in the sales tab.");
  }

```

---
### ApplePayNonceRequestSuccessCallback
**iOS Only**


Callback invoked when Apple Pay card details are available

This is called before the Apple Pay payment authorization sheet is closed. Call [completeApplePayAuthorization](#completeapplepayauthorization) 
to close the apple pay sheet.

Parameter       | Type                         | Description
:-------------- | :--------------------------- | :-----------
cardDetails     | [CardDetails](#carddetails)  | The non-confidential details of the card and a nonce. 


#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';
  void onApplePayNonceRequestSuccess(CardDetails result) async {
    try {
      await chargeCard(result);
      showAlertDialog(scaffoldKey.currentContext, "Go to your Square dashbord to see this order reflected in the sales tab.");
    } on ChargeException catch (e) {
      showAlertDialog(scaffoldKey.currentContext, e.errorMessage);
    }
  }
```

---
### ApplePayNonceRequestFailureCallback
**iOS Only**


Callback invoked when a card nonce cannot be generated from Apple Pay payment authorization card input values.

This callback is invoked before the native iOS Apple Pay payment authorization view controller is closed. Call [completeApplePayAuthorization](#completeapplepayauthorization) with an error message to let the user modify input values and resubmit.

Parameter       | Type                     | Description
:-------------- | :----------------------- | :-----------
errorInfo       | [ErrorInfo](#errorinfo)  | Information about the error condition that prevented a nonce from being generated. 

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';
  void onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    await InAppPayments.completeApplePayAuthorization(isSuccess: false);
  }
```
---
### ApplePayCompleteCallback
**iOS Only**

Callback invoked when the native iOS Apple Pay payment authorization sheet is closed with success, failure, or cancellation.

This callback notifies caller widget when it should switch to other views.

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';
  void onApplePayEntryComplete() {
    //Return to calling activity
  }
```

---
### GooglePayNonceRequestSuccessCallback
**Android Only**

Callback invoked when [CardDetails](#carddetails) with Google Pay are available.

Parameter       | Type                         | Description
:-------------- | :--------------------------- | :-----------
cardDetails     | [CardDetails](#carddetails)  | The non-confidential details of the card and a nonce. 


#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';
  void onGooglePayNonceRequestSuccess(CardDetails result) async {
    try {
      await chargeCard(result);
      showAlertDialog(scaffoldKey.currentContext, "Go to your Square dashbord to see this order reflected in the sales tab.");
    } on ChargeException catch (e) {
      showAlertDialog(scaffoldKey.currentContext, e.errorMessage);
    }
  }
```

---
 ### GooglePayNonceRequestFailureCallback
**Android Only**
 
 Callback invoked a card nonce could not be obtained.

Parameter       | Type                     | Description
:-------------- | :----------------------- | :-----------
errorInfo       | [ErrorInfo](#errorinfo)  | Information about the cause of the error. 


 #### Example usage

 ```dart
import 'package:square_in_app_payments/in_app_payments.dart';
  void onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    showAlertDialog(scaffoldKey.currentContext, 'Failed to start GooglePay.\n ${errorInfo.toString()}');
  }
 ```

---
 ### GooglePayCancelCallback
**Android Only**
 
 Callback invoked when Google Pay payment authorization is canceled.

 #### Example usage

 ```dart
import 'package:square_in_app_payments/in_app_payments.dart';
  void onGooglePayEntryCanceled() {
    //return to calling activity
  }
 ```

---
## Classes

### InAppPaymentsException

 Signals that card entry exception of some sort has occurred. This
 class is the general class of exceptions produced by failed payment card
 processing operations.

#### Properties

Property          | Type                      | Description
:---------------- | :------------------------ | :-----------------
message           | String                    | A description of the usage error
debugCode         | String                    | Information about error state
debugMessage      | String                    | A description of the error state

#### Methods

**toString()**
Returns the **InAppPaymentsException** with properties as a string.

#### Example usage

```dart
import 'package:square_in_app_payments/models.dart';

  try {
    await InAppPayments.requestGooglePayNonce(
      price: '100',
      currencyCode: 'USD',
      priceStatus: google_pay_constants.totalPriceStatusFinal,
      onGooglePayNonceRequestSuccess: _onGooglePayNonceRequestSuccess,
      onGooglePayNonceRequestFailure: _onGooglePayNonceRequestFailure,
      onGooglePayCanceled: _onGooglePayCancel);
  } on InAppPaymentsException catch (ex) {
    print('Failed to onStartGooglePay. \n ${ex.toString()}');
  }
```


---
## Objects

In-App Payments SDK plugin objects are extended from [`built_value`], which is immutable
and serializable.

### CardDetails

Represents the result of a successful request to process payment card information.

Field           | Type            | Description
:-------------- | :-------------- | :-----------------
nonce           | String          | A one-time-use payment token that can be used with the Square Connect APIs to charge the card or save the card information.
card            | [Card](#card)   | Non-confidential details about the entered card, such as the brand and last four digits of the card number.

#### Example output

```dart
import 'package:square_in_app_payments/models.dart';

   cardDetails.toString();
   /* toString() output:
   {
     "nonce": "XXXXXXXXXXXXXXXXXXXXXXXX",
     "card": {
       ...
     }
   }
   */
```



---
### Card 

Represents the non-confidential details of a card.

Field           | Type              | Description
:---------------| :---------------- | :-----------------
brand           | [Brand](#brand)   | The brand (for example, VISA) of the card.
lastFourDigits  | String            | The last 4 digits of this card's number.
expirationMonth | int               | The expiration month of the card. Ranges between 1 and 12, with 1 corresponding to January and 12 to December.
expirationYear  | int               | The four-digit expiration year of the card.
postalCode      | @nullable String  | The billing postal code associated with the card.

#### Example output

```dart
import 'package:square_in_app_payments/models.dart';

   card.toString();
   /* toString() output:
   {
     "brand": "VISA",
     "lastFourDigits": "1111",
     "expirationMonth": 12,
     "expirationYear": 2019,
     "postalCode": "98020"
   }
   */
```

---



### ErrorInfo

Contains information about a payment card processing error.

Field             | Type                      | Description
:---------------- | :------------------------ | :-----------------
code              | [ErrorCode](#errorcode)   | The enumerated error types
message           | String                    | A description of the usage error
debugCode         | String                    | Information about error state
debugMessage      | String                    | A description of the error state

#### Example output

```dart
import 'package:square_in_app_payments/models.dart';

   errorInfo.toString();
   /* toString() output:
   {
     "code": "USAGE_ERROR",
     "message": "",
     "debugCode": "",
     "debugMessage": ""
   }
   */
```


---

### IOSTheme

Encapsulates options used to style the iOS native card entry view controller.

Field                              | Type               | Description
:--------------------------------- | :----------------- | :-----------------
**Optional**: font                 | Font               | The text field font.
**Optional**: emphasisFont         | Font               | The save button font.
**Optional**: backgroundColor      | RGBAColor          | The background color of the card entry view controller.
**Optional**: foregroundColor      | RGBAColor          | The fill color for text fields.
**Optional**: textColor            | RGBAColor          | The text field text color.
**Optional**: placeholderTextColor | RGBAColor          | The text field placeholder text color.
**Optional**: tintColor            | RGBAColor          | The tint color reflected in the text field cursor and submit button background color when enabled.
**Optional**: messageColor         | RGBAColor          | The text color used to display informational messages.
**Optional**: errorColor           | RGBAColor          | The text color when the text is invalid.
**Optional**: saveButtonTitle      | String             | The text of the entry completion button
**Optional**: saveButtonTextColor  | RGBAColor          | The save button text color when enabled.
**Optional**: keyboardAppearance   | KeyboardAppearance | The appearance of the keyboard.

## Constants

### Google Pay Price Status values

Constant                                               | Type             | Value  |Description
:----------------------------------------------------- | :--------------- | :------| :-----------------
google_pay_constants.totalPriceStatusNotCurrentlyKnown | int              | 1      |Used for a capability check
google_pay_constants.totalPriceStatusEstimated         | int              | 2      | Total price may adjust based on the details of the response, such as sales tax collected based on a billing address
google_pay_constants.totalPriceStatusFinal             | int              | 3      | Total price will not change from the amount presented to the user
---
### Google Pay environment values

Constant                                   | Type      | Value | Description
:----------------------------------------- | :-------- | :-----| :-----------------
google_pay_constants.environmentProduction | int       | 1     | Environment to be used when an app is granted access to the Google Pay production environment
google_pay_constants.environmentTest       | int       | 3     | Environment to be used for development and testing an application before approval for production.

## Enumerations

Enumerations in In-App Payments SDK are implemented as strings rather than explicit types,
but the plugin returns and consumes explicit string values for the
constants.


### Brand

Supported brands for `card` payments accepted during the In-App Payments SDK checkout
flow.

* `VISA` - Visa Inc. credit or debit card.
* `MASTERCARD` - Mastercard Incorporated credit or debit card.
* `AMERICAN_EXPRESS` - merican Express Company credit card.
* `DISCOVER` - Discover Financial Services credit card.
* `DISCOVER_DINERS` - Diners Club International credit card.
* `INTERAC` - Canadian Interbank Network debit card.
* `JCB` - Japan Credit Bureau credit card.
* `CHINA_UNIONPAY` - China UnionPay credit card.
* `SQUARE_GIFT_CARD` - [Square-issued gift card].
* `OTHER_BRAND` - An unexpected card type.


---



## ErrorCode

ErrorCode                                             | Cause                                                            | Returned by
:---------------------------------------------------- | :--------------------------------------------------------------- | :---
<a id="e1">`usageError`</a>                           | In-App Payments SDK was used in an unexpected or unsupported way.| all methods
<a id="e2">`noNetwork`</a>                            | In-App Payments SDK could not connect to the network.            | [ApplePayNonceRequestFailureCallback](#applepaynoncerequestfailurecallback), [GooglePayNonceRequestFailureCallback](#googlepaynoncerequestfailurecallback)


[//]: # "Link anchor definitions"
[docs.connect.squareup.com]: https://docs.connect.squareup.com
[In-App Payments SDK]: https://docs.connect.squareup.com/payments/inapppayments/intro
[ISO 4217 format]: https://www.iban.com/currency-codes.html
[Square Dashboard]: https://squareup.com/dashboard/
[Transactions API]: https://docs.connect.squareup.com/payments/transactions/overview
[Square-issued gift card]: https://squareup.com/us/en/software/gift-cards
[`built_value`]: https://github.com/google/built_value.dart
