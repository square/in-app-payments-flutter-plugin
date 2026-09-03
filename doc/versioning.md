# Override the Native In-App Payments SDK Dependency Version

The Flutter Plugin for In-App Payments SDK by default loads a specific version of iOS and Android
In-App Payments SDK. 

You can override the default In-App Payments SDK versions by following this guidance.

## iOS

### Swift Package Manager

There is no per-app override. The plugin's Swift package pins the native SDK to the exact version its
Objective-C bridge is built against, so the way to move to a different native SDK version is to move
to a plugin version that ships it.

### CocoaPods

Apps still using the CocoaPods integration can override the version with the `$sqipVersion` variable:

1. Open the `ios/Podfile` file, add the `$sqipVersion` variable and specify your desired version.

    ```ruby
    # Uncomment this line to define a global platform for your project
    platform :ios, '14.0'

    # CocoaPods analytics sends network stats synchronously affecting flutter build latency.
    ENV['COCOAPODS_DISABLE_STATS'] = 'true'

    # specify the version of SquareInAppPaymentsSDK
    $sqipVersion = '1.7.1'
    ```

1. Remove the `ios/Podfile.lock` and build your project again.
    ```bash
    rm ios/Podfile.lock
    flutter run
    ```

## Android

1. Set the `sqipVersion` Gradle property to your desired version. The simplest way is to add it to
   your app's `android/gradle.properties` file:

    ```properties
    sqipVersion=1.7.1
    ```

   The plugin's `android/build.gradle.kts` reads this property and applies it to every Square
   In-App Payments SDK dependency. The Square Maven repository
   (`https://sdk.squareup.com/public/android`) is already declared by the plugin alongside
   `google()` and `mavenCentral()`.

1. Clean the build and build your project again.
    ```bash
    flutter clean
    flutter run
    ```

