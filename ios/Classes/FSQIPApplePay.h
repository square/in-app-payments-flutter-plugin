#import <Flutter/Flutter.h>
@import SquareInAppPaymentsSDK;


@interface FSQIPApplePay : NSObject <PKPaymentAuthorizationViewControllerDelegate>

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel;

- (void)initializeApplePay:(FlutterResult)result merchantId:(NSString *)merchantId;

- (void)canUseApplePay:(FlutterResult)result;

- (void)requestApplePayNonce:(FlutterResult)result
                 countryCode:(NSString *)countryCode
                currencyCode:(NSString *)currencyCode
                summaryLabel:(NSString *)summaryLabel
                       price:(NSString *)price;

- (void)completeApplePayAuthorization:(FlutterResult)result
                            isSuccess:(Boolean)isSuccess
                         errorMessage:(NSString *__nullable)errorMessage;

@end
