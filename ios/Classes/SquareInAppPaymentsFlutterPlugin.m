#import "SquareInAppPaymentsFlutterPlugin.h"
#import "SQIPFlutterCardEntry.h"
#import "SQIPFlutterApplePay.h"

@interface SquareInAppPaymentsFlutterPlugin()

@property (strong, readwrite) SQIPFlutterCardEntry* cardEntryModule;
@property (strong, readwrite) SQIPFlutterApplePay* applePayModule;
@end

FlutterMethodChannel* _channel;

@implementation SquareInAppPaymentsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"square_mobile_commerce_sdk"
            binaryMessenger:[registrar messenger]];
    _channel = channel;
    SquareInAppPaymentsFlutterPlugin* instance = [[SquareInAppPaymentsFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.cardEntryModule = [[SQIPFlutterCardEntry alloc] init];
    [self.cardEntryModule initWithMethodChannel:_channel];
    self.applePayModule = [[SQIPFlutterApplePay alloc] init];
    [self.applePayModule initWithMethodChannel:_channel];
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    } else if ([@"setApplicationId" isEqualToString:call.method]) {
        NSString* applicationId = call.arguments[@"applicationId"];
        SQIPInAppPaymentsSDK.squareApplicationID = applicationId;
        result(nil);
    } else if ([@"startCardEntryFlow" isEqualToString:call.method]) {
        [self.cardEntryModule startCardEntryFlow:result];
    } else if ([@"completeCardEntry" isEqualToString:call.method]) {
        [self.cardEntryModule completeCardEntry:result];
    } else if ([@"showCardProcessingError" isEqualToString:call.method]) {
        [self.cardEntryModule showCardProcessingError:result errorMessage:call.arguments[@"errorMessage"]];
    } else if ([@"initializeApplePay" isEqualToString:call.method]) {
        [self.applePayModule initializeApplePay:result merchantId:call.arguments[@"merchantId"]];
    } else if ([@"canUseApplePay" isEqualToString:call.method]) {
        [self.applePayModule canUseApplePay:result];
    } else if ([@"requestApplePayNonce" isEqualToString:call.method]) {
        NSString *countryCode = call.arguments[@"countryCode"];
        NSString *currencyCode = call.arguments[@"currencyCode"];
        NSString *summaryLabel = call.arguments[@"summaryLabel"];
        NSString *price = call.arguments[@"price"];
        [self.applePayModule requestApplePayNonce:result
                                      countryCode:countryCode
                                     currencyCode:currencyCode
                                     summaryLabel:summaryLabel
                                            price:price];
    } else if ([@"completeApplePayAuthorization" isEqualToString:call.method]) {
        Boolean isSuccess = [call.arguments[@"isSuccess"] boolValue];
        NSString *errorMessage = call.arguments[@"errorMessage"];
        [self.applePayModule completeApplePayAuthorization:result isSuccess:isSuccess errorMessage:errorMessage];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
