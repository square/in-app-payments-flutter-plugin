#import <Flutter/Flutter.h>
@import SquareMobileCommerceSDK;

@interface FlutterMobileCommerceSdkCardEntry : NSObject<SQMCCardEntryViewControllerDelegate>

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel;
- (void)startCardEntryFlow:(FlutterResult)result;
- (void)closeCardEntryForm:(FlutterResult)result;
- (void)showCardProcessingError:(FlutterResult)result errorMessage:(NSString *)errorMessage;

@end
