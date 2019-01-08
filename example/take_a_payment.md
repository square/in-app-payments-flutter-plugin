# Taking a payment with a Backend service

The In-App Payments Quick Start Sample flutter application generates a nonce and 
outputs a cURL command that posts the nonce to the Square Charge endpoint.

This article shows you how to modify the Flutter sample app to use a Square backend quick
start server app or your own app on Localhost.


## Modify the sample
To use the nonce to create a 1 dollar charge to be credited to your Square developer
account, complete the next steps:

### Step 1: Get a backend payment processing URL   
You need access to a backend service that accepts the nonce from the sample app and 
then sends a POST request to the Square Charge endpoint.

#### Option 1: Use a localhost URL
If you already have a localhost process that uses the charge endpoint, then you can 
add logic to accept a nonce posted from this sample by following these steps: 
1. Copy your Square developer account personal access token or sandbox token.
1. Add a POST method that accepts requests with the following parameters:

   * Header - "Accept" : "application/json" 
   * Header -  "content-type" : "application/json"
   * Request body -  `{"nonce": nonce}`
   * Return value -  200 if charge is successful.

  >**Note:** The `chargeCard` method in the [transaction_service.dart](./lib/transaction_service.dart) file shows the 
  POST request by the client.

3. Take a payment with the nonce in your POST method using the following PHP example:
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

#### Option 2: Use the Square Mobile Backend Quickstart URL
You can submit the card nonce to a secure heroku service app that takes the payment and 
credits it to your Square developer account. 
1. Follow the instructions in the Quickstart [README] to deploy the **Mobile Backend Quickstart** to Heroku. 
1. Get a payments processing URL by copying the URL of the deployed app.

### Step 2: Update sample process payments logic with a payment processing URL

1. Open the [transaction_service.dart](./lib/transaction_service.dart) file.
1. On line 25, replace `chargeServerHost` with the domain of the
deployed mobile backend quickstart app.


### Step 3: Run the sample app for iOS

1. Launch iOS emulator, run the example project from the `example` project folder: 
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