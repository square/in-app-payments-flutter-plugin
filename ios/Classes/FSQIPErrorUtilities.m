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

#import "FSQIPErrorUtilities.h"

NSString *const FlutterInAppPaymentsUsageError = @"USAGE_ERROR";
NSInteger const FSQIPCardEntryErrorCode = 0;
NSInteger const FSQIPApplePayErrorCode = 1;


@implementation FSQIPErrorUtilities

+ (NSString *)pluginErrorMessageFromErrorCode:(NSString *)pluginErrorCode
{
    NSString *bundlePath = [[NSBundle bundleForClass:FSQIPErrorUtilities.self] pathForResource:@"sqip_flutter_resource" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSString *localizedErrorMessage = NSLocalizedStringWithDefaultValue(@"SQIPUnexpectedErrorMessage", nil, bundle, @"Something went wrong. Please contact the developer of this application and provide them with this error code: %@", @"Error message shown when an unexpected error occurs");

    return [NSString stringWithFormat:localizedErrorMessage, pluginErrorCode];
}

+ (NSDictionary *)debugErrorObject:(NSString *)debugCode debugMessage:(NSString *)debugMessage
{
    return @{
        @"debugCode" : debugCode,
        @"debugMessage" : debugMessage,
    };
}

+ (NSDictionary *)callbackErrorObject:(NSString *)code message:(NSString *)message debugCode:(NSString *)debugCode debugMessage:(NSString *)debugMessage
{
    return @{
        @"code" : code,
        @"message" : message,
        @"debugCode" : debugCode,
        @"debugMessage" : debugMessage,
    };
}

@end
