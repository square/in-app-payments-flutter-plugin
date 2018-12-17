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
1. Replace the `"REPLACE_ME"` string with your **Location ID**.

  ```dart
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
        if (Platform.isAndroid) {
          await InAppPayments.initializeGooglePay(
              "REPLACE_ME", google_pay_constants.environmentTest);
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
1. Replace `LOCATION_ID` in this example with a valid location ID for the associated Square account.

## Step 4: Implement the Google Pay flow

Add code to the `_MyAppState_` class that starts the payment flow and handles
the response. 

```dart
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
class _MyAppState extends State<MyApp> {
...

   /**
   * An event listener to start Google Pay flow
   */ 
   void _onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
          priceStatus: 1,
          price: getCookieAmount(),
          currencyCode: 'USD',
          onGooglePayNonceRequestSuccess: _onGooglePayNonceRequestSuccess,
          onGooglePayNonceRequestFailure: _onGooglePayNonceRequestFailure,
          onGooglePayCanceled: onGooglePayEntryCanceled);
    } on PlatformException {
      _showOrderSheet();
    }
  }

   /**
   * Callback invoked when succeeded in getting card nonce details for
   * processing. Google Pay sheet is still open and waiting for results
   * of card processing
   */
   void _onGooglePayNonceRequestSuccess(CardDetails result) async {
    try {

      // take a payment with card nonce details
      // you can take a charge
      //await chargeCard(result);
      
      showAlertDialog(
          context: scaffoldKey.currentContext,
          title: "Your order was successful",
          description:
              "Go to your Square dashbord to see this order reflected in the sales tab.");
    } on ChargeException catch (e) {
      showAlertDialog(
          context: scaffoldKey.currentContext,
          title: "Error processing GooglePay payment",
          description: e.errorMessage);
    }
  }

  void onGooglePayEntryCanceled() {
    _showOrderSheet();
  }

  void _onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    showAlertDialog(
        context: scaffoldKey.currentContext,
        title: "Failed to start GooglePay",
        description: errorInfo.toString());
  }

  //Supercookie app sends the nonce to it's backend for 
  //processing. Returns a response to be fullfilled in the future
  Future<Response> _processNonce(String cardNonce) async {
    final String url = 'https://api.supercookie.com/processnonce';
    final headersMap = Map<String,String>();
    headersMap.addAll({'Content-Type':'application/json'});
    return await http.post(url, headers: headersMap ,body: {'nonce': cardNonce, 'amount':'100'})
  }
  ...
}
```
---
**Note:** the `_processNonce` method in this example shows a typical REST request on a backend process that uses the **Transactions API** to take a payment with the supplied nonce. See [BackendQuickStart Sample]() to learn about building an app that processes payment nonces on a server.

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
[add a payment method]: https://support.google.com/pay/answer/7625139?visit_id=636806718230188560-201650730&rd=1
