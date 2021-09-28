# Troubleshooting the In-App Payments SDK Flutter Plugin

Likely causes and solutions for common problems.

## I upgraded to Flutter 2.5.0 and I get a linker error on Mac

### The problem

You're using Flutter 2.5.0 on a Mac.  When you run `flutter run`, you hit this error:

```
error: linker command failed with exit code 1 (use -v to see invocation) ld: building for iOS Simulator, but linking in dylib built for iOS
```
Deploying to a physical device is fine though.


### Likely cause

Flutter 2.5.0 introduced M1 support.  The In-App-Payments SDK does not have M1 support and does not allow creating builds that target arm64 simulators, resulting in the error above.

### Solution

Manually change your app settings to exclude arm64 simulator support.  Xcode won't try to build against this architecture so there shouldn't be any errors.

**IMPORTANT NOTE:**
**This solution will only work on intel-based macs.  M1 macs are unsupported by our SDK without any workarounds available**

1.) Add the following to the bottom of your podfile:
```
post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    config.build_settings["ONLY_ACTIVE_ARCH"] = "YES"
  end
end
```

2.) run `pod install`

3.) You should be able to run the In-App-Payments SDK using the latest version of flutter on intel-based macs.

## I get iOS build error "While building module 'SquareInAppPaymentsSDK' imported from ..."

### The problem

In earlier flutter version, the flutter project template is not configured to support importing framework.
The plugin import iOS In-App Payments SDK as framework dependency, so that building the plugin may fail.

### Likely cause

You created a flutter project from template without configuration of framwork support.

### Solution

Add `use_frameworks!` to the `{YOUR_PROJECT}/ios/Podfile`

```yaml
...

target 'Runner' do
  # Prepare symlinks folder. We use symlinks to avoid having Podfile.lock
  # referring to absolute paths on developers' machines.
  use_frameworks! # <--- add line here
  system('rm -rf .symlinks')
  system('mkdir -p .symlinks/plugins')

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



