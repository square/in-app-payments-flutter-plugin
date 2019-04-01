---
name: 🐛 Issue report
about: I hit an error when I tried to use this plugin.
---

### Describe the issue
<!--
  A clear and concise description of what the issue is.

  For example - I'm trying to complete a payment via Apple Pay but my app crashes after processing it with Passcode. I have everything well configured (Merchant ID, capabilities... I also have supported cards in my Wallet) but looks like I'm missing something. Here is the log:
  ```
  2019-01-22 14:28:23.407363+0100 Runner[703:90877] *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[__NSPlaceholderDictionary initWithObjects:forKeys:count:]: attempt to insert nil object from objects[4]'
  *** First throw call stack:
  (0x1b05b3f50 0x1af7b0284 0x1b0529050 0x1b04ad318 0x1b049d848 0x10262acf4 0x10262aea4 0x102629190 0x1040d7bfc 0x1040d79ac 0x105c1ec28 0x105c201c0 0x105c2d9a8 0x1b05422a4 0x1b053cf48 0x1b053c4b8 0x1b27efbe8 0x1de2701b8 0x102522340 0x1afff1050)
  libc++abi.dylib: terminating with uncaught exception of type NSException
  ```
-->

### To Reproduce
<!--
  Steps to reproduce the issue.

  For example - 
  1. Initialize the SDK
  1. Initialize Apple Pay
  1. call `await InAppPayments.requestApplePayNonce(..)` and use a valid credit card to pay

  Here is the piece of code that reproduce the issue.

  ```dart
    // Paste your code here
  ```
-->

### Expected behavior
<!--
  A clear and concise description of what you expected to happen.

  For example - The applepay finish and return me the valid token.
-->


**Environment (please complete the following information):**
<!--
  - platform: [e.g. iOS or Android]
  - OS and version: [e.g. iOS8.1]
  - Plugin version: [e.g. 1.1.1]

  In addition: Run `flutter doctor -v` in your terminal and copy the results here.
-->

### Screenshots
<!-- If applicable, add screenshots to help explain your problem. -->

### Additional context**
<!-- Add any other context about the problem here. -->
