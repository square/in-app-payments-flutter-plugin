# Taking a payment with a Backend service

The In-App Payments Quick Start Sample flutter application generates a nonce and 
outputs a Curl command that posts the nonce to a Square server to take the payment.

This article shows you how to modify the quick start to use a Square backend quick
start server app or your own localhost app.


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