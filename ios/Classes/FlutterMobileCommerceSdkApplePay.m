#import "FlutterMobileCommerceSdkApplePay.h"
#import "FlutterMobileCommerceSdkErrorUtilities.h"
#import "Converters/SQMCCardEntryResult+FlutterMobileCommerceSdkAdditions.h"

@interface FlutterMobileCommerceSdkApplePay()

@property (strong, readwrite) NSString* applePayMerchantId;
@property (strong, readwrite) FlutterResult applePayResolver;
@property (strong, readwrite) SQMCApplePayNonceResult* applePayResult;
@property (strong, readwrite) NSRecursiveLock* applePayResolverLock;

@end

// Define all the error codes and messages below
// These error codes and messages **MUST** align with iOS error codes and dart error codes
// Search KEEP_IN_SYNC_CHECKOUT_ERROR to update all places

// flutter plugin expected errors
static NSString *const FlutterMobileCommerceCardEntryCanceled = @"fl_card_entry_canceled";

// flutter plugin debug error codes
static NSString *const FlutterMobileCommerceCardEntryAlreadyInProgress = @"fl_card_entry_already_in_progress";

// flutter plugin debug messages
static NSString *const FlutterMobileCommerceMessageCardEntryAlreadyInProgress = @"A card entry flow is already in progress. Ensure that the in-progress card entry flow is completed before calling startCardEntryFlow again.";
static NSString *const FlutterMobileCommerceMessageCardEntryCanceled = @"The card entry flow is canceled";

@implementation FlutterMobileCommerceSdkApplePay

- (instancetype)init
{
    self.applePayResolverLock = [[NSRecursiveLock alloc] init];
    return self;
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
        result([FlutterError errorWithCode:@"fl_mcomm_no_apple_pay_support" message:nil details:nil]);
        return;
    }
    if (self.applePayResolver != nil) {
        result([FlutterError errorWithCode:@"fl_mcomm_dup_apple_pay" message:nil details:nil]);
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
    self.applePayResolver = result;
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    [rootViewController presentViewController:paymentAuthorizationViewController animated:YES completion:nil];
}

- (void)closeCardEntryForm
{
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
    } else {
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setFormTheme:(FlutterResult)result themeParameters:(NSDictionary *)themeParameters
{
    result(FlutterMethodNotImplemented);
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
