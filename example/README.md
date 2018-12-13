# Flutter Plugin for In-App Payments SDK Quick Start

Demonstrates how to use the square_in_app_payments plugin.

## Assumptions and prerequisites

This quick start guide makes the following assumptions:

* You have read the [In-App Payments SDK Overview]. This quick start focuses on getting
  the sample app installed and running to demonstrate how the Flutter
  plugin works.
* You have a Square account enabled for payment processing. If you have not
  enabled payment processing on your account (or you are not sure), visit
  [squareup.com/activate].
* You are familiar with basic Flutter development.


## Before you start

* Follow the **Install** instructions in the [Flutter Getting Started] guide to
  setup your Flutter development environment.
* Confirm your environment meets the In-App Payments SDK build requirements listed in the [root README] for this repo.
* Clone this repo (if you have not already):
  `git clone https://github.com/square/in-app-payments-plugin.git`

* You will need a Square account enabled for payment processing. If you have not
  enabled payment processing on your account (or you are not sure), visit
  [squareup.com/activate].

### Step 1: Run the sample app for iOS

1. Change to the `ios` folder under `example`.
1. Download and configure the latest version of `SquareInAppPaymentsSDK.framework` in
   the `ios` folder.

3. Launch iOS emulator, run the example project from the `example` project folder: 
    ```bash
    cd /PATH/TO/LOCAL/example
    flutter run
    ```

### Step 2: Run the sample app for Android

1. Launch Android emulator, run the flutter example project from the `example` project folder:
    ```bash
    cd /PATH/TO/LOCAL/example
    flutter run
    ```
For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

[//]: # "Link anchor definitions"
[In-App Payments SDK Overview]: https://docs.connect.squareup.com/payments/inapppayments/overview
[squareup.com/activate]: https://squareup.com/activate
[Square Application Dashboard]: https://connect.squareup.com/apps/
[Flutter Getting Started]: https://flutter.io/docs/get-started/install
[root README]: ../README.md
[transaction details in Square Dashboard]: https://squareup.com/dashboard/sales/transactions