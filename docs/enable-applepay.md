# Enable Apple Pay with the Flutter Plugin for In-App Payments SDK

This guide walks you through the process of enabling the Apple Pay digital wallet
for an app that uses the **Flutter In-App Payments SDK**. See the [Flutter In-App Payments SDK Technical Reference](reference.md)
for more detailed information about the [Apple Pay] methods available.

**Apple Pay** can only be used on iOS devices.

## Before you start

* If you haven't already created a Flutter project with In-App Payments SDK, use the [Getting Started with the Flutter Plugin for In-App Payments SDK](get-started.md) to 
set up a Flutter project .

## Process overview

* [Step 1: Get an Apple Pay certificate from the Apple Developer Portal](#step-1-get-an-apple-pay-certificate-from-the-apple-developer-portal)
* [Step 2: Initialize Apple Pay and verify Apple Pay support](#step-2-initialize-apple-pay-and-verify-apple-pay-support)
* [Step 3: Authorize payment with Apple Pay](#step-3-authorize-payment-with-apple-pay)
* [Step 4: Get payment authorization result](#step-4-get-payment-authorization-result)
* [Step 5: Respond to Apple Pay payment authorization complete](#step-5-respond-to-apple-pay-payment-authorization-complete)

## Step 1: Get an Apple Pay certificate from the Apple Developer Portal
Before enabling **Apple Pay** in this sample, you need to get an Apple Pay certificate
and then upload it to the [Square Developer Application Dashboard]. This involves
getting a certificate signing request (CSR) from Square and using it to generate
an Apple Pay certificate in the **Apple Developer Center**. 

1. In your **Square Developer Application Dashboard**, select the application that you
registered to run this quick start sample.
1. Click the **Apple Pay** tab.
1. Click **Add Certifcate** and follow the instructions to acquire a certificate from Apple.


## Step 2: Initialize Apple Pay and verify Apple Pay support


Add code to initialize Apple Pay in your application State class. If you followed the [Getting Started Guide](get-started.md), then initialize Apple Pay in the `_initSquarePayment` method and then save the return
value of `InAppPayments.canUseApplePay` in the app `State` object.

```dart
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

class _MyAppState extends State<MyApp> {
  bool _applePayEnabled = false;

  ...

  Future<void> _initSquarePayment() async {
    ...
    var canUseApplePay = false;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      await InAppPayments.initializeApplePay('supercookie.com.flutter');
      canUseApplePay = await InAppPayments.canUseApplePay;
    }
    setState(() {
      ...
      _applePayEnabled = canUseApplePay;
      ...
    });
  }
  ...
} 

```

## Step 3: Authorize payment with Apple Pay
Open the Apple Pay sheet and request the user's authorization of the payment. On authorization, a
payment nonce is returned in `_onApplePayNonceRequestSuccess`.

```dart
  void _onStartApplePay() async {
    try {
      await InAppPayments.requestApplePayNonce(
          price: getCookieAmount(),
          summaryLabel: 'Cookie',
          countryCode: 'US',
          currencyCode: 'USD',
          onApplePayNonceRequestSuccess: _onApplePayNonceRequestSuccess,
          onApplePayNonceRequestFailure: _onApplePayNonceRequestFailure,
          onApplePayComplete: _onApplePayEntryComplete);
    } on PlatformException {
      _showOrderSheet();
    }
  }
```
## Step 4: Get payment authorization result

```dart
  void _onApplePayNonceRequestSuccess(CardDetails result) async {
    if (!_chargeBackendDomainReplaced) {
      showUrlNotSetAndPrintCurlCommand(result.nonce);
      return;
    }
    try {
      await chargeCard(result);
      showAlertDialog(context: scaffoldKey.currentContext, 
      title: "Your order was successful",
      description: "Go to your Square dashbord to see this order reflected in the sales tab.");
    } on ChargeException catch (e) {
      showAlertDialog(context: scaffoldKey.currentContext,
      title: "Error processing ApplePay payment",
      description: e.errorMessage);
    }
  }

  void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    await InAppPayments.completeApplePayAuthorization(isSuccess: false);
  }

```

## Step 5: Respond to Apple Pay payment authorization complete
The following callback is invoked when the Apple Pay payment authorization sheet is closed. 
The sample app uses this callback to return the user to the cookie order sheet.
```dart
  void _onApplePayEntryComplete() {
    _showOrderSheet();
  }

```
---


[//]: # "Link anchor definitions"
[docs.connect.squareup.com]: https://docs.connect.squareup.com
[In-App Payments SDK]: https://docs.connect.squareup.com/payments/in-app-payments-sdk/overview
[In-App Payments SDK Android Setup Guide]: https://docs.connect.squareup.com/payments/in-app-payments-sdk/setup-android
[In-App Payments SDK iOS Setup Guide]: https://docs.connect.squareup.com/payments/in-app-payments-sdk/setup-ios
[root README]: ../README.md
[Flutter Getting Started]: https://flutter.io/docs/get-started/install
[Test Drive]: https://flutter.io/docs/get-started/test-drive
[Apple Pay]: https://developer.apple.com/documentation/passkit/apple_pay
[Square Developer Application Dashboard]: https://connect.squareup.com/apps
