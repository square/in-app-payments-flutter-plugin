#import <Flutter/Flutter.h>
@import SquareMobileCommerceSDK;

@interface FlutterMobileCommerceSdkCardEntry : NSObject<SQMCCardEntryViewControllerDelegate>

- (void)startCardEntryFlow:(FlutterResult)result;

@end
