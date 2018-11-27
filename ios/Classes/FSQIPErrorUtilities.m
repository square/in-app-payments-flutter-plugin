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

NSString *const FlutterMobileCommerceUsageError = @"USAGE_ERROR";


@implementation FSQIPErrorUtilities

+ (NSString *)pluginErrorMessageFromErrorCode:(NSString *)pluginErrorCode
{
    return [NSString stringWithFormat:@"Something went wrong. Please contact the developer of this application and provide them with this error code: %@", pluginErrorCode];
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
