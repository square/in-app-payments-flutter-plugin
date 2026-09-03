# Troubleshooting the In-App Payments SDK Flutter Plugin

Likely causes and solutions for common problems.

## I upgraded to Flutter 2.5.0 and I get a linker error on Mac

### The problem

You're using Flutter 2.5.0 on a Mac. When you run `flutter run`, you hit this error:

```
error: linker command failed with exit code 1 (use -v to see invocation) ld: building for iOS Simulator, but linking in dylib built for iOS
```

Deploying to a physical device is fine though.

### Likely cause

Flutter 2.5.0 introduced M1 support. The In-App-Payments SDK does not have M1 support and does not allow creating builds that target arm64 simulators, resulting in the error above.

### Solution

Manually change your app settings to exclude arm64 simulator support. Xcode won't try to build against this architecture so there shouldn't be any errors.

**IMPORTANT NOTE:**
**This solution will only work on intel-based macs. M1 macs are unsupported by our SDK without any workarounds available**

The iOS integration now uses Swift Package Manager, so there is no `Podfile`. Set the excluded
architectures directly on the Runner target in Xcode instead:

1.) Open `example/ios/Runner.xcworkspace` (or your app's workspace) in Xcode.

2.) Select the **Runner** target, open **Build Settings**, and add `arm64` to
**Excluded Architectures** for **Any iOS Simulator SDK**
(`EXCLUDED_ARCHS[sdk=iphonesimulator*] = arm64`).

3.) Rebuild with `flutter run`. You should be able to run on intel-based macs.

## I get iOS build error "While building module 'SquareInAppPaymentsSDK' imported from ..."

### The problem

In earlier flutter version, the flutter project template is not configured to support importing framework.
The plugin import iOS In-App Payments SDK as framework dependency, so that building the plugin may fail.

### Likely cause

You created a flutter project from template without configuration of framwork support.

### Solution

With Swift Package Manager there is no `Podfile`, and framework support is handled automatically,
so no manual configuration is required. If your app still uses the legacy CocoaPods integration,
add `use_frameworks!` to the `{YOUR_PROJECT}/ios/Podfile`:

```ruby
target 'Runner' do
  use_frameworks! # <--- add line here
  ...
end
```

## I get proguard.ParseException: Use of generics not allowed for java type at '<1>_<2>_<3>JsonAdapter

### The Problem

This is a problem related to proguard and removing R8 due to it obfuscating classes our SDKS need for proper functioning. More information in: https://github.com/square/moshi/issues/738.

### Solution

There are a few solutions you can use:

1. Update to a version of proguard > 6.1.0-beta2 (https://sourceforge.net/p/proguard/bugs/731/)
2. Add `android.proguard.enableRulesExtraction=false` in your android/gradle.properties file like found in the example app.
