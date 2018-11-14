#import <Flutter/Flutter.h>

extern NSString *const FlutterMobileCommerceUsageError;

@interface SQIPFlutterErrorUtilities : NSObject

+ (NSString *)pluginErrorMessageFromErrorCode:(NSString *)pluginErrorCode;
+ (NSDictionary *)debugErrorObject:(NSString *)debugCode debugMessage:(NSString *)debugMessage;
+ (NSDictionary *)callbackErrorObject:(NSString *)code message:(NSString *)message debugCode:(NSString *)debugCode debugMessage:(NSString *)debugMessage;

@end
