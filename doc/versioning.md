# Override the Native In-App Payments SDK Dependency Version

The Flutter Plugin for In-App Payments SDK by default loads a specific version of iOS and Android
In-App Payments SDK. 

You can override the default In-App Payments SDK versions by following this guidance.

## iOS

The iOS integration uses Swift Package Manager. The native In-App Payments SDK version is pinned
in the plugin's Swift package manifest at `ios/square_in_app_payments/Package.swift`:

```swift
.package(url: "https://github.com/square/in-app-payments-ios", exact: "1.6.7")
```

1. Change the version in the `exact:` constraint to the one you want. This matches the CocoaPods podspec, which pins `SquareInAppPaymentsSDK` / `SquareBuyerVerificationSDK` to a single version.

1. Re-resolve packages and rebuild. Removing the resolved file forces a fresh resolution:
    ```bash
    rm -f example/ios/Runner.xcworkspace/xcshareddata/swiftpm/Package.resolved
    flutter run
    ```

> **Note:** Unlike the previous CocoaPods `$sqipVersion` variable, SPM has no per-app override hook,
> so the version is controlled directly in the plugin's `Package.swift`.

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

