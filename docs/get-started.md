# Getting Started with the Flutter Plugin for In-App Payments SDK

This guide walks you through the process of setting up a new Flutter
project with In-App Payments SDK. See the
[Flutter In-App Payments SDK Technical Reference](reference.md)
for more detailed information about the methods available.


## Before you start

* You will need a Square account enabled for payment processing. If you have not
  enabled payment processing on your account (or you are not sure), visit
  [squareup.com/activate].
* Follow the **Install** instructions in the [Flutter Getting Started] guide to
  set up your Flutter development environment.


## Process overview

* [Step 1: Create a Flutter project](#step-1-create-a-flutter-project)
* [Step 2: Configure the In-App Payments SDK dependency](#step-2-configure-the-in-app-payments-sdk-dependency)
* [Step 3: Get Square Application ID](#step-3-get-square-application-id)
* [Step 4: Initialize the In-App Payments SDK](#step-4-initialize-the-in-app-payments-sdk)
* [Step 5: Implement the Payment flow](#step-5-implement-the-payment-flow)

## Step 1: Create a Flutter project

The basic command is:

```bash
flutter create in_app_payments_flutter_app
```

See the **Create the app** step of the [Test Drive] section in Flutter's getting
started guide for more detailed instructions.


## Step 2: Configure the In-App Payments SDK dependency

Edit the `pubspec.yaml` file in your `flutter` directory to define the In-App Payments
SDK dependency:
```yaml
dependencies:

  ...

  square_in_app_payments: ^1.0.0
```

## Step 3: Get Square Application ID

1. Open the [Square Application Dashboard].
1. Create a new Square application.
1. Click on the new application to bring up the Square application settings
   pages.
1. You will need the **Application ID** from the
   **Credentials** page to configure In-App Payments SDK in the next steps.

## Step 4: Initialize the In-App Payments SDK

1. Add code to your flutter project that extends [StatefulWidget](https://docs.flutter.io/flutter/widgets/StatefulWidget-class.html)

  ```dart
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

   class MyApp extends StatefulWidget {
     @override
     _MyAppState createState() => _MyAppState();
   }
  ```

1. Add code that initialize the In-App Payments SDK.

  ```dart
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

  class _MyAppState extends State<MyApp> {
    bool _paymentInitialized = false;

    @override
    void initState() {
      super.initState();
      _initSquarePayment();
    }

    Future<void> _initSquarePayment() async {
      await InAppPayments.setSquareApplicationId('APPLICATION_ID');

      setState(() {
        _paymentInitialized = true;
      });
    }
    ...
  } 

  ```
1. Replace `APPLICATION_ID` with the **application ID** from the application dashboard.

## Step 5: Implement the Payment flow

Add code to the `_MyAppState_` class that starts the payment flow and handles
the response. 

**Note**: You cannot start the payment flow from a modal screen. To start
the payment flow, you must close the modal screen before calling `startCardEntryFlow`.

```dart
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
class _MyAppState extends State<MyApp> {
...

  //The card entry form is closed
  void _onCardEntryComplete() {
    // Update UI to notify user that the payment flow is finished
  }

  //The SDK completed the request to produce a nonce
  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
    // Update UI to notify user that payment card is 
    // accepted
    Response response = await _processNonce(cardDetails.nonce);
    if (response.statusCode != 201) {
      await InAppPayments.showCardNonceProcessingError('failed to checkout.');
    } else {
      await InAppPayments.completeCardEntry(onCardEntryComplete: _onCardEntryComplete);
    }
  }

  //the user canceled payment card entry
  void _onCardEntryCancel() async {
    //User knows that they canceled the payment.
    //This callback can be used to clean up app state
    //related to the payment flow
  }

  //The user clicked a payment button on the UI to start the
  //payment flow
  Future<void> _onStartCardEntryFlow() async {
    try {
      await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess, 
        onCardEntryCancel: _onCardEntryCancel);
    } on PlatformException {
      print('Failed to startCardEntryFlow.');
    }
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
