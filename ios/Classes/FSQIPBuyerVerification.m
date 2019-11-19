/*
 Copyright 2019 Square Inc.
 
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

#import "FSQIPBuyerVerification.h"
#import "FSQIPErrorUtilities.h"
#import "Converters/UIFont+FSQIPAdditions.h"
#import "Converters/UIColor+FSQIPAdditions.h"


@interface FSQIPBuyerVerification ()

@property (strong, readwrite) FlutterMethodChannel *channel;
@property (strong, readwrite) SQIPTheme *theme;

@end

@implementation FSQIPBuyerVerification

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel
{
    self.channel = channel;
    self.theme = [[SQIPTheme alloc] init];
}

- (void)startBuyerVerificationFlow:(FlutterResult)result parameters:(SQIPVerificationParameters *)parameters
{
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;

    // xodo: success and failure handling
    // success invoke onBuyerVerificationSuccess
    // failure invoke onBuyerVerificationError
    [[SQIPBuyerVerificationSDK shared] verifyWithParameters:parameters
                                                    theme:buyerAcself.themetion
                                                    viewController:rootViewController
                                                    success:contact
                                                    failure:failure];

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
