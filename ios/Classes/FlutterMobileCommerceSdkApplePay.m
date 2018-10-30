#import "FlutterMobileCommerceSdkApplePay.h"
#import "FlutterMobileCommerceSdkErrorUtilities.h"
#import "Converters/SQMCCard+FlutterMobileCommerceSdkAdditions.h"

API_AVAILABLE(ios(11.0))
typedef void (^CompletionHandler)(PKPaymentAuthorizationResult * _Nonnull);

API_AVAILABLE(ios(11.0))
@interface FlutterMobileCommerceSdkApplePay()

@property (strong, readwrite) FlutterMethodChannel* channel;
@property (strong, readwrite) NSString* applePayMerchantId;
@property (strong, readwrite) SQMCApplePayNonceResult* applePayResult;
@property (strong, readwrite) NSRecursiveLock* applePayResolverLock;
@property (strong, readwrite) CompletionHandler completionHandler;
@property (strong, readwrite) PKPaymentAuthorizationResult* authorizationResult;

@end

// flutter plugin debug error codes
static NSString *const FlutterMobileCommerceSdkNoApplePaySupport = @"fl_mcomm_no_apple_pay_support";

// flutter plugin debug messages
static NSString *const FlutterMobileCommerceSdkMessageNoApplePaySupport = @"Apple pay is not supported on this device. Please check the apple pay availability on the device before use apply pay.";

@implementation FlutterMobileCommerceSdkApplePay

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel
{
    self.channel = channel;
    self.applePayResolverLock = [[NSRecursiveLock alloc] init];
}

- (void)initializeApplePay:(FlutterResult)result merchantId:(NSString *)merchantId
{
    self.applePayMerchantId = merchantId;
    result(nil);
}

- (void)requestApplePayNonce:(FlutterResult)result
                 countryCode:(NSString *)countryCode
                currencyCode:(NSString *)currencyCode
                summaryLabel:(NSString *)summaryLabel
                       price:(NSString *)price
{
    if (!SQMCMobileCommerceSDK.canUseApplePay) {
        result([FlutterError errorWithCode:FlutterMobileCommerceUsageError
                                   message:[FlutterMobileCommerceSdkErrorUtilities pluginErrorMessageFromErrorCode:FlutterMobileCommerceSdkNoApplePaySupport]
                                   details:[FlutterMobileCommerceSdkErrorUtilities debugErrorObject:FlutterMobileCommerceSdkNoApplePaySupport debugMessage:FlutterMobileCommerceSdkMessageNoApplePaySupport]]);
        return;
    }
    PKPaymentRequest *paymentRequest =
    [PKPaymentRequest squarePaymentRequestWithMerchantIdentifier:self.applePayMerchantId
                                                     countryCode: countryCode
                                                    currencyCode: currencyCode
    ];
    
    paymentRequest.paymentSummaryItems = @[
                                           [PKPaymentSummaryItem summaryItemWithLabel:summaryLabel
                                                                               amount: [NSDecimalNumber decimalNumberWithString:price]]
                                           ];
    
    PKPaymentAuthorizationViewController *paymentAuthorizationViewController =
    [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
    
    paymentAuthorizationViewController.delegate = self;
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    [rootViewController presentViewController:paymentAuthorizationViewController animated:YES completion:nil];
    result(nil);
}

- (void)completeApplePayAuthorization:(FlutterResult)result
{
    if (self.completionHandler) {
        self.completionHandler(self.authorizationResult);
    }
    result(nil);
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                   handler:(CompletionHandler)completion API_AVAILABLE(ios(11.0));
{
    SQMCApplePayNonceRequest *nonceRequest = [[SQMCApplePayNonceRequest alloc] initWithPayment:payment];
    
    [nonceRequest performWithCompletionHandler:^(SQMCApplePayNonceResult * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            self.completionHandler = completion;
            self.authorizationResult = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusFailure errors:@[error]];
            NSString *debugCode = error.userInfo[SQMCErrorDebugCodeKey];
            NSString *debugMessage = error.userInfo[SQMCErrorDebugMessageKey];
            [self.channel invokeMethod:@"onApplePayFailed"
                             arguments:[FlutterMobileCommerceSdkErrorUtilities callbackErrorObject:FlutterMobileCommerceUsageError
                                                                                           message:error.localizedDescription
                                                                                         debugCode:debugCode
                                                                                      debugMessage:debugMessage]];
        } else {
            // if error is not nil, result must be valid
            NSMutableDictionary *applePayNoncResult = [[NSMutableDictionary alloc] init];
            applePayNoncResult[@"nonce"] = result.nonce;
            applePayNoncResult[@"card"] = [result.card jsonDictionary];
            self.completionHandler = completion;
            self.authorizationResult = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil];
            [self.channel invokeMethod:@"onApplePayGetNonce" arguments:applePayNoncResult];
        }
    }];
}


- (void)paymentAuthorizationViewControllerDidFinish:(nonnull PKPaymentAuthorizationViewController *)controller;
{
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
    } else {
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
