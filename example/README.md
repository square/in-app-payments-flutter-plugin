# Flutter Plugin for In-App Payments SDK Quick Start

Demonstrates how to use the square_in_app_payments plugin.

## Assumptions and prerequisites

## Before you start

* Follow the **Install** instructions in the [Flutter Getting Started] guide to
  setup your Flutter development environment.
* Confirm your environment meets the In-App Payments SDK build requirements listed in the [root README] for this repo.
* Clone this repo (if you have not already):
  `git clone https://github.com/square/in-app-payments-plugin.git`

* You will need a Square account enabled for payment processing. If you have not
  enabled payment processing on your account (or you are not sure), visit
  [squareup.com/activate].

* For help on editing plugin code, read about implementing packages in the [Flutter documentation](https://flutter.io/developing-packages/#edit-plugin-package).

## Getting Started with the In-App Payments SDK flutter plugin 

Read the [getting started guide] to learn how to set up a Flutter project for the In-App Payments SDK. Read 
the [Enable Apple Pay guide] and [Enable Google Pay guide] to learnhow to integrate digital wallet services 
into your Flutter project.



Please check the [`example`] app come with the the plugin project folder.


### Step 1: Run the sample app for iOS

1. Change to the iOS folder (`ios`) at the root of your Flutter project.
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