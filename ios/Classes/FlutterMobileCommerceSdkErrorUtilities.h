#import <Flutter/Flutter.h>

extern NSString *const FlutterMobileCommerceUsageError;

@interface FlutterMobileCommerceSdkErrorUtilities : NSObject

+ (NSString *)getPluginErrorMessage:(NSString *)pluginErrorCode;
+ (NSDictionary *)getDebugErrorObject:(NSString *)debugCode debugMessage:(NSString *)debugMessage;

@end
