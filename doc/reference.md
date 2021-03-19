# In-App Payments SDK Flutter Plugin Technical Reference

This technical reference documents methods available in the Flutter
plugin for In-App Payments SDK. For detailed documentation on In-App Payments SDK, please see
[In-App Payments SDK].

---

* [Methods at a glance](#methods-at-a-glance)
* [Method details](#method-details)
* [Type definitions](#type-definitions)
* [Objects](#objects)
* [Constants](#constants)
* [Enumerations](#enumerations)
* [Error Codes](#errorcodes)

---


## Methods at a glance


### Card entry methods
Method                                                       | Return Object             | Description
:----------------------------------------------------------- | :------------------------ | :------------------------------
[setSquareApplicationId](#setsquareapplicationid)            | void                      | Sets the Square Application ID.
[startCardEntryFlow](#startcardentryflow)                    | void                      | Displays a full-screen card entry view.
[startCardEntryFlowWithBuyerVerification](#startcardentryflowwithbuyerverification) | void | Displays a full-screen card entry view with buyer verification flow enabled.
[completeCardEntry](#completecardentry)                      | void                      | Closes the card entry form on success.
[showCardNonceProcessingError](#showcardnonceprocessingerror)| void                      | Shows an error in the card entry form without closing the form.
[setIOSCardEntryTheme](#setioscardentrytheme)                | void                      | Sets the customization theme for the card entry view controller in the native layer.
[startBuyerVerificationFlow](#startbuyerverificationflow)    | void                      | Starts buyer verfication flow for card-on-file (cof). Displays verification view for some geographies.

### Apple Pay methods
Method                                                          | Return Object             | Description
:-------------------------------------------------------------- | :------------------------ | :-------------------------------
[setSquareApplicationId](#setsquareapplicationid)               | void                      | Sets the Square Application ID.
[initializeApplePay](#initializeapplepay)                       | void                      | Initializes the In-App Payments flutter plugin for Apple Pay.
[canUseApplePay](#canuseapplepay)                               | bool                      | Returns `true` if the device supports Apple Pay and the user has added at least one card that Square supports.
[requestApplePayNonce](#requestapplepaynonce)                   | void                      | Starts the Apple Pay payment authorization and returns a nonce based on the authorized Apple Pay payment token.
[completeApplePayAuthorization](#completeapplepayauthorization) | void                      | Notifies the native layer to close the Apple Pay sheet with success or failure status.



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
    @override
    void initState() {
      super.initState();
      _initSquarePayment();
    }

    Future<void> _initSquarePayment() async {
      await InAppPayments.setSquareApplicationId(squareApplicationId);
    ...
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
onCardEntryCancel | [CardEntryCancelCallback](#cardentrycancelcallback) | Invoked when card entry is canceled.
collectPostalCode | bool                                   | Indicates that the customer must enter the postal code associated with their payment card. When false, the postal code field will not be displayed. Defaults to `true`.<br/>**Notes**: A Postal code must be collected for processing payments for Square accounts based in the United States, Canada, and United Kingdom. Disabling postal code collection in those regions will result in all credit card transactions being declined.

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';

  Future<void> _onStartCardEntryFlow() async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow,
        /* optional */collectPostalCode: false);
  }

  void _onCancelCardEntryFlow() {
    // Handle the cancel callback
  }

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) {
    // process card nonce details
  }
```

---

### startCardEntryFlowWithBuyerVerification

Displays a full-screen card entry view with buyer verification flow enabled. The method takes three callback parameters which correspond
to the possible results of the request. 

Parameter       | Type                                     | Description
:-------------- | :--------------------------------------- | :-----------
onBuyerVerificationSuccess | [BuyerVerificationSuccessCallback](#BuyerVerificationSuccessCallback) | Invoked when card entry with buyer verification is completed successfully.
onBuyerVerificationFailure | [BuyerVerificationErrorCallback](#BuyerVerificationErrorCallback) | Invoked when card entry with buyer verification encounters errors.
onCardEntryCancel | [CardEntryCancelCallback](#cardentrycancelcallback) | Invoked when card entry is canceled.
buyerAction     | string                                   | Indicates the action (`Charge` or `Store`) that will be performed onto the card after retrieving the verification token. 
money           | [Money](#Money)                          | Amount of money that will be charged
squareLocationId | string                                  | The location that is being verified against.
contact         | [Contact](#Contact)                      | The customers information
collectPostalCode | bool                                   | Indicates that the customer must enter the postal code associated with their payment card. When false, the postal code field will not be displayed. Defaults to `true`.<br/>**Notes**: A Postal code must be collected for processing payments for Square accounts based in the United States, Canada, and United Kingdom. Disabling postal code collection in those regions will result in all credit card transactions being declined.

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';

  Future<void> _onStartCardEntryFlowWithBuyerVerification() async {
    var money = Money((b) => b
        ..amount = 100
        ..currencyCode = 'USD');
    
    var contact = Contact((b) => b
        ..givenName = "John"
        ..familyName = "Doe"
        ..addressLines = new BuiltList<String>(["London Eye","Riverside Walk"]).toBuilder()
        ..city = "London"
        ..countryCode = "GB"
        ..email = "johndoe@example.com"
        ..phone = "8001234567"
        ..postalCode = "SE1 7");
    
    await InAppPayments.startCardEntryFlowWithBuyerVerification(
        onBuyerVerificationSuccess: _onBuyerVerificationSuccess,
        onBuyerVerificationFailure: _onBuyerVerificationFailure,
        onCardEntryCancel: _onCancelCardEntryFlow,
        buyerAction: "Charge",
        money: money,
        squareLocationId: squareLocationId,
        contact: contact,
        collectPostalCode: true);
  }

  void _onCancelCardEntryFlow() {
    // handle the cancel callback
  }

  void _onBuyerVerificationSuccess(BuyerVerificationDetails result) async {
    // process card nonce and verification results
  }

  void _onBuyerVerificationFailure(ErrorInfo errorInfo) async {
    // handle the error
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
  void _onCardEntryCardNonceRequestSuccess(CardDetails result) {
    try {
      // take payment with the card nonce details
      // you can take a charge
      // await chargeCard(result);

      // payment finished successfully
      // you must call this method to close card entry
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
    } on Exception catch (ex) {
      // payment failed to complete due to error
      // notify card entry to show processing error
      InAppPayments.showCardNonceProcessingError(ex.message);
    }
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

  void _onCardEntryCardNonceRequestSuccess(CardDetails result) {
    try {
      // take payment with the card nonce details
      // you can take a charge or
      // await chargeCard(result);

      // payment finished successfully
      // you must call this method to close card entry
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
    } on Exception catch (ex) {
      // payment failed to complete due to error
      // notify card entry to show processing error
      InAppPayments.showCardNonceProcessingError(ex.message);
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
```
--- 

### startBuyerVerificationFlow

Starts buyer verfication flow for card on file(cof). Displays verification view for some geographies. The method takes two callback parameters which correspond
to the possible results of the request. 

Parameter       | Type                                     | Description
:-------------- | :--------------------------------------- | :-----------
onBuyerVerificationSuccess | [CardOnFileBuyerVerificationSuccessCallback](#CardOnFileBuyerVerificationSuccessCallback) | Invoked when card entry with buyer verification is completed successfully.
onBuyerVerificationFailure | [BuyerVerificationErrorCallback](#BuyerVerificationErrorCallback) | Invoked when card entry with buyer verification encounters errors.
buyerAction     | string                                   | Indicates the action (`Charge` or `Store`) that will be performed onto the card after retrieving the verification token. 
money           | [Money](#Money)                          | Amount of money that will be charged
squareLocationId | string                                  | The location that is being verified against.
contact         | [Contact](#Contact)                      | The customers information
paymentSourceId | string                                   | This ID can be the nounce returned by [CardEntryFlow](#startcardentryflow) or card-on-file ID for the buyer's payment card stored with Square.

**Note**: To test Buyer Verfication flow in the Sandbox, [Test Values](https://developer.squareup.com/docs/testing/test-values#sca-testing-in-the-payment-form) can be used.

#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';

  Future<void> _onStartBuyerVerificationFlow() async {
    var money = Money((b) => b
        ..amount = 100
        ..currencyCode = 'USD');
    
    var contact = Contact((b) => b
        ..givenName = "John"
        ..familyName = "Doe"
        ..addressLines = new BuiltList<String>(["London Eye","Riverside Walk"]).toBuilder()
        ..city = "London"
        ..countryCode = "GB"
        ..email = "johndoe@example.com"
        ..phone = "8001234567"
        ..postalCode = "SE1 7");
    
    await InAppPayments.startBuyerVerificationFlow(
        onCardOnFileBuyerVerificationSuccess: _onCardOnFileBuyerVerificationSuccess,
        onBuyerVerificationFailure: _onBuyerVerificationFailure,
        buyerAction: "Charge",
        money: money,
        squareLocationId: squareLocationId,
        contact: contact,
        paymentSourceId: "REPLACE_ME");
  }

  void _onCardOnFileBuyerVerificationSuccess(BuyerVerificationForCardOnFile result) async {
    // process card nonce and verification results
  }

  void _onBuyerVerificationFailure(ErrorInfo errorInfo) async {
    // handle the error
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
import 'dart:io' show Platform;
import 'package:square_in_app_payments/in_app_payments.dart';

  class _MyAppState extends State<MyApp> {
    ...
    @override
    void initState() {
      super.initState();
      _initSquarePayment();
    }

    Future<void> _initSquarePayment() async {
      ...
      if (Platform.isIOS) {
        await InAppPayments.initializeApplePay(appleMerchantId);
        ...
      }
    ...
    }
    ...
  }
```


---

### canUseApplePay
**iOS Only**


Returns `true` if the device supports Apple Pay and the user has added at least one card that Square supports.
Not all brands supported by Apple Pay are supported by Square.

#### Example usage

```dart
import 'dart:io' show Platform;
import 'package:square_in_app_payments/in_app_payments.dart';

  class _MyAppState extends State<MyApp> {
    ...
    @override
    void initState() {
      super.initState();
      _initSquarePayment();
    }

    Future<void> _initSquarePayment() async {
      ...
      if (Platform.isIOS) {
        ...
        canUseApplePay = await InAppPayments.canUseApplePay;
        ...
      }
    ...
    }
    ...
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
**Optional**: paymentType | [ApplePayPaymentType](#applepaypaymenttype) | Type of the payment summary item, `finalPayment` for default.
onApplePayNonceRequestSuccess | [ApplePayNonceRequestSuccessCallback](#applepaynoncerequestsuccesscallback) | Invoked before Apple Pay sheet is closed. The success callback carries the generated nonce
onApplePayNonceRequestFailure| [ApplePayNonceRequestFailureCallback](#applepaynoncerequestfailurecallback) | Invoked before Apple Pay sheet is closed. The failure callback carries information about the failure.
onApplePayComplete | [ApplePayCompleteCallback](#applepaycompletecallback) | Invoked when Apple Pay sheet is closed after success, failure, or cancellation.

Throws [InAppPaymentsException](#inapppaymentsexception)


#### Example usage

```dart
import 'package:square_in_app_payments/in_app_payments.dart';

  void _onStartApplePay() async {
    try {
      await InAppPayments.requestApplePayNonce(
          price: '1.00',
          summaryLabel: 'Cookie',
          countryCode: 'US',
          currencyCode: 'USD',
          paymentType: ApplePayPaymentType.finalPayment,
          onApplePayNonceRequestSuccess: _onApplePayNonceRequestSuccess,
          onApplePayNonceRequestFailure: _onApplePayNonceRequestFailure,
          onApplePayComplete: _onApplePayEntryComplete);
    } on PlatformException catch (ex) {
      // handle the failure of starting apple pay
    }
  }

  void _onApplePayNonceRequestSuccess(CardDetails result) async {
    // process card nonce before close apple pay sheet
  }

  void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    // handle this error before close apple pay sheet
  }

  void _onApplePayEntryComplete() {
    // handle the apple pay sheet closed event
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
  ...
  /**
  * Callback when successfully get the card nonce details for processig
  * apple pay sheet is still open and waiting for processing card nonce details
  */
  void _onApplePayNonceRequestSuccess(CardDetails result) async {
    try {
      // take payment with the card nonce details
      // you can take a charge
      // await chargeCard(result);

      // you must call completeApplePayAuthorization to close apple pay sheet
      await InAppPayments.completeApplePayAuthorization(isSuccess: true);
    } on Exception catch (ex) {
      // handle card nonce processing failure

      // you must call completeApplePayAuthorization to close apple pay sheet
      await InAppPayments.completeApplePayAuthorization(
        isSuccess: false,
        errorMessage: ex.message);
    }
  }

  /**
  * Callback when failed to get the card nonce
  * apple pay sheet is still open and waiting for processing error information
  */
  void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    // handle this error before close the apple pay sheet

    // you must call completeApplePayAuthorization to close apple pay sheet
    await InAppPayments.completeApplePayAuthorization(
      isSuccess: false,
      errorMessage: errorInfo.message);
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
import 'dart:io' show Platform;
import 'package:square_in_app_payments/in_app_payments.dart';
import 'package:square_in_app_payments/google_pay_constants.dart'
    as google_pay_constants;

  class _MyAppState extends State<MyApp> {
    ...
    @override
    void initState() {
      super.initState();
      _initSquarePayment();
    }

    Future<void> _initSquarePayment() async {
      ...
      if (Platform.isAndroid) {
        await InAppPayments.initializeGooglePay(
            squareLocationId, google_pay_constants.environmentTest);
        ...
      }
    ...
    }
    ...
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
import 'dart:io' show Platform;
import 'package:square_in_app_payments/in_app_payments.dart';

  class _MyAppState extends State<MyApp> {
    ...
    @override
    void initState() {
      super.initState();
      _initSquarePayment();
    }

    Future<void> _initSquarePayment() async {
      ...
      if (Platform.isAndroid) {
        ...
        canUseGooglePay = await InAppPayments.canUseGooglePay;
        ...
      }
    ...
    }
    ...
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
import 'package:square_in_app_payments/google_pay_constants.dart'
    as google_pay_constants;

  void onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
          priceStatus: google_pay_constants.totalPriceStatusFinal,
          price: '1.00',
          currencyCode: 'USD',
          onGooglePayNonceRequestSuccess: onGooglePayNonceRequestSuccess,
          onGooglePayNonceRequestFailure: onGooglePayNonceRequestFailure,
          onGooglePayCanceled: onGooglePayEntryCanceled);
    } on PlatformException {
      showPlaceOrderSheet();
    }
  }

  void _onGooglePayNonceRequestSuccess(CardDetails result) async {
    // process google pay card nonce details
  }

  void _onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    // handle google pay failure
  }

  void onGooglePayEntryCanceled() {
    // handle google pay canceled
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
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

  /**
  * Callback when successfully get the card nonce details for processig
  * card entry is still open and waiting for processing card nonce details
  */
  void _onCardEntryCardNonceRequestSuccess(CardDetails result) {
    try {
      // take payment with the card nonce details
      // you can take a charge
      // await chargeCard(result);

      // payment finished successfully
      // you must call this method to close card entry
      InAppPayments.completeCardEntry(
          onCardEntryComplete: _onCardEntryComplete);
    } on Exception catch (ex) {
      // payment failed to complete due to error
      // notify card entry to show processing error
      InAppPayments.showCardNonceProcessingError(ex.message);
    }
  }
```
---
### CardEntryCancelCallback

Callback invoked when card entry canceled and has been closed. 

Do not call [completeCardEntry](#completecardentry) because the operation is complete and the card entry form is closed.

---

### CardEntryCompleteCallback
Callback invoked when card entry is completed and has been closed.

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
  void _onApplePayNonceRequestSuccess(CardDetails result) async {
    try {
      // take payment with the card nonce details
      // you can take a charge
      // await chargeCard(result);

      // you must call completeApplePayAuthorization to close apple pay sheet
      await InAppPayments.completeApplePayAuthorization(isSuccess: true);
    } on Exception catch (ex) {
      // handle card nonce processing failure

      // you must call completeApplePayAuthorization to close apple pay sheet
      await InAppPayments.completeApplePayAuthorization(
        isSuccess: false,
        errorMessage: ex.message);
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
  void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    // handle this error before close the apple pay sheet

    // you must call completeApplePayAuthorization to close apple pay sheet
    await InAppPayments.completeApplePayAuthorization(
      isSuccess: false,
      errorMessage: errorInfo.message);
  }
```
---
### ApplePayCompleteCallback
**iOS Only**

Callback invoked when the native iOS Apple Pay payment authorization sheet is closed with success, failure, or cancellation.

This callback notifies caller widget when it should switch to other views.

---
### GooglePayNonceRequestSuccessCallback
**Android Only**

Callback invoked when [CardDetails](#carddetails) with Google Pay are available.

Parameter       | Type                         | Description
:-------------- | :--------------------------- | :-----------
cardDetails     | [CardDetails](#carddetails)  | The non-confidential details of the card and a nonce. 


#### Example usage

```dart
import 'package:square_in_app_payments/models.dart';

  void _onGooglePayNonceRequestSuccess(CardDetails result) async {
    try {
      // take payment with the card nonce details
      // you can take a charge
      // await chargeCard(result);
    } on Exception catch (ex) {
      // handle card nonce processing failure
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

---
 ### GooglePayCancelCallback
**Android Only**
 
 Callback invoked when Google Pay payment authorization is canceled.

---
 ### BuyerVerificationSuccessCallback
 
 Callback invoked when Buyer Verification flow succeeds.

---
 ### BuyerVerificationErrorCallback
 
 Callback invoked when Buyer Verification flow fails.

---
 ### CardOnFileBuyerVerificationSuccessCallback
 
 Callback invoked when Buyer Verification for card-on-file flow succeeds.
 
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

### BuyerVerificationDetails

Represents the result of a successful buyer verification request.

Field           | Type            | Description
:-------------- | :-------------- | :-----------------
nonce           | String          | A one-time-use payment token that can be used with the Square Connect APIs to charge the card or save the card information.
card            | [Card](#card)   | Non-confidential details about the entered card, such as the brand and last four digits of the card number.
token           | String          | The token representing a verified buyer.

#### Example output

```dart
import 'package:square_in_app_payments/models.dart';

   buyerVerificationDetails.toString();
   /* toString() output:
   {
     "nonce": "XXXXXXXXXXXXXXXXXXXXXXXX",
     "card": {
       ...
     },
     "token":
   }
   */
```

---

### Money

Amount to charge in the specified currencyCode.

Field           | Type            | Description
:-------------- | :-------------- | :-----------------
amount          | int             | Payment amount.
currencyCode    | String          | ISO currency code of the payment amount.

#### Example output

```dart
import 'package:square_in_app_payments/models.dart';

   money.toString();
   /* toString() output:
   {
     "amount": 100,
     "card": {
       ...
     },
     "currencyCode": "USD"
   }
   */
```

---

### Contact

This represents the required given name field and optional fields that can be passed in as part of the verification process.

Field           | Type            | Description
:-------------- | :-------------- | :-----------------
givenName       | String          | Given name of the contact.
familyName      | String          | Last name of the contact.
addressLines    | List<String>    | The street address lines of the contact address.
city            | String          | The city name of the contact address.
countryCode     | String          | A 2-letter string containing the ISO 3166-1 country code of the contact address.
email           | String          | Email address of the contact.
phone           | String          | The telephone number of the contact
postalCode      | String          | The postal code of the contact address.
region          | String          | The applicable administrative region (e.g., province, state) of the contact address.
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
type            | [CardType](#cardtype) | The type of card (for example, Credit or Debit). <br/>**Note**: This property is experimental and will always return `CardType.unknown`.
prepaidType     | [CardPrepaidType](#cardprepaidType) | The prepaid type of the credit card (for example, a Prepaid Gift Card). <br/>**Note**: This property is experimental and will always return `CardPrepaidType.unknown`.

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
     "message": "...",
     "debugCode": "...",
     "debugMessage": "..."
   }
   */
```


---

### IOSTheme

Encapsulates options used to style the iOS native card entry view controller.

Field                              | Type               | Description
:--------------------------------- | :----------------- | :-----------------
**Optional**: font                 | Font               | The text field font.
**Optional**: backgroundColor      | RGBAColor          | The background color of the card entry view controller.
**Optional**: foregroundColor      | RGBAColor          | The fill color for text fields.
**Optional**: textColor            | RGBAColor          | The text field text color.
**Optional**: placeholderTextColor | RGBAColor          | The text field placeholder text color.
**Optional**: tintColor            | RGBAColor          | The tint color reflected in the text field cursor and submit button background color when enabled.
**Optional**: messageColor         | RGBAColor          | The text color used to display informational messages.
**Optional**: errorColor           | RGBAColor          | The text color when the text is invalid.
**Optional**: saveButtonTitle      | String             | The text of the entry completion button
**Optional**: saveButtonFont       | Font               | The save button font.
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
---

## Enumerations

Enumerations in In-App Payments SDK are implemented as strings rather than explicit types,
but the plugin returns and consumes explicit string values for the
constants.


### Brand

Supported brands for `card` payments accepted during the In-App Payments SDK checkout
flow.

* `visa` - Visa Inc. credit or debit card.
* `mastercard` - Mastercard Incorporated credit or debit card.
* `americanExpress` - American Express Company credit card.
* `discover` - Discover Financial Services credit card.
* `discoverDiners` - Diners Club International credit card.
* `jcb` - Japan Credit Bureau credit card.
* `chinaUnionPay` - China UnionPay credit card.
* `otherBrand` - An unexpected card type.
---


### CardType

The type of card (for example, Credit or Debit). **Note**: This property is experimental and will always return `CardType.unknown`.

* `debit` - Debit card.
* `credit` - Credit card.
* `unknown` - Unable to determine type of the card.
---


### CardPrepaidType

The prepaid type of the credit card (for example, a Prepaid Gift Card). **Note**: This property is experimental and will always return `CardPrepaidType.unknown`.

* `prepaid` - Prepaid card.
* `notPrepaid` - Card that is not prepaid.
* `unknown` - Unable to determine whether the card is prepaid or not.
---

### ApplePayPaymentType

Type of the Apple Pay payment summary item.

* `pendingPayment` - A summary item representing an estimated or unknown cost.
* `finalPayment` - A summary item representing the known, final cost.

---

## ErrorCodes

ErrorCode                                             | Cause                                                            | Returned by
:---------------------------------------------------- | :--------------------------------------------------------------- | :---
<a id="e1">`usageError`</a>                           | In-App Payments SDK was used in an unexpected or unsupported way.| all methods
<a id="e2">`noNetwork`</a>                            | In-App Payments SDK could not connect to the network.            | [ApplePayNonceRequestFailureCallback](#applepaynoncerequestfailurecallback), [GooglePayNonceRequestFailureCallback](#googlepaynoncerequestfailurecallback)
<a id="e2">`failed`</a> | Square Buyer Verification SDK could not verify the provided card. | [BuyerVerificationErrorCallback](#BuyerVerificationErrorCallback)
<a id="e2">`canceled`</a> | The result when the customer cancels the Square Buyer Verification flow before a card is successfully verified. | [BuyerVerificationErrorCallback](#BuyerVerificationErrorCallback)
<a id="e2">`unsupportedSDKVersion`</a> | The version of the Square Buyer Verification SDK used by this application is no longer supported | [BuyerVerificationErrorCallback](#BuyerVerificationErrorCallback)


[//]: # "Link anchor definitions"
[In-App Payments SDK]: https://developer.squareup.com/docs/in-app-payments-sdk/what-it-does
[ISO 4217 format]: https://www.iban.com/currency-codes.html
[Square Dashboard]: https://squareup.com/dashboard/
[Square-issued gift card]: https://squareup.com/us/en/software/gift-cards
[`built_value`]: https://github.com/google/built_value.dart
