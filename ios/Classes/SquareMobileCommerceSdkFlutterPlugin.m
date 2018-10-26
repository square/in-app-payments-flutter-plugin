#import "SquareMobileCommerceSdkFlutterPlugin.h"
#import "FlutterMobileCommerceSdkCardEntry.h"
#import "FlutterMobileCommerceSdkApplePay.h"

@interface SquareMobileCommerceSdkFlutterPlugin()

@property (strong, readwrite) FlutterMobileCommerceSdkCardEntry* cardEntryModule;
@property (strong, readwrite) FlutterMobileCommerceSdkApplePay* applePayModule;
@end

FlutterMethodChannel* _channel;

@implementation SquareMobileCommerceSdkFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"square_mobile_commerce_sdk"
            binaryMessenger:[registrar messenger]];
    _channel = channel;
    SquareMobileCommerceSdkFlutterPlugin* instance = [[SquareMobileCommerceSdkFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)init
{
    self.cardEntryModule = [[FlutterMobileCommerceSdkCardEntry alloc] init];
    [self.cardEntryModule initWithMethodChannel:_channel];
    self.applePayModule = [[FlutterMobileCommerceSdkApplePay alloc] init];
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"setApplicationId" isEqualToString:call.method]) {
        NSString* applicationId = call.arguments[@"applicationId"];
        [SQMCMobileCommerceSDK initializeWithApplicationID:applicationId];
        result(nil);
    } else if ([@"initializeApplePay" isEqualToString:call.method]) {
        [self.applePayModule initializeApplePay:result merchantId:call.arguments[@"merchantId"]];
    } else if ([@"startCardEntryFlow" isEqualToString:call.method]) {
        [self.cardEntryModule startCardEntryFlow:result];
    } else if ([@"closeCardEntryForm" isEqualToString:call.method]) {
        [self.cardEntryModule closeCardEntryForm:result];
    } else if ([@"showCardProcessingError" isEqualToString:call.method]) {
        [self.cardEntryModule showCardProcessingError:result errorMessage:call.arguments[@"errorMessage"]];
    } else if ([@"payWithApplePay" isEqualToString:call.method]) {
        NSString *countryCode = call.arguments[@"countryCode"];
        NSString *currencyCode = call.arguments[@"currencyCode"];
        NSString *summaryLabel = call.arguments[@"summaryLabel"];
        NSString *price = call.arguments[@"price"];
        [self.applePayModule requestApplePayNonce:result
                                      countryCode:countryCode
                                     currencyCode:currencyCode
                                     summaryLabel:summaryLabel
                                            price:price];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
