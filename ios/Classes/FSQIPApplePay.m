#import "FSQIPApplePay.h"
#import "FSQIPErrorUtilities.h"
#import "Converters/SQIPCardDetails+FlutterMobileCommerceSdkAdditions.h"

API_AVAILABLE(ios(11.0))
typedef void (^CompletionHandler)(PKPaymentAuthorizationResult * _Nonnull);

API_AVAILABLE(ios(11.0))
@interface FSQIPApplePay()

@property (strong, readwrite) FlutterMethodChannel* channel;
@property (strong, readwrite) NSString* applePayMerchantId;
@property (strong, readwrite) CompletionHandler completionHandler;
@property (strong, readwrite) PKPaymentAuthorizationResult* authorizationResult;

@end

// flutter plugin debug error codes
static NSString *const FlutterMobileCommerceSdkNoApplePaySupport = @"fl_mcomm_no_apple_pay_support";

// flutter plugin debug messages
static NSString *const FlutterMobileCommerceSdkMessageNoApplePaySupport = @"Apple pay is not supported on this device. Please check the apple pay availability on the device before use apply pay.";

@implementation FSQIPApplePay

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel
{
    self.channel = channel;
}

- (void)initializeApplePay:(FlutterResult)result merchantId:(NSString *)merchantId
{
    self.applePayMerchantId = merchantId;
    result(nil);
}

- (void)canUseApplePay:(FlutterResult)result
{
    result(@(SQIPInAppPaymentsSDK.canUseApplePay));
}

- (void)requestApplePayNonce:(FlutterResult)result
                 countryCode:(NSString *)countryCode
                currencyCode:(NSString *)currencyCode
                summaryLabel:(NSString *)summaryLabel
                       price:(NSString *)price
{
    if (!SQIPInAppPaymentsSDK.canUseApplePay) {
        result([FlutterError errorWithCode:FlutterMobileCommerceUsageError
                                   message:[FSQIPErrorUtilities pluginErrorMessageFromErrorCode:FlutterMobileCommerceSdkNoApplePaySupport]
                                   details:[FSQIPErrorUtilities debugErrorObject:FlutterMobileCommerceSdkNoApplePaySupport debugMessage:FlutterMobileCommerceSdkMessageNoApplePaySupport]]);
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
                            isSuccess:(Boolean)isSuccess
                         errorMessage:(NSString* __nullable)errorMessage
{
    if (self.completionHandler) {
        if (isSuccess || [errorMessage isEqual: @""]) {
            self.completionHandler(self.authorizationResult);
        } else {
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(errorMessage, nil)};
            NSError *error = [NSError errorWithDomain:NSGlobalDomain
                                                 code:-57
                                             userInfo:userInfo];
            PKPaymentAuthorizationResult* authResult = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusFailure errors:@[error]];
            self.completionHandler(authResult);
        }
        self.completionHandler = nil;
    }
    result(nil);
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                   handler:(CompletionHandler)completion API_AVAILABLE(ios(11.0));
{
    SQIPApplePayNonceRequest *nonceRequest = [[SQIPApplePayNonceRequest alloc] initWithPayment:payment];
    
    [nonceRequest performWithCompletionHandler:^(SQIPCardDetails * _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            self.completionHandler = completion;
            self.authorizationResult = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusFailure errors:@[error]];
            NSString *debugCode = error.userInfo[SQIPErrorDebugCodeKey];
            NSString *debugMessage = error.userInfo[SQIPErrorDebugMessageKey];
            [self.channel invokeMethod:@"onApplePayNonceRequestFailure"
                             arguments:[FSQIPErrorUtilities callbackErrorObject:FlutterMobileCommerceUsageError
                                                                                           message:error.localizedDescription
                                                                                         debugCode:debugCode
                                                                                      debugMessage:debugMessage]];
        } else {
            // if error is not nil, result must be valid
            self.completionHandler = completion;
            self.authorizationResult = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil];
            [self.channel invokeMethod:@"onApplePayNonceRequestSuccess" arguments:[result jsonDictionary]];
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
    [self.channel invokeMethod:@"onApplePayComplete" arguments:nil];
}

@end
