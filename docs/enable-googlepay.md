# Enable Google Pay with the Flutter Plugin for In-App Payments SDK

This guide walks you through the process of enabling the Google Pay digital wallet
for an app that uses the **Flutter In-App Payments SDK**. See the [Flutter In-App Payments SDK Technical Reference](reference.md)
for more detailed information about the Google Pay methods available.

**Google Pay** can only be used on native Android devices.

## Before you start

* If you haven't already created a Flutter project with In-App Payments SDK, use the [Getting Started with the Flutter Plugin for In-App Payments SDK](get-started.md) to 
set up a Flutter project .


## Process overview

* [Step 1: Initialize Google Pay](#step-1-initialize-google-pay)
* [Step 2: Implement the Google Pay flow](#step-2-implement-the-google-pay-flow)


## Step 1: Initialize Google Pay


1. Add code to initialize Google Pay in your application State class. If you followed the [Getting Started Guide](get-started.md), then initialize Google Pay in the `_initSquarePayment` method and then save the return
value of `InAppPayments.canUseGooglePay` in the app `State` object.

  ```dart
  import 'package:square_in_app_payments/models.dart';
  import 'package:square_in_app_payments/in_app_payments.dart';

    class _MyAppState extends State<MyApp> {
      bool _googlePayEnabled = false;

      ...

      Future<void> _initSquarePayment() async {
        ...
        var canUseGooglePay = false;
        if(Theme.of(context).platform == TargetPlatform.android) {
          await InAppPayments.initializeGooglePay(
            'LOCATION_ID', GooglePayEnvironment.test);
          canUseGooglePay = await InAppPayments.canUseGooglePay;
        }
        setState(() {
          ...
          _googlePayEnabled = canUseGooglePay;
          ...
        });
      }
      ...
    } 
  ```
1. Replace `LOCATION_ID` in this example with a valid location ID for the associated Square account.

## Step 2: Implement the Google Pay flow

Add code to the `_MyAppState_` class that starts the payment flow and handles
the response. 

**Note**: You cannot start the Google Pay flow from a modal screen. To start
Google Pay, you must close the modal screen before calling `requestGooglePayNonce`.

```dart
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
class _MyAppState extends State<MyApp> {
...
  void _onStartGooglePay() async {
    try {
      await InAppPayments.requestGooglePayNonce(
        price: '100',
        currencyCode: 'USD',
        onGooglePayNonceRequestSuccess: _onGooglePayNonceRequestSuccess,
        onGooglePayNonceRequestFailure: _onGooglePayNonceRequestFailure,
        onGooglePayCanceled: _onGooglePayCancel);
    } on InAppPaymentsException catch(ex) {
      if (ex.code == ErrorCode.usageError) {
        print('Usage error: Please review payment card information and retry.\n ${ex.toString()}');
      } else {
        print('Network error: Please retry request.\n ${ex.toString()}');
      }
    }
  }

  void _onGooglePayNonceRequestSuccess(CardDetails result) {
    Response response = await _processNonce(cardDetails.nonce);
    if (response.statusCode != 201) {
      print('Failed to complete payment with Google Pay');
    } else {
      print('Payment complete');
    }
  }

  void _onGooglePayCancel() {
    print('GooglePay is canceled');
  }

  void _onGooglePayNonceRequestFailure(ErrorInfo errorInfo) {
    print('GooglePay failed. \n ${errorInfo.toString()}');
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
[Mobile Authorization API]: https://docs.connect.squareup.com/payments/readersdk/mobile-authz-guide
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
