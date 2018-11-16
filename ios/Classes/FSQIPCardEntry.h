#import <Flutter/Flutter.h>
@import SquareInAppPaymentsSDK;

@interface FSQIPCardEntry : NSObject<SQIPCardEntryViewControllerDelegate>

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel;
- (void)startCardEntryFlow:(FlutterResult)result;
- (void)completeCardEntry:(FlutterResult)result;
- (void)showCardNonceProcessingError:(FlutterResult)result errorMessage:(NSString *)errorMessage;
- (void)setTheme:(FlutterResult)result themeConfiguration:(NSDictionary *)themeConfiguration;

@end
