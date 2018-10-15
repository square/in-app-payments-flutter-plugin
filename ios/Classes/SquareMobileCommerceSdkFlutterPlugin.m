#import "SquareMobileCommerceSdkFlutterPlugin.h"

@interface SquareMobileCommerceSdkFlutterPlugin()

@property (strong, readwrite) FlutterResult cardEntryResolver;
@property (readwrite) BOOL isInitialized;
@property (strong, readwrite) NSString* applePayMerchantId;
@property (strong, readwrite) FlutterResult applePayResolver;
@property (strong, readwrite) SQMCApplePayNonceResult* applePayResult;
@property (strong, readwrite) NSRecursiveLock* applePayResolverLock;
@end

@implementation SquareMobileCommerceSdkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"square_mobile_commerce_sdk_flutter_plugin"
            binaryMessenger:[registrar messenger]];
    SquareMobileCommerceSdkFlutterPlugin* instance = [[SquareMobileCommerceSdkFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)init
{
    self.applePayResolverLock = [[NSRecursiveLock alloc] init];
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"initialize" isEqualToString:call.method]) {
        if (self.isInitialized == YES) {
          result([FlutterError errorWithCode:@"fl_mcomm_dup_initialize" message:nil details:nil]);
          return;
        }
        NSString* applicationId = call.arguments[@"applicationId"];
        [SQMCMobileCommerceSDK initializeWithApplicationID:applicationId];
        result(nil);
    } else if ([@"initializeApplePay" isEqualToString:call.method]) {
        NSString* merchantId = call.arguments[@"merchantId"];
        self.applePayMerchantId = merchantId;
        result(nil);
    } else if ([@"startCardEntryFlow" isEqualToString:call.method]) {
        if (self.cardEntryResolver != nil) {
            result([FlutterError errorWithCode:@"fl_mcomm_dup_card_entry" message:nil details:nil]);
            return;
        }
        SQMCCardEntryViewController *cardEntryForm = [self _makeCardEntryForm];
        cardEntryForm.delegate = self;

        UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
        if ([rootViewController isKindOfClass:[UINavigationController class]]) {
          [((UINavigationController*)rootViewController) pushViewController:cardEntryForm animated:YES];
        } else {
          UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cardEntryForm];
          [rootViewController presentViewController:navigationController animated:YES completion:nil];
        }
        self.cardEntryResolver = result;
    } else if ([@"payWithApplePay" isEqualToString:call.method]) {
        if (!SQMCMobileCommerceSDK.canUseApplePay) {
            result([FlutterError errorWithCode:@"fl_mcomm_no_apple_pay_support" message:nil details:nil]);
            return;
        }
        if (self.applePayResolver != nil) {
            result([FlutterError errorWithCode:@"fl_mcomm_dup_apple_pay" message:nil details:nil]);
            return;
        }
        NSString *countryCode = call.arguments[@"countryCode"];
        NSString *currencyCode = call.arguments[@"currencyCode"];
        NSString *summaryLabel = call.arguments[@"summaryLabel"];
        NSString *price = call.arguments[@"price"];
        PKPaymentRequest *paymentRequest =
        [PKPaymentRequest squarePaymentRequestWithMerchantIdentifier:self.applePayMerchantId
                                                       countryCode: countryCode   // E.g., US
                                                      currencyCode: currencyCode // E.g., USD
        ];

        paymentRequest.paymentSummaryItems = @[
                                             [PKPaymentSummaryItem summaryItemWithLabel:summaryLabel
                                                                                 amount: [NSDecimalNumber decimalNumberWithString:price]]
                                             ];

        PKPaymentAuthorizationViewController *paymentAuthorizationViewController =
        [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];

        paymentAuthorizationViewController.delegate = self;
        self.applePayResolver = result;
        UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
        [rootViewController presentViewController:paymentAuthorizationViewController animated:YES completion:nil];
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
    self.cardEntryResolver([FlutterError errorWithCode:@"fl_mcomm_canceled" message:nil details:nil]);
    self.cardEntryResolver = nil;
    
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
    } else {
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)cardEntryViewController:(nonnull SQMCCardEntryViewController *)cardEntryViewController didSucceedWithResult:(nonnull SQMCCardEntryResult *)result;
{
    NSLog(@"%@", result.nonce); // Card Nonce
    NSLog(@"%@", result.card);  // Card Details
    
    NSMutableDictionary *cardEntryResult = [[NSMutableDictionary alloc] init];
    cardEntryResult[@"nonce"] = result.nonce;
    cardEntryResult[@"card"] = result.card.lastFourDigits;
    self.cardEntryResolver(cardEntryResult);
    self.cardEntryResolver = nil;
    
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
    } else {
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment handler:(void (^)(PKPaymentAuthorizationResult * _Nonnull))completion API_AVAILABLE(ios(11.0));
{
    SQMCApplePayNonceRequest *nonceRequest = [[SQMCApplePayNonceRequest alloc] initWithPayment:payment];

    [nonceRequest performWithCompletionHandler:^(SQMCApplePayNonceResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            [self.applePayResolverLock lock];
            if (self.applePayResolver != nil) {
                self.applePayResolver([FlutterError errorWithCode:@"fl_mcomm_apple_pay_auth_failed" message:error.localizedDescription details:nil]);
                self.applePayResolver = nil;
            }
            [self.applePayResolverLock unlock];
            PKPaymentAuthorizationResult *errorResult = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusFailure errors:@[error]];
            completion(errorResult);
        } else if (result) {
            NSLog(@"%@", result.nonce); // Card nonce
            NSLog(@"%@", result.card);  // Card details
            
            // TODO: See section on Using the nonce in a Square API request
            NSMutableDictionary *cardEntryResult = [[NSMutableDictionary alloc] init];
            cardEntryResult[@"nonce"] = result.nonce;
            cardEntryResult[@"card"] = result.card.lastFourDigits;
            [self.applePayResolverLock lock];
            if (self.applePayResolver != nil) {
                self.applePayResolver(cardEntryResult);
                self.applePayResolver = nil;
            }
            [self.applePayResolverLock unlock];
            PKPaymentAuthorizationResult *successResult = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil];
            completion(successResult);
        }
    }];
}


- (void)paymentAuthorizationViewControllerDidFinish:(nonnull PKPaymentAuthorizationViewController *)controller;
{
    [self.applePayResolverLock lock];
    if (self.applePayResolver != nil) {
        self.applePayResolver([FlutterError errorWithCode:@"fl_mcomm_apple_pay_canceled" message:nil details:nil]);
        self.applePayResolver = nil;
    }
    [self.applePayResolverLock unlock];
    
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
    } else {
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
