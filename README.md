# Flutter plugin for In-App Payments SDK

[![build](https://github.com/square/in-app-payments-flutter-plugin/actions/workflows/build.yml/badge.svg)](https://github.com/square/in-app-payments-flutter-plugin/actions/workflows/build.yml)
[![Pub](https://img.shields.io/pub/v/square_in_app_payments)](https://pub.dev/packages/square_in_app_payments)

The Flutter plugin for Square [In-App Payments SDK] is a wrapper for the native Android and iOS SDKs and 
supports the following native In-App Payments SDK versions:

  * iOS: 1.6.3
  * Android: 1.6.8

## Additional documentation

In addition to this README, the following is available in the [flutter plugin GitHub repo]:

* [Getting started guide]
* [Enable Apple Pay guide]
* [Enable Google Pay guide]
* [Technical reference]
* [Troubleshooting guide]
* [`doc`] - Root directory for all documentation.
* [`example`] - Root directory of the Flutter sample app (with walkthrough).
* [Getting started with the example app]
* [Override the Native In-App Payments SDK Dependency Version]

## Build requirements

### Flutter

* Flutter version 3.0 or higher
* Dart version 2.12 or higher
  
### Android

* Android minSdkVersion is API 28 (Android 9). 
* Android Target SDK version: API 35 (Android15).
* Android SDK build tools: 26.0.3
* Android Gradle Plugin: 3.0.0 or greater.
* Support library: 27.1.1
* Google Play Services: 16.0.1
* Google APIs Intel x86 Atom_64 System Image

### iOS

* Xcode version: 10 or greater.
* iOS Base SDK: 12 or greater.
* Deployment target: iOS 12.0 or greater.
* This plugin will work on Mac with Intel processor and Apple silicon chips.

## In-App Payments SDK requirements and limitations

* In-App Payments SDK cannot issue refunds. Refunds can be issued programmatically using
  the Refunds API or manually in the [Square Dashboard].

## Sample applications
* **[Quick start flutter app]:** You can learn how the In-App-Payments Flutter plugin is used by [getting started with the example app], a quick-start Flutter app that lets you take a payment after completing 6 set up steps. 
* **Quick start backend app:** The [In-App Payments Server Quickstart](https://github.com/square/in-app-payments-server-quickstart) 
takes the nonce created by the flutter app and uses it to create a payment credited to your Square account. Use this backend sample to quickly create a complete payment flow.

## License

```
Copyright 2019 Square Inc.

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
[In-App Payments SDK]: https://developer.squareup.com/docs/in-app-payments-sdk/what-it-does
[Square Dashboard]: https://squareup.com/dashboard/
[Testing Mobile Apps]: https://docs.connect.squareup.com/testing/mobile
[`doc`]: https://github.com/square/in-app-payments-flutter-plugin/tree/master/doc
[`example`]: https://github.com/square/in-app-payments-flutter-plugin/tree/master/example
[Getting started guide]: https://github.com/square/in-app-payments-flutter-plugin/blob/master/doc/get-started.md
[Enable Apple Pay guide]: https://github.com/square/in-app-payments-flutter-plugin/blob/master/doc/enable-applepay.md
[Enable Google Pay guide]: https://github.com/square/in-app-payments-flutter-plugin/blob/master/doc/enable-googlepay.md
[Technical reference]: https://github.com/square/in-app-payments-flutter-plugin/blob/master/doc/reference.md
[Troubleshooting guide]: https://github.com/square/in-app-payments-flutter-plugin/blob/master/doc/troubleshooting.md
[flutter plugin GitHub repo]: https://github.com/square/in-app-payments-flutter-plugin/tree/master
[Getting started with the example app]: https://github.com/square/in-app-payments-flutter-plugin/tree/master/example/README.md
[Quick start flutter app]: https://github.com/square/in-app-payments-flutter-plugin/tree/master/example
[Override the Native In-App Payments SDK Dependency Version]: https://github.com/square/in-app-payments-flutter-plugin/blob/master/doc/versioning.md
