## Changelog

### v1.7.0 March 31, 2021

* Added support for null safety in Flutter 2. Many files were changed to support this, and there may be some changes required from the developer to support.

### v1.6.0 March 26, 2021

* Added a new flow called [startBuyerVerificationFlow](doc/reference.md#startbuyerverificationflow) to support Strong Customer Authentication with a card-on-file card ID

### v1.5.0 July 9, 2020

* Updated to IAP SDK 1.4.0.
* Added support for gift card payments.
* Disable R8 in exchange for proguard.

### v1.4.0 June 25, 2020

* Added support for v2 flutter embeddings (flutter 1.12+).

### v1.3.0 November 20, 2019

* Bump Square In-App Payments SDK dependency to `1.3.0`.
* Add support for Strong Customer Authentication (SCA).

### v1.2.3 September 10, 2019

* Bump Square In-App Payments SDK dependency to `1.2.0`.
* Add support for Sandbox v2.

### v1.2.2 July 23, 2019

* Fixed an exception introduced in a recent Flutter update.

### v1.2.1 June 5, 2019

* Added `paymentType` parameter to support apple pay pending amount configuration.

### v1.1.1 Mar 29, 2019

* Bump Square In-App Payments iOS SDK dependency to `1.1.1`.
* Enable iOS and android In-App Payments SDK version override.
* Fix #35 - support AndroidX release build

### v1.1.0 Feb 27, 2019

* Support Square In-App Payments iOS and Android SDK `1.1.0`.
* For SDK 1.1.0 change, please check this [Change Log](https://docs.connect.squareup.com/changelog/mobile-logs/2019-02-27).

### v1.0.3 Feb 14, 2019

* Compatible to AndroidX migration.
* `CardEntryDidCancelCallback` is renamed to `CardEntryCancelCallback`.
* Some updates to improve error messages.
* Minor code style improvements.

### v1.0.2 Jan 22, 2019

* Fix Apple Pay issue [#18](https://github.com/square/in-app-payments-flutter-plugin/issues/18#issue-401770301).
* Refine Apple Pay quick start example.

### v1.0.1 Jan 9, 2019

* Initial release.
