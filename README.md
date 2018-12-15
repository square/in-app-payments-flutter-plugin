# Flutter plugin for In-App Payments SDK

This repo contains a Flutter plugin for Square [In-App Payments SDK]. In-App Payments SDK for
Flutter supports the following native In-App Payments SDK versions:

  * iOS: 1.0.0
  * Android: 1.0.0

## Additional documentation

In addition to this README, the following is available in the [flutter plugin GitHub repo]:

* [Getting started guide]
* [Enable Apple Pay guide]
* [Enable Google Pay guide]
* [Technical reference]
* [Troubleshooting guide]
* [`docs`] - Root directory for all documentation.
* [`example`] - Root directory of the Flutter sample app (with walkthrough).
* [Getting started with the example app]

## Build requirements

* Android minSdkVersion is API 21 (Lollipop, 5.0) or higher. 
* Android Target SDK version: API 27 (Oreo, 8.1).
* Android SDK build tools: 26.0.3
* Android Gradle Plugin: 3.0.0 or greater.
* Support library: 27.1.1
* Google Play Services: 16.0.1
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

## Sample applications
* **Quick start flutter app:** You can learn how the In-App-Payments Flutter plugin is used by [getting started with the example app], a quick-start Flutter app that lets you take a payment after completing 5 simple set up steps. 
* **Quick start backend app:** The [In-App Payments Server Quickstart](https://github.com/square/in-app-payments-server-quickstart) takes the nonce created by the flutter app and uses it to create a payment credited to your Square account. Use this backend sample to quickly create a complete payment flow.

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
[`docs`]: https://github.com/square/in-app-payments-flutter-plugin/tree/master/docs
[`example`]: https://github.com/square/in-app-payments-flutter-plugin/tree/master/example
[Getting started guide]: https://github.com/square/in-app-payments-flutter-plugin/blob/master/docs/get-started.md
[Enable Apple Pay guide]: https://github.com/square/in-app-payments-flutter-plugin/blob/master/docs/enable-applepay.md
[Enable Google Pay guide]: https://github.com/square/in-app-payments-flutter-plugin/blob/master/docs/enable-googlepay.md
[Technical reference]: https://github.com/square/in-app-payments-flutter-plugin/blob/master/docs/reference.md
[Troubleshooting guide]: https://github.com/square/in-app-payments-flutter-plugin/blob/master/docs/troubleshooting.md
[flutter plugin GitHub repo]: https://github.com/square/in-app-payments-flutter-plugin/tree/master
[Getting started with the example app]: https://github.com/square/in-app-payments-flutter-plugin/tree/master/example/README.md
