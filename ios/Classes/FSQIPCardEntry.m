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
#import "Converters/SQIPCardDetails+FSQIPAdditions.h"
#import "Converters/UIFont+FSQIPAdditions.h"
#import "Converters/UIColor+FSQIPAdditions.h"

typedef void (^CompletionHandler)(NSError *_Nullable);


@interface FSQIPCardEntry ()

@property (strong, readwrite) FlutterMethodChannel *channel;
@property (strong, readwrite) SQIPTheme *theme;
@property (strong, readwrite) CompletionHandler completionHandler;

@end


@implementation FSQIPCardEntry

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel
{
    self.channel = channel;
    self.theme = [[SQIPTheme alloc] init];
}

- (void)startCardEntryFlow:(FlutterResult)result
{
    SQIPCardEntryViewController *cardEntryForm = [self _makeCardEntryForm];
    cardEntryForm.delegate = self;

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
    [self.channel invokeMethod:@"cardEntryDidObtainCardDetails" arguments:[cardDetails jsonDictionary]];
}

- (void)cardEntryViewController:(SQIPCardEntryViewController *)cardEntryViewController didCompleteWithStatus:(SQIPCardEntryCompletionStatus)status
{
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        [rootViewController.navigationController popViewControllerAnimated:YES];
        if (status == SQIPCardEntryCompletionStatusCanceled) {
            [self.channel invokeMethod:@"cardEntryDidCancel" arguments:nil];
        } else {
            [self.channel invokeMethod:@"cardEntryComplete" arguments:nil];
        }
    } else {
        if (status == SQIPCardEntryCompletionStatusCanceled) {
            [rootViewController dismissViewControllerAnimated:YES completion:^{
                [self.channel invokeMethod:@"cardEntryDidCancel" arguments:nil];
            }];
        } else {
            [rootViewController dismissViewControllerAnimated:YES completion:^{
                [self.channel invokeMethod:@"cardEntryComplete" arguments:nil];
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
            NSLocalizedDescriptionKey : NSLocalizedString(errorMessage, nil)
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
    if (theme[@"emphasisFont"]) {
        self.theme.emphasisFont = [self.theme.emphasisFont fromJsonDictionary:theme[@"emphasisFont"]];
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
