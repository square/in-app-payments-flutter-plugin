# Troubleshooting the In-App Payments SDK Flutter Plugin

Likely causes and solutions for common problems.

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



