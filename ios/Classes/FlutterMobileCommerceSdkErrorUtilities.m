#import "FlutterMobileCommerceSdkErrorUtilities.h"

// Usage error
NSString *const FlutterMobileCommerceUsageError = @"USAGE_ERROR";

@implementation FlutterMobileCommerceSdkErrorUtilities

+ (NSString *)pluginErrorMessageFromErrorCode:(NSString *)pluginErrorCode
{
    return [NSString stringWithFormat:@"Something went wrong. Please contact the developer of this application and provide them with this error code: %@", pluginErrorCode];
}

+ (NSDictionary *)debugErrorObject:(NSString *)debugCode debugMessage:(NSString *)debugMessage
{
    NSMutableDictionary *errorObject = [[NSMutableDictionary alloc] init];
    errorObject[@"debugCode"] = debugCode;
    errorObject[@"debugMessage"] = debugMessage;
    return errorObject;
}

@end
