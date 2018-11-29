# Enable Apple Pay with the Flutter Plugin for In-App Payments SDK

This guide walks you through the process of enabling the Apple Pay digital wallet
for an app that uses the **Flutter In-App Payments SDK**. See the [Flutter In-App Payments SDK Technical Reference](reference.md)
for more detailed information about the [Apple Pay] methods available.

**Apple Pay** can only be used on iOS devices.

## Before you start

* If you haven't already created a Flutter project with In-App Payments SDK, use the [Getting Started with the Flutter Plugin for In-App Payments SDK](get-started.md) to 
set up a Flutter project .

## Process overview

* [Step 1: Initialize Apple Pay](#step-1-initialize-apple-pay)
* [Step 2: Implement the Apple Pay flow](#step-2-implement-the-apple-pay-flow)


## Step 1: Initialize Apple Pay


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
      await _setIOSCardEntryTheme();
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

## Step 2: Implement the Apple Pay flow

Add code to the `_MyAppState_` class that starts the payment flow and handles
the response. 

**Note**: You cannot start the Apple Pay flow from a modal screen. To start
Apple Pay, you must close the modal screen before calling `requestApplePayNonce`.

```dart
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
class _MyAppState extends State<MyApp> {
 ...
  Future _setIOSCardEntryTheme() async {
    var themeConfiguationBuilder = IOSThemeBuilder();
    themeConfiguationBuilder.font = FontBuilder()..size = 24.0;
    themeConfiguationBuilder.backgroundColor = RGBAColorBuilder()
      ..r = 142
      ..g = 11
      ..b = 123;
    themeConfiguationBuilder.keyboardAppearance = KeyboardAppearance.dark;
    themeConfiguationBuilder.saveButtonTitle = 'Pay';

    await InAppPayments.setIOSCardEntryTheme(themeConfiguationBuilder.build());
  }
  void _onStartApplePay() async {
    try {
      await InAppPayments.requestApplePayNonce(
          price: '100',
          summaryLabel: 'My Checkout',
          countryCode: 'US',
          currencyCode: 'USD',
          onApplePayNonceRequestSuccess: _onApplePayNonceRequestSuccess,
          onApplePayNonceRequestFailure: _onApplePayNonceRequestFailure,
          onApplePayComplete: _onApplePayComplete);
    } on InAppPaymentsException catch(ex) {
      if (ex.code == ErrorCode.usageError) {
        print('Usage error: Please review payment card information and retry.\n ${ex.toString()}');
      } else {
        print('Network error: Please retry request.\n ${ex.toString()}');
      }
    }
  }

  void _onApplePayNonceRequestSuccess(CardDetails result) async {
    print(result);
    Response response = await _processNonce(cardDetails.nonce);
    if (response.statusCode == 201) {
      await InAppPayments.completeApplePayAuthorization(isSuccess: true);
    } else {
      await InAppPayments.completeApplePayAuthorization(
          isSuccess: false, errorMessage: "failed to charge amount.");
    }
  }

  void _onApplePayNonceRequestFailure(ErrorInfo errorInfo) async {
    print('ApplePay failed. \n ${errorInfo.toString()}');
    await InAppPayments.completeApplePayAuthorization(isSuccess: false);
  }

  void _onApplePayComplete() {
    print('ApplePay closed');
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
[Apple Pay]: https://developer.apple.com/documentation/passkit/apple_pay
