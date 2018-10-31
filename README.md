# square_mobile_commerce_sdk

A flutter plugin for Square Mobile Commerce SDK.

## Before you start
* You will need a Square account enabled for payment processing. If you have not
  enabled payment processing on your account (or you are not sure), visit
  [squareup.com/activate].

* As an Alpha user, you need register your application ID with square to be able to take paymeent.
  Please contact us you haven't got one registered.

* For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

* For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).

## Getting Started mComm SDK flutter plugin 

### Step 1: Create a Flutter project

The basic command is:

```bash
flutter create square_mcomm_sdk_example
```

### Step 2: Install mComm SDK plugin

Put the *square_mobile_commerce_sdk* project folder in `flutter` folder. Edit the `pubspec.yaml` in *square_reader_sdk_example* to include :
```yaml
dependencies:
    ...
    square_mobile_commerce_sdk:
        path: ../square_mobile_commerce_sdk
```

### Step 3: Configure mComm SDK for Android

1. Update the Android build target version:
```
android {
    compileSdkVersion 27

    ...

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId "mcomm.flutter.example"
        minSdkVersion 21
        targetSdkVersion 27
        ...
    }

    ...
}
```

### Step 4: Install mComm SDK for iOS

To use the Flutter plugin on iOS devices, you need to install mComm
SDK for iOS so it is available to the flutter plugin as a resource.
The key installation steps are outlined below. 

1. Change to the iOS folder (`ios`) at the root of your Flutter project.
1. Download and configure the latest version of `SquareMobileCommerceSDK.framework` in
   the `ios` folder.
1. Add mComm SDK to your Xcode project:
   * Open the **General** tab for your app target in Xcode.
   * Drag the newly downloaded `SquareMobileCommerceSDK.framework` into the
     **Embedded Binaries** section and click "Finish" in the modal that appears.
1. Add a mComm SDK build phase:
   1. Open the Xcode workspace or project for your application.
   1. In the **Build Phases** tab for your application target, click the **+**
      button (at the top of the pane).
   1. Select **New Run Script Phase**.
   1. Paste the following into the editor panel of the new run script:
      ```
      FRAMEWORKS="${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      "${FRAMEWORKS}/SquareMobileCommerceSDK.framework/setup"
      ```
1. In Xcode, open the **General** tab for your app target and make sure the
   **Deployment Target** is set to **11.0+**.
1. In Xcode, open the **Build Settings** tab for your app target and add **$(PROJECT_DIR)**
   to **Framework Search Paths**.

### Step 5: Using SDK from your app

Please check the **example** app come with the the plugin project folder.

## Quick start example setup 

### Step 1: Run the sample app for iOS

1. Change to the iOS folder (`ios`) at the root of your Flutter project.
1. Download and configure the latest version of `SquareMobileCommerceSDK.framework` in
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

## Enable ApplePay / GooglePay

Please reference to native mCommerce Alpha documents.

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