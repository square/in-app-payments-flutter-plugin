# Override the Native In-App Payments SDK Dependency Version

The Flutter Plugin for In-App Payments SDK by default loads a specific version of iOS and Android
In-App Payments SDK. 

You can override the default In-App Payments SDK versions by following this guidance.

## iOS

1. Open the `ios/Podfile` file, add the `$sqipVersion` variable and specify your desired version.

    ```ruby
    # Uncomment this line to define a global platform for your project
    platform :ios, '11.0'

    # CocoaPods analytics sends network stats synchronously affecting flutter build latency.
    ENV['COCOAPODS_DISABLE_STATS'] = 'true'

    # specify the version of SquareInAppPaymentsSDK
    $sqipVersion = '1.1.1'
    ```

1. Remove the `ios/Podfile.lock` and build your project again.
    ```bash
    rm ios/Podfile.lock
    flutter run
    ```

## Android

1. Open the `android/build.gradle` file, add the `sqipVersion` variable and specify your desired version.
    ```gradle
    allprojects {
        repositories {
            google()
            jcenter()
        }
    }

    // add the override here
    ext {
        sqipVersion = '1.1.0'
    }
    ```

1. Clean the build and build your project again.
    ```bash
    flutter clean
    flutter run
    ```

