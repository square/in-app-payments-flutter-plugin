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

## Before you run the In-App Payments Quick Start

* Follow the **Install** instructions in the [Flutter Getting Started] guide to
  setup your Flutter development environment.
* Confirm your environment meets the In-App Payments SDK build requirements listed in the [root README] for this repo.
* Clone this repo (if you have not already):
  `git clone https://github.com/square/in-app-payments-plugin.git`


### Step 1: Get a Square Application ID and Location ID 

1. Sign in to your [Application Dashboard](https://connect.squareup.com/apps).
1. Click the **New Application** button on the **Applications** page
1. Give your application a name and then click the **Create Application** button.
1. On the **Credentials** page of the application control panel, copy the
   **Application ID**.
1. On the **Locations** page of the application control panel, copy the
   **Location ID** of one of your locations.


### Step 2: Configure the sample app
1. Open `<YOUR_PROJECT_DIRECTORY>/example/lib/main.dart`
1. On line 27, replace `REPLACE_ME` with the Application ID from **Step 1**

### Step 3: Run the sample app for iOS

1. Launch iOS emulator, run the flutter example from the `example` project folder: 
    ```bash
    cd <YOUR_PROJECT_DIRECTORY>/example
    flutter run
    ```

### Step 4: Run the sample app for Android

1. Launch Android emulator, run the flutter example project from the `example` project folder:
    ```bash
    cd <YOUR_PROJECT_DIRECTORY>/example
    flutter run
    ```

### Step 5: Use the nonce in a Curl payment command
Take a payment with the card nonce by executing the Curl command written into the debug output.
of your development environment. 

Update the Curl command by completing the following steps:

1. Replace the Location ID placeholder in the Curl query string with the 
location ID that you copied in **Step 1**.
1. Replace the access token placeholder with your access token. 
1. Run the Curl command to take a payment in your Square account.
>**Note:** We provide a Curl command in the debug output that you can use to easily test the payment with our  Transactions API. Your production app should use a secure backend service to make calls to the Transactions API and should never expose your access token in the client.

Square provides a backend service in our sample app to get your started. follow the 
steps in the [backend service setup guide] to configure the backend sample.

For help getting started with Flutter, view [documentation](https://flutter.io/) online.

[//]: # "Link anchor definitions"
[In-App Payments SDK Overview]: https://docs.connect.squareup.com/payments/in-app-payments-sdk/what-it-does
[squareup.com/activate]: https://squareup.com/activate
[Square Application Dashboard]: https://connect.squareup.com/apps/
[Flutter Getting Started]: https://flutter.io/docs/get-started/install
[root README]: ../README.md
[transaction details in Square Dashboard]: https://squareup.com/dashboard/sales/transactions
[backend service setup guide]: take_a_payment.md
