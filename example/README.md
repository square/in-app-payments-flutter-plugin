#  In-App Payments Quick Start Sample Flutter Application



## Assumptions and prerequisites

This quick start guide makes the following assumptions:

* You have read the [In-App Payments SDK Overview]. This quick start focuses on getting
  the sample app installed and running to demonstrate how the Flutter
  plugin works.
* You have a Square account enabled for payment processing. If you have not
  enabled payment processing on your account (or you are not sure), visit
  [squareup.com/activate].
* You are familiar with basic Flutter development.
* You have downloaded the [Serverless Charge Backend] quick start sample and installed the charge function as an AWS lambda function.

## Before you run the In-App Payments Quick Start

* Follow the **Install** instructions in the [Flutter Getting Started] guide to
  setup your Flutter development environment.
* Confirm your environment meets the In-App Payments SDK build requirements listed in the [root README] for this repo.
* Clone this repo (if you have not already):
  `git clone https://github.com/square/in-app-payments-plugin.git`
* You will need a Square account enabled for payment processing. If you have not
  enabled payment processing on your account (or you are not sure), visit
  [squareup.com/activate].

### Step 1: Get a Square Application ID and location ID 

1. Sign in to your [Application Dashboard](https://connect.squareup.com/apps).
1. Click the **New Application** button on the **Applications** page
1. Give your application a name and then click the **Create Application** button.
1. On the **Credentials** page of the application control panel, copy the
   **Application ID**.
1. On the **Locations** page, copy a **Location ID** from one of your locations. If you created a new Square account, choose **My Business**.


### Step 2: Configure the sample app
1. Change to the `lib` folder under `example`.
1. Open the `main.dart` file
1. On line 26, replace `REPLACE_ME` with the application ID from **Step 1**
1. On line 27 for Google Pay: Replace `REPLACE_ME` with the location ID from **Step 1**
1. On line 28, for Apple Pay: If you have an iOS App ID that is enabled for Apple Pay payment processing, replace `REPLACE_ME` with your Apple merchant ID. 

>Note: The sample includes code that can enable the Apple Pay and Google Pay buttons. 
To enable the Apple Pay button and authorize a payment, you need to have an active Apple Pay
developer account and a registered app with the Apple Pay capability. To enable the
Google Pay button in the Google Pay test environment, provide a location ID. 


### Step 3: Run the sample app for iOS

1. Change to the `ios` folder under `example`.
1. Launch iOS emulator, run the example project from the `example` project folder: 
    ```bash
    cd /PATH/TO/LOCAL/example
    flutter run
    ```

### Step 4: Run the sample app for Android

1. Launch Android emulator, run the flutter example project from the `example` project folder:
    ```bash
    cd /PATH/TO/LOCAL/example
    flutter run
    ```

### Step 5: Use the nonce in a Curl payment command
Take a payment with the card nonce by executing the Curl command written into the debug output.
of your development environment. 

Read about [taking a payment with a backend service] to learn how to modify this quick start to make a backend service call.

For help getting started with Flutter, view our online [documentation](https://flutter.io/).

[//]: # "Link anchor definitions"
[In-App Payments SDK Overview]: https://docs.connect.squareup.com/payments/in-app-payments-sdk/what-it-does
[squareup.com/activate]: https://squareup.com/activate
[Square Application Dashboard]: https://connect.squareup.com/apps/
[Flutter Getting Started]: https://flutter.io/docs/get-started/install
[root README]: ../README.md
[transaction details in Square Dashboard]: https://squareup.com/dashboard/sales/transactions
[taking a payment with a backend service]: take_a_payment.md