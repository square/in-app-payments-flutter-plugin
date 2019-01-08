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
* [Step 5: Customize iOS card entry theme](#step-5-customize-ios-card-entry-theme)
* [Step 6: Implement the Payment flow](#step-6-implement-the-payment-flow)

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

  square_in_app_payments:
    git: https://github.com/square/in-app-payments-flutter-plugin.git
```

## Step 3: Get Square Application ID

1. Open the [Square Application Dashboard].
1. Create a new Square application.
1. Click on the new application to bring up the Square application settings
   pages.
1. You will need the **Application ID** from the
   **Credentials** page to configure In-App Payments SDK in the next steps.

## Step 4: Initialize the In-App Payments SDK

1. Add code that initialize the In-App Payments SDK.
   ```dart
   import 'package:square_in_app_payments/models.dart';
   import 'package:square_in_app_payments/in_app_payments.dart';

   class _MyAppState {
     ...
     Future<void> _initSquarePayment() async {
       await InAppPayments.setSquareApplicationId('APPLICATION_ID');
     }
     ...
   } 

   ```

1. Replace `APPLICATION_ID` with the **application ID** from the application dashboard.

## Step 5: Customize card entry appearance
The Android and iOS platforms allow customization of the card entry screen but provide
different customization mechanisms.

### Android
You can customize the payment form `UI` by overriding the `sqip.Theme.CardEntry`
theme resource. The SDK honors customization of system style attributes and provides 3 custom style
attributes. 
<table>
  <tr>
   <th>Custom Style attribute
   </th>
   <th>Styled UI element
   </th>
  </tr>
  <tr>
   <td><code>sqipErrorColor </code>
   </td>
   <td>The color of invalid text input
   </td>
  </tr>
  <tr>
   <td><code> sqipSaveButtonText</code>
   </td>
   <td>The text of the button the customer clicks to submit their card information
   </td>
  </tr>
  <tr>
   <td><code>sqipActivityTitle</code>
   </td>
   <td>The title of the payment form displayed in the action bar.
   </td>
  </tr>
</table>

Change the appearance of the save button and the card information form to match
the styles in the app's theme. This will entirely override the style for these
elements, giving the application full control over their appearance.
1. Open `example/android/app/src/main/res/values/themes.xml`
2. Add an item with the `name="editTextStyle" `and the value set to your desired
   style.
```xml {"id": "inapppayments-customizeform-step 2.1", "copy_code": true}
  <style name="sqip.Theme.CardEntry" parent="sqip.Theme.BaseCardEntryAppTheme">
    …
     <item name="editTextStyle">@style/CustomEditText</item>
  </style>

  <style name="CustomEditText" parent="@style/Widget.AppCompat.EditText">
    <item name="android:textColor">@color/blue</item>
  </style>
```
3. Add an item with the `name="buttonStyle"` and the value set to your desired
   style.

```xml {"id": "inapppayments-customizeform-step 2.2", "copy_code": true}
  <style name="sqip.Theme.CardEntry" parent="sqip.Theme.BaseCardEntryAppTheme">
    …
     <item name="buttonStyle">@style/CustomButton</item>
  </style>

  <style name="CustomButton" parent="Widget.AppCompat.Button.Colored">
    <item name="android:textAllCaps">false</item>
    <item name="android:textSize">18sp</item>
  </style>
```

### iOS
For iOS devices, set the card entry error text and background color, keyboard appearance and message color.

1. Add code that creates a card entry theme and sets it in the plugin.
   ```dart
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

1. Call the `_setIOSCardEntryTheme` method.

   ```dart
   if (Platform.isIOS) {
      await _setIOSCardEntryTheme();
   }
   ```

## Step 6: Implement the Payment flow

Add code to the `_MyAppState_` class that starts the payment flow and handles
the response. 

**Note**: You cannot start the payment flow from a modal screen. To start
the payment flow, you must close the modal screen before calling `startCardEntryFlow`.

```dart
import 'package:square_in_app_payments/models.dart';
import 'package:square_in_app_payments/in_app_payments.dart';
class _MyAppState extends State<MyApp> {
...
  /** 
  * An event listner to start card entry flow
  */
  Future<void> _onStartCardEntryFlow() async {
    await InAppPayments.startCardEntryFlow(
        onCardNonceRequestSuccess: _onCardEntryCardNonceRequestSuccess,
        onCardEntryCancel: _onCancelCardEntryFlow);
  }

  /**
  * Callback when card entry is cancelled and UI is closed
  */
  void _onCancelCardEntryFlow() {
    // Handle the cancel callback
  }

  /**
  * Callback when successfully get the card nonce details for processig
  * card entry is still open and waiting for processing card nonce details
  */
  void _onCardEntryCardNonceRequestSuccess(CardDetails result) async {
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

  /**
  * Callback when the card entry is closed after call 'completeCardEntry'
  */
  void _onCardEntryComplete() {
    // Update UI to notify user that the payment flow is finished successfully
  }
  ...
}  
```
---
**Note:** the `chargeCard` method in this example shows a typical REST request on a backend process that uses the **Transactions API** to take a payment with the supplied nonce. See [BackendQuickStart Sample] to learn about building an app that processes payment nonces on a server.

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
[BackendQuickStart Sample]: https://github.com/square/in-app-payments-server-quickstart