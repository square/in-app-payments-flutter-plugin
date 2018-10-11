#import "SquareMobileCommerceSdkFlutterPlugin.h"

@implementation SquareMobileCommerceSdkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"square_mobile_commerce_sdk_flutter_plugin"
            binaryMessenger:[registrar messenger]];
  SquareMobileCommerceSdkFlutterPlugin* instance = [[SquareMobileCommerceSdkFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"initialize" isEqualToString:call.method]) {
      NSString* applicationId = call.arguments[@"applicationId"];
      [SQMCMobileCommerceSDK initializeWithApplicationID:applicationId];
      result(nil);
  } else if ([@"startCardEntryFlow" isEqualToString:call.method]) {
    SQMCCardEntryViewController *cardEntryForm = [self _makeCardEntryForm];
    cardEntryForm.delegate = self;

    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
      [((UINavigationController*)rootViewController) pushViewController:cardEntryForm animated:YES];
    } else {
      UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cardEntryForm];
      [rootViewController presentViewController:navigationController animated:YES completion:nil];
    }

    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"payWithEWallet" isEqualToString:call.method]) {
    if (!SQMCMobileCommerceSDK.canUseApplePay) {
      result(@"NO apple pay support");
    }
    PKPaymentRequest *paymentRequest =
    [PKPaymentRequest squarePaymentRequestWithMerchantIdentifier:@"merchant.com.mcomm.flutter"
                                                   countryCode: @"US"   // E.g., US
                                                  currencyCode: @"USD" // E.g., USD
    ];

    paymentRequest.paymentSummaryItems = @[
                                         [PKPaymentSummaryItem summaryItemWithLabel:@"Xiao Test Pay"
                                                                             amount: [NSDecimalNumber one]]
                                         ];

    PKPaymentAuthorizationViewController *paymentAuthorizationViewController =
    [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];

    paymentAuthorizationViewController.delegate = self;

    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    [rootViewController presentViewController:paymentAuthorizationViewController animated:YES completion:nil];
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (SQMCCardEntryViewController *)_makeCardEntryForm;
{
    SQMCTheme *theme = [[SQMCTheme alloc] init];
    theme.errorColor = UIColor.redColor;
    
    return [[SQMCCardEntryViewController alloc] initWithTheme:theme];
}

#pragma mark - SQMCCardEntryViewControllerDelegate
- (void)cardEntryViewControllerDidCancel:(nonnull SQMCCardEntryViewController *)cardEntryViewController;
{
    // Note: If you pushed the card entry form onto an existing navigation controller,
    // use [self.navigationController popViewControllerAnimated:YES] instead
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
    } else {
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
//    [rootViewController dismissViewControllerAnimated:YES completion:nil];
//    [rootViewController.navigationController popViewControllerAnimated:YES];
}

- (void)cardEntryViewController:(nonnull SQMCCardEntryViewController *)cardEntryViewController didSucceedWithResult:(nonnull SQMCCardEntryResult *)result;
{
    NSLog(@"%@", result.nonce); // Card Nonce
    NSLog(@"%@", result.card);  // Card Details
    
    // TODO: Handle card entry success
    
    // Note: If you pushed the card entry form onto an existing navigation controller,
    // use [self.navigationController popViewControllerAnimated:YES] instead
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
    } else {
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
//    [rootViewController dismissViewControllerAnimated:YES completion:nil];
//    [rootViewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment handler:(void (^)(PKPaymentAuthorizationResult * _Nonnull))completion API_AVAILABLE(ios(11.0));
{
    // TODO: Add payment->nonce exchange logic. See Step 5: Exchanging a PKPayment for a Square Nonce
    SQMCApplePayNonceRequest *nonceRequest = [[SQMCApplePayNonceRequest alloc] initWithPayment:payment];
    
    [nonceRequest performWithCompletionHandler:^(SQMCApplePayNonceResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            if (@available(iOS 11.0, *)) {
                PKPaymentAuthorizationResult *errorResult = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusFailure errors:@[error]];
                completion(errorResult);
            } else {
                // Fallback on earlier versions
            }
        } else if (result) {
            NSLog(@"%@", result.nonce); // Card nonce
            NSLog(@"%@", result.card);  // Card details
            
            // TODO: See section on Using the nonce in a Square API request
            
            if (@available(iOS 11.0, *)) {
                PKPaymentAuthorizationResult *successResult = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil];
                completion(successResult);
            } else {
                // Fallback on earlier versions
            }
        }
    }];
}


- (void)paymentAuthorizationViewControllerDidFinish:(nonnull PKPaymentAuthorizationViewController *)controller;
{
    // Note: If you pushed the card entry form onto an existing navigation controller,
    // use [self.navigationController popViewControllerAnimated:YES] instead
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
    } else {
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
//    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
