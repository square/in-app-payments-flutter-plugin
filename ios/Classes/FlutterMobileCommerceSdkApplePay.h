#import <Flutter/Flutter.h>
@import SquareMobileCommerceSDK;

@interface FlutterMobileCommerceSdkApplePay : NSObject<PKPaymentAuthorizationViewControllerDelegate>

- (void)initializeApplePay:(FlutterResult)result merchantId:(NSString *)merchantId;

- (void)requestApplePayNonce:(FlutterResult)result
                 countryCode:(NSString *)countryCode
                currencyCode:(NSString *)currencyCode
                summaryLabel:(NSString *)summaryLabel
                       price:(NSString *)price;

@end
