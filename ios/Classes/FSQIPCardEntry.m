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

#import "FSQIPCardEntry.h"
#import "FSQIPErrorUtilities.h"
#import "Converters/SQIPCard+FSQIPAdditions.h"
#import "Converters/SQIPCardDetails+FSQIPAdditions.h"
#import "Converters/UIFont+FSQIPAdditions.h"
#import "Converters/UIColor+FSQIPAdditions.h"

typedef void (^CompletionHandler)(NSError *_Nullable);


@interface FSQIPCardEntry ()

@property (strong, readwrite) FlutterMethodChannel *channel;
@property (strong, readwrite) SQIPTheme *theme;
@property (strong, readwrite) CompletionHandler completionHandler;
@property (strong, readwrite) SQIPCardEntryViewController *cardEntryViewController;
@property (strong, readwrite) NSString *locationId;
@property (strong, readwrite) SQIPBuyerAction *buyerAction;
@property (strong, readwrite) SQIPContact *contact;

@end

static NSString *const FSQIPCardEntryCancelEventName = @"cardEntryCancel";
static NSString *const FSQIPCardEntryCompleteEventName = @"cardEntryComplete";
static NSString *const FSQIPCardEntryDidObtainCardDetailsEventName = @"cardEntryDidObtainCardDetails";
static NSString *const FSQIPOnBuyerVerificationSuccessEventName = @"onBuyerVerificationSuccess";
static NSString *const FSQIPOnBuyerVerificationErrorEventName = @"onBuyerVerificationError";

@implementation FSQIPCardEntry

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel
{
    self.channel = channel;
    self.theme = [[SQIPTheme alloc] init];
}

- (void)startCardEntryFlow:(FlutterResult)result collectPostalCode:(BOOL)collectPostalCode
{
    SQIPCardEntryViewController *cardEntryForm = [self _makeCardEntryForm];
    cardEntryForm.collectPostalCode = collectPostalCode;
    cardEntryForm.delegate = self;
    self.cardEntryViewController = cardEntryForm;

    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)rootViewController) pushViewController:cardEntryForm animated:YES];
    } else {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cardEntryForm];
        [rootViewController presentViewController:navigationController animated:YES completion:nil];
    }
    result(nil);
}

- (void)startCardEntryFlowWithVerification:(FlutterResult)result collectPostalCode:(BOOL)collectPostalCode locationId:(NSString *)locationId buyerAction:(SQIPBuyerAction *)buyerAction contact:(SQIPContact *)contact
{
    self.locationId = locationId;
    self.buyerAction = buyerAction;
    self.contact = contact;
    SQIPCardEntryViewController *cardEntryForm = [self _makeCardEntryForm];
    cardEntryForm.collectPostalCode = collectPostalCode;
    cardEntryForm.delegate = self;
    self.cardEntryViewController = cardEntryForm;

    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [((UINavigationController *)rootViewController) pushViewController:cardEntryForm animated:YES];
    } else {
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cardEntryForm];
        [rootViewController presentViewController:navigationController animated:YES completion:nil];
    }
    result(nil);
}

- (void)cardEntryViewController:(SQIPCardEntryViewController *)cardEntryViewController didObtainCardDetails:(SQIPCardDetails *)cardDetails completionHandler:(CompletionHandler)completionHandler
{
    self.completionHandler = completionHandler;

    if (self.contact) {
        NSString *paymentSourceId = cardDetails.nonce;
        SQIPVerificationParameters *params = [[SQIPVerificationParameters alloc] initWithPaymentSourceID:paymentSourceId
                                                buyerAction:self.buyerAction
                                                locationID:self.locationId
                                                contact:self.contact];

        [SQIPBuyerVerificationSDK.shared verifyWithParameters:params
            theme:self.theme
            viewController:self.cardEntryViewController
            success:^(SQIPBuyerVerifiedDetails *_Nonnull verifiedDetails) {
                NSDictionary *verificationResult =
                    @{
                        @"nonce" : cardDetails.nonce,
                        @"card" : [cardDetails.card jsonDictionary],
                        @"token" : verifiedDetails.verificationToken
                    };

                [self.channel invokeMethod:FSQIPOnBuyerVerificationSuccessEventName
                    arguments:verificationResult];
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
        self.contact = nil;
    } else {
        [self.channel invokeMethod:FSQIPCardEntryDidObtainCardDetailsEventName arguments:[cardDetails jsonDictionary]];
    }
}

- (void)cardEntryViewController:(SQIPCardEntryViewController *)cardEntryViewController didCompleteWithStatus:(SQIPCardEntryCompletionStatus)status
{
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
        if (status == SQIPCardEntryCompletionStatusCanceled) {
            [self.channel invokeMethod:FSQIPCardEntryCancelEventName arguments:nil];
        } else {
            [self.channel invokeMethod:FSQIPCardEntryCompleteEventName arguments:nil];
        }
    } else {
        if (status == SQIPCardEntryCompletionStatusCanceled) {
            [rootViewController dismissViewControllerAnimated:YES completion:^{
                [self.channel invokeMethod:FSQIPCardEntryCancelEventName arguments:nil];
            }];
        } else {
            [rootViewController dismissViewControllerAnimated:YES completion:^{
                [self.channel invokeMethod:FSQIPCardEntryCompleteEventName arguments:nil];
            }];
        }
    }
}

- (void)completeCardEntry:(FlutterResult)result
{
    if (self.completionHandler) {
        self.completionHandler(nil);
        self.completionHandler = nil;
    }
    result(nil);
}

- (void)showCardNonceProcessingError:(FlutterResult)result errorMessage:(NSString *)errorMessage
{
    if (self.completionHandler) {
        NSDictionary *userInfo = @{
            NSLocalizedDescriptionKey : errorMessage
        };
        NSError *error = [NSError errorWithDomain:NSGlobalDomain
                                             code:FSQIPCardEntryErrorCode
                                         userInfo:userInfo];
        self.completionHandler(error);
    }
    result(nil);
}

- (void)setTheme:(FlutterResult)result theme:(NSDictionary *)theme
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

    result(nil);
}

#pragma mark - Private Methods
- (SQIPCardEntryViewController *)_makeCardEntryForm
{
    return [[SQIPCardEntryViewController alloc] initWithTheme:self.theme];
}

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

@end
