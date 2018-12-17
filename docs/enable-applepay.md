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
import 'dart:io' show Platform;
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

class _MyAppState extends State<MyApp> {
  bool _applePayEnabled = false;

  ...

  Future<void> _initSquarePayment() async {
    ...
    var canUseApplePay = false;
    if (Platform.isIOS) {
      // initialize the apple pay with apple pay merchant id
      await InAppPayments.initializeApplePay('APPLE_PAY_MERCHANT_ID');
      // always check if apple pay supported on that device
      // before enable apple pay
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

* Replace `APPLE_PAY_MERCHANT_ID` in this example with a valid apple pay merchant ID.

## Step 3: Authorize payment with Apple Pay
Open the Apple Pay sheet and request the user's authorization of the payment. On authorization, a
payment nonce is returned in `_onApplePayNonceRequestSuccess`.

```dart
  /** 
  * An event listner to start apple pay flow
  */
  void _onStartApplePay() async {
    try {
      await InAppPayments.requestApplePayNonce(
          price: '1.00',
          summaryLabel: 'Cookie',
          countryCode: 'US',
          currencyCode: 'USD',
          onApplePayNonceRequestSuccess: _onApplePayNonceRequestSuccess,
          onApplePayNonceRequestFailure: _onApplePayNonceRequestFailure,
          onApplePayComplete: _onApplePayEntryComplete);
    } on PlatformException catch (ex) {
      // handle the failure of starting apple pay
    }
  }
```
## Step 4: Get payment authorization result

```dart
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

## Step 5: Respond to Apple Pay payment authorization complete
The following callback is invoked when the Apple Pay payment authorization sheet is closed. 

```dart
  /**
  * Callback when the apple pay sheet is closed after
  * call completeApplePayAuthorization
  */
  void _onApplePayEntryComplete() {
    // handle the apple pay sheet closed event
  }

```

---
**Note:** the `chargeCard` method in this example shows a typical REST request on a backend process that uses the **Transactions API** to take a payment with the supplied nonce. See [BackendQuickStart Sample] to learn about building an app that processes payment nonces on a server.

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
[BackendQuickStart Sample]: https://github.com/square/in-app-payments-server-quickstart
