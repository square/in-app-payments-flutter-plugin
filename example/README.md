#  In-App Payments Quick Start Sample Flutter Application

Follow the In-App Payments [Quick Start Guide](https://docs.connect.squareup.com/payments/readersdk/quickstart) to start taking credit card payments with Square.

## License
Copyright 2017 Square, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

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
of your development environment. The output Curl command is like the following command:

```
curl --header "Content-Type: application/json" \
     --header "Authorization: REPLACE_WITH_YOUR_ACCESS_TOKEN" \
     --header "Accept: application/json"\
     --request POST \
     --data '{
        "idempotency_key": "UUID_SUPPLIED_BY_SAMPLE",
        "amount_money": {
          "amount": CHARGE_AMOUNT_SUPPLIED_BY_SAMPLE,
          "currency": "CURRENCY_CODE_SUPPLIED_BY_SAMPLE"
        },
        "card_nonce": "CARD_NONCE_SUPPLIED_BY_SAMPLE"
      }' \
      https://connect.squareup.com/v2/locations/{LOCATION_ID_SUPPLIED_BY_SAMPLE}/transactions

```

1. Get sample app debug output for the following development environments
   * **VSCode:** Open the Debug Console
   * **Android Studio:** Open Logcat
   * **Xcode:** Open the **Debug Area**, output column
1. Copy the curl command into a text editor and replace the `Authorization` value
with your access token.
1. Paste the updated command into the terminal at the prompt and run it.
 

## Modify the project sample to use the nonce in a payment
The sample project creates a card nonce when you enter a payment card and complete 
a cookie purchase. However, it does not actually use the nonce to charge a payment
card. If you want use the nonce to create a 1 dollar charge to be credited to your Square developer
account, complete the next steps:

### Step 1: Get a backend payment processing URL   
To take a payment with a card nonce, you need access to a backend service that accepts
the nonce from the sample app and then sends a POST request to the Square Connect v2
charge endpoint. You can use a localhost process or a pre-built Square mobile backend quickstart.

#### Use your existing localhost process
If you already have a localhost process that uses the charge endpoint, then you can 
add logic to accept a nonce posted from this sample. 
1. Copy your Square developer account personal access token or sandbox token.
1. Read the dart code in the `chargeCard` method in the `lib/transaction_service.dart` file to see the format of the POST method the sample makes.
1. Add a POST method to an endpoint in your localhost service.
1. Add logic to your POST method like the following [PHP example] that uses the Square Connect v2 PHP SDK:
  ```php

# The access token to use in all Connect API requests. Use your *sandbox* access
# token if you're just testing things out.
$access_token = $_ENV["SANDBOX_ACCESS_TOKEN"];
$location_id =  $_ENV["SANDBOX_LOCATION_ID"];

  $transactions_api = new \SquareConnect\Api\TransactionsApi();

  $request_body = array (
    "card_nonce" => $nonce,
    # Monetary amounts are specified in the smallest unit of the applicable currency.
    # This amount is in cents. It's also hard-coded for $1.00, which isn't very useful.
    "amount_money" => array (
      "amount" => 100,
      "currency" => "USD"
    ),
    # Every payment you process with the SDK must have a unique idempotency key.
    # If you're unsure whether a particular payment succeeded, you can reattempt
    # it with the same idempotency key without worrying about double charging
    # the buyer.
    "idempotency_key" => uniqid()
  );
  ```

#### Use the Square Mobile Backend Quickstart
You can submit the card nonce to a secure heroku service app that takes the payment and 
credits it to your Square developer account. 
1. Follow the instructions in the Quickstart [README] to deploy the **Mobile Backend Quickstart** to Heroku. 
1. Get a payments processing URL by copying the URL of the deployed app.

### Step 2: Update sample process payments logic with a payment processing URL

1. Open the `transaction_service.dart` file.
1. On line 22, replace `REPLACE_ME` with the URL of your localhost instance or the
deployed mobile backend quickstart URL .


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

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

[//]: # "Link anchor definitions"
[In-App Payments SDK Overview]: https://docs.connect.squareup.com/payments/inapppayments/overview
[squareup.com/activate]: https://squareup.com/activate
[Square Application Dashboard]: https://connect.squareup.com/apps/
[Flutter Getting Started]: https://flutter.io/docs/get-started/install
[root README]: ../README.md
[transaction details in Square Dashboard]: https://squareup.com/dashboard/sales/transactions
