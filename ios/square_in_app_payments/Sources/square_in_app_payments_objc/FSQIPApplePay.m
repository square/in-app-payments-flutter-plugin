/*
 Copyright 2018 Square Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

#import "FSQIPApplePay.h"
#import "FSQIPErrorUtilities.h"
#import "FSQIPBuyerVerification.h"
#import "Converters/SQIPCard+FSQIPAdditions.h"
#import "Converters/SQIPCardDetails+FSQIPAdditions.h"

API_AVAILABLE(ios(11.0))
typedef void (^CompletionHandler)(PKPaymentAuthorizationResult *_Nonnull);


API_AVAILABLE(ios(11.0))
@interface FSQIPApplePay ()

@property (strong, readwrite) FlutterMethodChannel *channel;
@property (strong, readwrite) NSString *applePayMerchantId;
@property (strong, readwrite) CompletionHandler completionHandler;
@property (strong, readwrite) SQIPTheme *theme;
@property (strong, readwrite) NSString *locationId;
@property (strong, readwrite) SQIPBuyerAction *buyerAction;
@property (strong, readwrite) SQIPContact *contact;
@property (strong, readwrite) SQIPCardDetails *cardDetails;

@end

// flutter plugin debug error codes
static NSString *const FSQIPApplePayNotInitialized = @"fl_apple_pay_not_initialized";
static NSString *const FSQIPApplePayNotSupported = @"fl_apple_pay_not_supported";

// flutter plugin debug messages
static NSString *const FSQIPMessageApplePayNotInitialized = @"Apple Pay must be initialized with an Apple merchant ID.";
static NSString *const FSQIPMessageApplePayNotSupported = @"This device does not have any supported Apple Pay cards. Please check `canUseApplePay` prior to requesting a nonce.";


@implementation FSQIPApplePay

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel
{
    self.channel = channel;
    self.theme = [[SQIPTheme alloc] init];
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
                 paymentType:(NSString *)paymentType
{
    self.contact = nil;
    [self _requestApplePayNonce:result
                    countryCode:countryCode
                   currencyCode:currencyCode
                   summaryLabel:summaryLabel
                          price:price
                    paymentType:paymentType];
}

- (void)requestApplePayNonceWithBuyerVerification:(FlutterResult)result
                                      countryCode:(NSString *)countryCode
                                     currencyCode:(NSString *)currencyCode
                                     summaryLabel:(NSString *)summaryLabel
                                            price:(NSString *)price
                                      paymentType:(NSString *)paymentType
                                       locationId:(NSString *)locationId
                                buyerActionString:(NSString *)buyerActionString
                                         moneyMap:(NSDictionary *)moneyMap
                                       contactMap:(NSDictionary *)contactMap
{
    SQIPMoney *money = moneyMap != nil ? [self _getMoney:moneyMap] : nil;
    self.locationId = locationId;
    self.buyerAction = [self _getBuyerAction:buyerActionString money:money];
    self.contact = [self _getContact:contactMap];
    [self _requestApplePayNonce:result
                    countryCode:countryCode
                   currencyCode:currencyCode
                   summaryLabel:summaryLabel
                          price:price
                    paymentType:paymentType];
}

- (void)completeApplePayAuthorization:(FlutterResult)result
                            isSuccess:(BOOL)isSuccess
                         errorMessage:(NSString *__nullable)errorMessage
{
    [self _finishApplePayAuthorization:isSuccess errorMessage:errorMessage];
    result(nil);
}

#pragma mark - PKPaymentAuthorizationViewControllerDelegate
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                   handler:(CompletionHandler)completion API_AVAILABLE(ios(11.0));
{
    SQIPApplePayNonceRequest *nonceRequest = [[SQIPApplePayNonceRequest alloc] initWithPayment:payment];
    self.completionHandler = completion;

    [nonceRequest performWithCompletionHandler:^(SQIPCardDetails *_Nullable result, NSError *_Nullable error) {
        if (error) {
            if (self.contact) {
                [self _finishApplePayAuthorization:NO errorMessage:error.localizedDescription];
                self.contact = nil;
                self.cardDetails = nil;
            }
            NSString *debugCode = error.userInfo[SQIPErrorDebugCodeKey];
            NSString *debugMessage = error.userInfo[SQIPErrorDebugMessageKey];
            [self.channel invokeMethod:@"onApplePayNonceRequestFailure"
                             arguments:[FSQIPErrorUtilities callbackErrorObject:FlutterInAppPaymentsUsageError
                                                                        message:error.localizedDescription
                                                                      debugCode:debugCode
                                                                   debugMessage:debugMessage]];
            return;
        }

        if (self.contact) {
            self.cardDetails = result;
            SQIPVerificationParameters *params = [[SQIPVerificationParameters alloc] initWithPaymentSourceID:result.nonce
                                                                                                 buyerAction:self.buyerAction
                                                                                                  locationID:self.locationId
                                                                                                     contact:self.contact];
            [SQIPBuyerVerificationSDK.shared verifyWithParameters:params
                                                            theme:self.theme
                                                   viewController:controller
                                                          success:^(SQIPBuyerVerifiedDetails *_Nonnull verifiedDetails) {
                NSDictionary *verificationResult =
                    @{
                        @"nonce" : self.cardDetails.nonce,
                        @"card" : [self.cardDetails.card jsonDictionary],
                        @"token" : verifiedDetails.verificationToken
                    };
                [self.channel invokeMethod:@"onBuyerVerificationSuccess" arguments:verificationResult];
                [self _finishApplePayAuthorization:YES errorMessage:nil];
                self.contact = nil;
            }
                                                          failure:^(NSError *_Nonnull verificationError) {
                NSString *debugCode = verificationError.userInfo[SQIPErrorDebugCodeKey];
                NSString *debugMessage = verificationError.userInfo[SQIPErrorDebugMessageKey];
                [self.channel invokeMethod:@"onBuyerVerificationError"
                                 arguments:[FSQIPErrorUtilities callbackErrorObject:FlutterInAppPaymentsUsageError
                                                                            message:verificationError.localizedDescription
                                                                          debugCode:debugCode
                                                                       debugMessage:debugMessage]];
                [self _finishApplePayAuthorization:NO errorMessage:verificationError.localizedDescription];
                self.contact = nil;
            }];
            return;
        }

        [self.channel invokeMethod:@"onApplePayNonceRequestSuccess" arguments:[result jsonDictionary]];
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

#pragma mark - Private Methods

- (void)_requestApplePayNonce:(FlutterResult)result
                  countryCode:(NSString *)countryCode
                 currencyCode:(NSString *)currencyCode
                 summaryLabel:(NSString *)summaryLabel
                        price:(NSString *)price
                  paymentType:(NSString *)paymentType
{
    if (!self.applePayMerchantId) {
        self.contact = nil;
        result([FlutterError errorWithCode:FlutterInAppPaymentsUsageError
                                   message:[FSQIPErrorUtilities pluginErrorMessageFromErrorCode:FSQIPApplePayNotInitialized]
                                   details:[FSQIPErrorUtilities debugErrorObject:FSQIPApplePayNotInitialized debugMessage:FSQIPMessageApplePayNotInitialized]]);
        return;
    }
    if (!SQIPInAppPaymentsSDK.canUseApplePay) {
        self.contact = nil;
        result([FlutterError errorWithCode:FlutterInAppPaymentsUsageError
                                   message:[FSQIPErrorUtilities pluginErrorMessageFromErrorCode:FSQIPApplePayNotSupported]
                                   details:[FSQIPErrorUtilities debugErrorObject:FSQIPApplePayNotSupported debugMessage:FSQIPMessageApplePayNotSupported]]);
        return;
    }
    PKPaymentRequest *paymentRequest =
        [PKPaymentRequest squarePaymentRequestWithMerchantIdentifier:self.applePayMerchantId
                                                         countryCode:countryCode
                                                        currencyCode:currencyCode];
    if ([paymentType isEqual: @"PENDING"]) {
        paymentRequest.paymentSummaryItems = @[
           [PKPaymentSummaryItem summaryItemWithLabel:summaryLabel
                                               amount:[NSDecimalNumber decimalNumberWithString:price]
                                                 type:PKPaymentSummaryItemTypePending]
        ];
    } else {
        paymentRequest.paymentSummaryItems = @[
           [PKPaymentSummaryItem summaryItemWithLabel:summaryLabel
                                               amount:[NSDecimalNumber decimalNumberWithString:price]
                                                 type:PKPaymentSummaryItemTypeFinal]
        ];
    }

    PKPaymentAuthorizationViewController *paymentAuthorizationViewController =
        [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];

    paymentAuthorizationViewController.delegate = self;
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    [rootViewController presentViewController:paymentAuthorizationViewController animated:YES completion:nil];
    result(nil);
}

- (void)_finishApplePayAuthorization:(BOOL)isSuccess errorMessage:(NSString *__nullable)errorMessage
{
    if (self.completionHandler != nil) {
        if (isSuccess) {
            PKPaymentAuthorizationResult *authResult = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil];
            self.completionHandler(authResult);
        } else {
            NSDictionary *userInfo = errorMessage == nil || errorMessage.length == 0 ? nil : @{NSLocalizedDescriptionKey : errorMessage };
            NSError *error = [NSError errorWithDomain:NSGlobalDomain
                                                 code:FSQIPApplePayErrorCode
                                             userInfo:userInfo];
            if (@available(iOS 11.0, *)) {
                PKPaymentAuthorizationResult *authResult = [[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusFailure errors:@[ error ]];
                self.completionHandler(authResult);
            } else {
                // This should never happen as we require target to be 11.0 or above
                NSAssert(false, @"No Apple Pay support for iOS 10 or below.");
            }
        }
        self.completionHandler = nil;
    }
}

- (SQIPMoney *)_getMoney:(NSDictionary *)moneyMap {
    return [[SQIPMoney alloc] initWithAmount:[moneyMap[@"amount"] longValue]
                                    currency:[FSQIPBuyerVerification currencyForCurrencyCode:moneyMap[@"currencyCode"]]];
}

- (SQIPBuyerAction *)_getBuyerAction:(NSString *)buyerActionString money:(SQIPMoney *)money {
    if ([@"Store" isEqualToString:buyerActionString]) {
        return [SQIPBuyerAction storeAction];
    }
    return [SQIPBuyerAction chargeActionWithMoney:money];
}

- (SQIPContact *)_getContact:(NSDictionary *)contactMap {
    NSString *givenName = contactMap[@"givenName"];
    NSString *familyName = contactMap[@"familyName"];
    NSArray<NSString *> *addressLines = contactMap[@"addressLines"];
    NSString *city = contactMap[@"city"];
    NSString *countryCode = contactMap[@"countryCode"];
    NSString *email = contactMap[@"email"];
    NSString *phone = contactMap[@"phone"];
    NSString *postalCode = contactMap[@"postalCode"];
    NSString *region = contactMap[@"region"];

    SQIPContact *contact = [[SQIPContact alloc] init];
    contact.givenName = givenName;

    if (![familyName isEqual:[NSNull null]]) {
        contact.familyName = familyName;
    }
    if (![email isEqual:[NSNull null]]) {
        contact.email = email;
    }
    if (![addressLines isEqual:[NSNull null]]) {
        contact.addressLines = addressLines;
    }
    if (![city isEqual:[NSNull null]]) {
        contact.city = city;
    }
    if (![region isEqual:[NSNull null]]) {
        contact.region = region;
    }
    if (![postalCode isEqual:[NSNull null]]) {
        contact.postalCode = postalCode;
    }
    contact.country = [FSQIPBuyerVerification countryForCountryCode:countryCode];
    if (![phone isEqual:[NSNull null]]) {
        contact.phone = phone;
    }
    return contact;
}

@end
