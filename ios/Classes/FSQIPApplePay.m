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
#import "Converters/SQIPCardDetails+FSQIPAdditions.h"
#import "FSQIPBuyerVerification.h"
#import "Converters/SQIPCard+FSQIPAdditions.h"
#import "Converters/SQIPCardDetails+FSQIPAdditions.h"
#import "Converters/UIFont+FSQIPAdditions.h"
#import "Converters/UIColor+FSQIPAdditions.h"

API_AVAILABLE(ios(11.0))
typedef void (^CompletionHandler)(PKPaymentAuthorizationResult *_Nonnull);


API_AVAILABLE(ios(11.0))
@interface FSQIPApplePay ()

@property (strong, readwrite) FlutterMethodChannel *channel;
@property (strong, readwrite) NSString *applePayMerchantId;
@property (strong, readwrite) CompletionHandler completionHandler;
@property (strong, readwrite) SQIPTheme *theme;

@end

static NSString *const FSQIPOnBuyerVerificationSuccessEventName = @"onBuyerVerificationSuccess";
static NSString *const FSQIPOnBuyerVerificationErrorEventName = @"onBuyerVerificationError";

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
    if (!self.applePayMerchantId) {
        result([FlutterError errorWithCode:FlutterInAppPaymentsUsageError
                                   message:[FSQIPErrorUtilities pluginErrorMessageFromErrorCode:FSQIPApplePayNotInitialized]
                                   details:[FSQIPErrorUtilities debugErrorObject:FSQIPApplePayNotInitialized debugMessage:FSQIPMessageApplePayNotInitialized]]);
        return;
    }
    if (!SQIPInAppPaymentsSDK.canUseApplePay) {
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

- (void)requestApplePayNonceWithVerification:(FlutterResult)result
                                   countryCode:(NSString *)countryCode
                                  currencyCode:(NSString *)currencyCode
                                  summaryLabel:(NSString *)summaryLabel
                                         price:(NSString *)price
                                   paymentType:(NSString *)paymentType
                                   squareLocationId:(NSString *)squareLocationId
                                   buyerActionString:(NSString *)buyerActionString
                                   moneyMap:(NSDictionary *)moneyMap
                                   contactMap:(NSDictionary *)contactMap
                                   paymentSourceId:(NSString *)paymentSourceId;
{

    if (!self.applePayMerchantId) {
        result([FlutterError errorWithCode:FlutterInAppPaymentsUsageError
                                   message:[FSQIPErrorUtilities pluginErrorMessageFromErrorCode:FSQIPApplePayNotInitialized]
                                   details:[FSQIPErrorUtilities debugErrorObject:FSQIPApplePayNotInitialized debugMessage:FSQIPMessageApplePayNotInitialized]]);
        return;
    }
    if (!SQIPInAppPaymentsSDK.canUseApplePay) {
        result([FlutterError errorWithCode:FlutterInAppPaymentsUsageError
                                   message:[FSQIPErrorUtilities pluginErrorMessageFromErrorCode:FSQIPApplePayNotSupported]
                                   details:[FSQIPErrorUtilities debugErrorObject:FSQIPApplePayNotSupported debugMessage:FSQIPMessageApplePayNotSupported]]);
        return;
    }

    SQIPMoney * money = [self _getMoney:moneyMap];
    SQIPBuyerAction * buyerAction = [self _getBuyerAction:buyerActionString money:money];
    SQIPContact * contact = [self _getContact:contactMap];

    SQIPVerificationParameters *params = [[SQIPVerificationParameters alloc] initWithPaymentSourceID:paymentSourceId
                                           buyerAction:buyerAction
                                            locationID:squareLocationId
                                               contact:contact];
    
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
    } else {
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
    }

    [SQIPBuyerVerificationSDK.shared verifyWithParameters:params
        theme:self.theme
        viewController:rootViewController
        success:^(SQIPBuyerVerifiedDetails *_Nonnull verifiedDetails) {
            NSDictionary *verificationResult =
                @{
                    @"nonce" : paymentSourceId,
                    @"token" : verifiedDetails.verificationToken
                };
            [self.channel invokeMethod:FSQIPOnBuyerVerificationSuccessEventName
                arguments:verificationResult];

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
        failure:^(NSError *_Nonnull error) {
            NSString *debugCode = error.userInfo[SQIPErrorDebugCodeKey];
            NSString *debugMessage = error.userInfo[SQIPErrorDebugMessageKey];
            [self.channel invokeMethod:FSQIPOnBuyerVerificationErrorEventName
                arguments:[FSQIPErrorUtilities callbackErrorObject:FlutterInAppPaymentsUsageError
                                message:error.localizedDescription
                                debugCode:debugCode
                                debugMessage:debugMessage]];
        }];
    result(nil);
}

- (void)completeApplePayAuthorization:(FlutterResult)result
                            isSuccess:(BOOL)isSuccess
                         errorMessage:(NSString *__nullable)errorMessage
{
    if (self.completionHandler != nil) {
        if (isSuccess) {
            PKPaymentAuthorizationResult *authResult =[[PKPaymentAuthorizationResult alloc] initWithStatus:PKPaymentAuthorizationStatusSuccess errors:nil];
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
            NSString *debugCode = error.userInfo[SQIPErrorDebugCodeKey];
            NSString *debugMessage = error.userInfo[SQIPErrorDebugMessageKey];
            [self.channel invokeMethod:@"onApplePayNonceRequestFailure"
                             arguments:[FSQIPErrorUtilities callbackErrorObject:FlutterInAppPaymentsUsageError
                                                                        message:error.localizedDescription
                                                                      debugCode:debugCode
                                                                   debugMessage:debugMessage]];
        } else {
            // if error is not nil, result must be valid
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


- (void)applyTheme:(NSDictionary *)theme
{
    // Create a new theme with default value
    self.theme = [[SQIPTheme alloc] init];
    if (theme[@"font"]) {
        self.theme.font = [self.theme.font fromJsonDictionary:theme[@"font"]];
    }
    if (theme[@"saveButtonFont"]) {
        self.theme.saveButtonFont = [self.theme.saveButtonFont fromJsonDictionary:theme[@"saveButtonFont"]];
    }
    if (theme[@"backgroundColor"]) {
        self.theme.backgroundColor = [self.theme.backgroundColor fromJsonDictionary:theme[@"backgroundColor"]];
    }
    if (theme[@"foregroundColor"]) {
        self.theme.foregroundColor = [self.theme.foregroundColor fromJsonDictionary:theme[@"foregroundColor"]];
    }
    if (theme[@"textColor"]) {
        self.theme.textColor = [self.theme.textColor fromJsonDictionary:theme[@"textColor"]];
    }
    if (theme[@"placeholderTextColor"]) {
        self.theme.placeholderTextColor = [self.theme.placeholderTextColor fromJsonDictionary:theme[@"placeholderTextColor"]];
    }
    if (theme[@"tintColor"]) {
        self.theme.tintColor = [self.theme.tintColor fromJsonDictionary:theme[@"tintColor"]];
    }
    if (theme[@"messageColor"]) {
        self.theme.messageColor = [self.theme.messageColor fromJsonDictionary:theme[@"messageColor"]];
    }
    if (theme[@"errorColor"]) {
        self.theme.errorColor = [self.theme.errorColor fromJsonDictionary:theme[@"errorColor"]];
    }
    if (theme[@"saveButtonTitle"]) {
        self.theme.saveButtonTitle = theme[@"saveButtonTitle"];
    }
    if (theme[@"saveButtonTextColor"]) {
        self.theme.saveButtonTextColor = [self.theme.saveButtonTextColor fromJsonDictionary:theme[@"saveButtonTextColor"]];
    }
    if (theme[@"keyboardAppearance"]) {
        self.theme.keyboardAppearance = [self _keyboardAppearanceFromString:theme[@"keyboardAppearance"]];
    }
}

#pragma mark - Private Methods
- (UIKeyboardAppearance)_keyboardAppearanceFromString:(NSString *)keyboardTypeName
{
    if ([keyboardTypeName isEqualToString:@"Dark"]) {
        return UIKeyboardAppearanceDark;
    } else if ([keyboardTypeName isEqualToString:@"Light"]) {
        return UIKeyboardAppearanceLight;
    } else {
        return UIKeyboardAppearanceDefault;
    }
}

- (SQIPMoney *)_getMoney:(NSDictionary *)moneyMap {
    SQIPMoney *money = [[SQIPMoney alloc] initWithAmount:[moneyMap[@"amount"] longValue]
                                                currency:[FSQIPBuyerVerification currencyForCurrencyCode:moneyMap[@"currencyCode"]]];
    return money;
}

- (SQIPBuyerAction *)_getBuyerAction:(NSString *)buyerActionString money:(SQIPMoney *)money {
    SQIPBuyerAction *buyerAction = nil;
    if ([@"Store" isEqualToString:buyerActionString]) {
        buyerAction = [SQIPBuyerAction storeAction];
    } else {
        buyerAction = [SQIPBuyerAction chargeActionWithMoney:money];
    }
    return buyerAction;
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
        NSLog(@"%@", addressLines);
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
