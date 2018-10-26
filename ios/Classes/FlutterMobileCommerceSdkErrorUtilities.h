#import <Flutter/Flutter.h>

extern NSString *const FlutterMobileCommerceUsageError;

@interface FlutterMobileCommerceSdkErrorUtilities : NSObject

+ (NSString *)pluginErrorMessageFromErrorCode:(NSString *)pluginErrorCode;
+ (NSDictionary *)debugErrorObject:(NSString *)debugCode debugMessage:(NSString *)debugMessage;

@end
