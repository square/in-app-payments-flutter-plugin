# Flutter plugin for In-App Payments SDK

This repo contains a Flutter plugin for Square [In-App Payments SDK]. In-App Payments SDK for
Flutter supports the following native In-App Payments SDK versions:

  * iOS: version 1.0.0
  * Android: 1.0.0

## In this repo

In addition to the standard Flutter directories, this repo includes:

* [`docs`] - Documentation for the Flutter plugin, including a
  [getting started guide], [Enable Apple Pay guide], [Enable Google Pay guide], [technical reference], and [troubleshooting guide].
* [`example`] - A Flutter sample app with walkthrough.

## Build requirements

### Android

* Android SDK platform: API 27 (Oreo, 8.1).
* Android SDK build tools: 26.0.3
* Android Gradle Plugin: 3.0.0 or greater.
* Support library: 26.0.2
* Google Play Services: 12.0.1
* Google APIs Intel x86 Atom_64 System Image

### iOS

* Xcode version: 9.1 or greater.
* iOS Base SDK: 11.1 or greater.
* Deployment target: iOS 11.0 or greater.


## In-App Payments SDK requirements and limitations

* In-App Payments SDK is only available for accounts based in the United States.
  Authorization requests for accounts based outside the United States return an
  error.
* In-App Payments SDK cannot issue refunds. Refunds can be issued programmatically using
  the Transactions API or manually in the [Square Dashboard].
* In-App Payments SDK is not supported in the Square sandbox. See [Testing Mobile Apps]
  for testing recommendations.

## Before you start
* You will need a Square account enabled for payment processing. If you have not
  enabled payment processing on your account (or you are not sure), visit
  [squareup.com/activate].

* As an Alpha user, you need register your application ID with square to be able to take paymeent.
  Please contact us you haven't got one registered.

* For help getting started with Flutter, view Flutter online
[documentation](https://flutter.io/).

* For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).

## Getting Started with the In-App Payments SDK flutter plugin 

Read the [getting started guide] to learn how to set up a Flutter project for the In-App Payments SDK. Read 
the [Enable Apple Pay guide] and [Enable Google Pay guide] to learnhow to integrate digital wallet services 
into your Flutter project.



Please check the [`example`] app come with the the plugin project folder.

## Quick start example setup 

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

## License

```
Copyright 2018 Square Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

[//]: # "Link anchor definitions"
[squareup.com/activate]: https://squareup.com/activate
[In-App Payments SDK]: https://docs.connect.squareup.com/payments/inapppayments/intro
[Square Dashboard]: https://squareup.com/dashboard/
[Testing Mobile Apps]: https://docs.connect.squareup.com/testing/mobile
[`docs`]: https://github.com/JohnMAustin78/in-app-payments-sdk-flutter-plugin/tree/master/docs
[`example`]: https://github.com/JohnMAustin78/in-app-payments-sdk-flutter-plugin/tree/master/example
[getting started guide]: https://git.sqcorp.co/users/xiao/repos/in-app-payments-flutter-plugin/browse/docs/get-started.md
[Enable Apple Pay guide]: https://git.sqcorp.co/users/xiao/repos/in-app-payments-flutter-plugin/browse/docs/enable-applepay.md
[Enable Google Pay guide]: https://git.sqcorp.co/users/xiao/repos/in-app-payments-flutter-plugin/browse/docs/enable-googlepay.md
[technical reference]: https://git.sqcorp.co/users/xiao/repos/in-app-payments-flutter-plugin/browse/docs/reference.md
[troubleshooting guide]: https://git.sqcorp.co/users/xiao/repos/in-app-payments-flutter-plugin/browse/docs/troubleshooting.md
