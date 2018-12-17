# Enable Google Pay with the Flutter Plugin for In-App Payments SDK

This guide walks you through the process of enabling the Google Pay digital wallet
for an app that uses the **Flutter In-App Payments SDK**. See the [Flutter In-App Payments SDK Technical Reference](reference.md)
for more detailed information about the Google Pay methods available.

**[Google Pay]** can only be used on Android devices.

## Before you start

* If you haven't already created a Flutter project with In-App Payments SDK, use the [Getting Started with the Flutter Plugin for In-App Payments SDK](get-started.md) to 
set up a Flutter project .


## Process overview

* [Step 1: Set up Google Pay on your device](#step-1-set-up-google-pay-on-your-device)
* [Step 2: Get a Square Location ID](#step-2-get-a-square-location-id)
* [Step 3: Initialize Google Pay](#step-3-initialize-google-pay)
* [Step 4: Implement the Google Pay flow](#step-4-implement-the-google-pay-flow)

## Step 1: Set up Google Pay on your device

1. Verify that your device has Google Play services version 16.0.0 or greater installed.
1. Install the Google Pay app on your device and [add a payment method]

## Step 2: Get a Square Location ID

1. Open the [Square Application Dashboard].
1. Click the application that you are using for this quick start.
1. You will need the **Location ID** from the
   **Locations** page to configure Google Pay in the next steps.

## Step 3: Initialize Google Pay


1. Add the Google Pay code marked by `Google Pay:` in your application State class. 
If you followed the [Getting Started Guide](get-started.md), then initialize Google Pay in the `_initSquarePayment` method and then save the return value of `InAppPayments.canUseGooglePay` in the app `State` object.
1. Replace the `LOCATION_ID` string with your **Location ID**.

  ```dart
  import 'dart:io' show Platform;
  import 'package:square_in_app_payments/models.dart';
  import 'package:square_in_app_payments/in_app_payments.dart';
  import 'dart:io' show Platform;


    class _MyAppState extends State<MyApp> {

      //Google Pay: Declare Google Pay enabled flag
      bool _googlePayEnabled = false;

      ...

      Future<void> _initSquarePayment() async {
        ...

        //Google Pay: Initialize Google Pay
        var canUseGooglePay = false;
        if(Platform.isAndroid) {
          // initialize the google pay with square location id
          // use test environment first to quick start
          await InAppPayments.initializeGooglePay(
            'LOCATION_ID', google_pay_constants.environmentTest);
          // always check if google pay supported on that device
          // before enable google pay
          canUseGooglePay = await InAppPayments.canUseGooglePay;
        }
        //Google Pay:

        setState(() {
          ...
          //Google Pay: Save the enabled state of Google Pay
          _googlePayEnabled = canUseGooglePay;
          ...
        });
      }
      ...
    } 
  ```
  * Replace `LOCATION_ID` in this example with a valid location ID for the associated Square account.

## Step 4: Implement the Google Pay flow

Add code to the `_MyAppState_` class that starts the payment flow and handles
the response. 

```dart
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
class _MyAppState extends State<MyApp> {
...
  /** 
  * An event listner to start google pay flow
  */
  void _onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
        price: '1.00',
        currencyCode: 'USD',
        onGooglePayNonceRequestSuccess: _onGooglePayNonceRequestSuccess,
        onGooglePayNonceRequestFailure: _onGooglePayNonceRequestFailure,
        onGooglePayCanceled: _onGooglePayCancel);
    } on InAppPaymentsException catch(ex) {
      // handle the failure of starting apple pay
    }
  }

  /**
  * Callback when successfully get the card nonce details for processig
  * google pay sheet has been closed when this callback is invoked
  */
  void _onGooglePayNonceRequestSuccess(CardDetails result) async {
    try {
      // take payment with the card nonce details
      // you can take a charge
      // await chargeCard(result);

    } on Exception catch (ex) {
      // handle card nonce processing failure
    }
  }

  /**
  * Callback when google pay is canceled
  * google pay sheet has been closed when this callback is invoked
  */
  void _onGooglePayCancel() {
    // handle google pay canceled
  }

  /**
  * Callback when failed to get the card nonce
  * google pay sheet has been closed when this callback is invoked
  */
  void _onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    // handle google pay failure
  }
  ...
}
```
---
**Note:** the `chargeCard` method in this example shows a typical REST request on a backend process that uses the **Transactions API** to take a payment with the supplied nonce. See [BackendQuickStart Sample] to learn about building an app that processes payment nonces on a server.

---

[//]: # "Link anchor definitions"
[docs.connect.squareup.com]: https://docs.connect.squareup.com
[In-App Payments SDK]: https://docs.connect.squareup.com/payments/readersdk/overview
[Square Dashboard]: https://squareup.com/dashboard/
[update policy for In-App Payments SDK]: https://docs.connect.squareup.com/payments/readersdk/overview#readersdkupdatepolicy
[Testing Mobile Apps]: https://docs.connect.squareup.com/testing/mobile
[squareup.com/activate]: https://squareup.com/activate
[Square Application Dashboard]: https://connect.squareup.com/apps/
[In-App Payments SDK Android Setup Guide]: https://docs.connect.squareup.com/payments/readersdk/setup-android
[In-App Payments SDK iOS Setup Guide]: https://docs.connect.squareup.com/payments/readersdk/setup-ios
[root README]: ../README.md
[Flutter Getting Started]: https://flutter.io/docs/get-started/install
[Test Drive]: https://flutter.io/docs/get-started/test-drive
[Google Pay]: https://developers.google.com/pay/api/android/overview
[Google Pay methods]: https://developers.google.com/pay/api/android/reference/client
[Google Pay objects]: https://developers.google.com/pay/api/android/reference/object 
[add a payment method]: https://support.google.com/pay/answer/7625139?
[BackendQuickStart Sample]: https://github.com/square/in-app-payments-server-quickstartvisit_id=636806718230188560-201650730&rd=1
