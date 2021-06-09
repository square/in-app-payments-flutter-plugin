/*
 Copyright 2018 Square Inc.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*/

#import "SquareInAppPaymentsFlutterPlugin.h"
#import "FSQIPCardEntry.h"
#import "FSQIPApplePay.h"
#import "FSQIPErrorUtilities.h"
#import "FSQIPSecureRemoteCommerce.h"


@interface SquareInAppPaymentsFlutterPlugin ()

@property (strong, readwrite) FSQIPCardEntry *cardEntryModule;
@property (strong, readwrite) FSQIPApplePay *applePayModule;
@property (strong, readwrite) FSQIPSecureRemoteCommerce *secureRemoteCommerceModule;
@end

FlutterMethodChannel *_channel;


@implementation SquareInAppPaymentsFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar
{
    FlutterMethodChannel *channel = [FlutterMethodChannel
        methodChannelWithName:@"square_in_app_payments"
              binaryMessenger:[registrar messenger]];
    _channel = channel;
    SquareInAppPaymentsFlutterPlugin *instance = [[SquareInAppPaymentsFlutterPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.cardEntryModule = [[FSQIPCardEntry alloc] init];
    [self.cardEntryModule initWithMethodChannel:_channel];
    self.applePayModule = [[FSQIPApplePay alloc] init];
    [self.applePayModule initWithMethodChannel:_channel];
    self.secureRemoteCommerceModule = [[FSQIPSecureRemoteCommerce alloc] init];
    [self.secureRemoteCommerceModule initWithMethodChannel:_channel];
    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result
{
    if ([@"setApplicationId" isEqualToString:call.method]) {
        NSString *applicationId = call.arguments[@"applicationId"];
        SQIPInAppPaymentsSDK.squareApplicationID = applicationId;
        result(nil);
    } else if ([@"startCardEntryFlow" isEqualToString:call.method]) {
        BOOL collectPostalCode = [call.arguments[@"collectPostalCode"] boolValue];
        [self.cardEntryModule startCardEntryFlow:result collectPostalCode:collectPostalCode];
    } else if ([@"startGiftCardEntryFlow" isEqualToString:call.method]) {
        [self.cardEntryModule startGiftCardEntryFlow:result];
    } else if ([@"startCardEntryFlowWithBuyerVerification" isEqualToString:call.method]) {
        BOOL collectPostalCode = [call.arguments[@"collectPostalCode"] boolValue];
        NSString *squareLocationId = call.arguments[@"squareLocationId"];
        NSString *buyerActionString = call.arguments[@"buyerAction"];
        NSDictionary *moneyMap = call.arguments[@"money"];
        NSDictionary *contactMap = call.arguments[@"contact"];
        [self.cardEntryModule startCardEntryFlowWithVerification:result
            collectPostalCode:collectPostalCode
            locationId:squareLocationId
            buyerActionString:buyerActionString
            moneyMap:moneyMap
            contactMap:contactMap];
    } else if ([@"completeCardEntry" isEqualToString:call.method]) {
        [self.cardEntryModule completeCardEntry:result];
    } else if ([@"showCardNonceProcessingError" isEqualToString:call.method]) {
        [self.cardEntryModule showCardNonceProcessingError:result errorMessage:call.arguments[@"errorMessage"]];
    } else if ([@"setFormTheme" isEqualToString:call.method]) {
        NSDictionary *theme = call.arguments[@"theme"];
        [self.cardEntryModule setTheme:result theme:theme];
    } else if ([@"initializeApplePay" isEqualToString:call.method]) {
        [self.applePayModule initializeApplePay:result merchantId:call.arguments[@"merchantId"]];
    } else if ([@"canUseApplePay" isEqualToString:call.method]) {
        [self.applePayModule canUseApplePay:result];
    } else if ([@"requestApplePayNonce" isEqualToString:call.method]) {
        NSString *countryCode = call.arguments[@"countryCode"];
        NSString *currencyCode = call.arguments[@"currencyCode"];
        NSString *summaryLabel = call.arguments[@"summaryLabel"];
        NSString *price = call.arguments[@"price"];
        NSString *paymentType = call.arguments[@"paymentType"];
        [self.applePayModule requestApplePayNonce:result
                                      countryCode:countryCode
                                     currencyCode:currencyCode
                                     summaryLabel:summaryLabel
                                            price:price
                                      paymentType:paymentType];
    } else if ([@"completeApplePayAuthorization" isEqualToString:call.method]) {
        BOOL isSuccess = [call.arguments[@"isSuccess"] boolValue];
        NSString *errorMessage = call.arguments[@"errorMessage"];
        [self.applePayModule completeApplePayAuthorization:result isSuccess:isSuccess errorMessage:errorMessage];
    } else if ([@"startBuyerVerificationFlow" isEqualToString:call.method]) {
        NSString *squareLocationId = call.arguments[@"squareLocationId"];
        NSString *buyerActionString = call.arguments[@"buyerAction"];
        NSDictionary *moneyMap = call.arguments[@"money"];
        NSDictionary *contactMap = call.arguments[@"contact"];
        NSString *paymentSourceId = call.arguments[@"paymentSourceId"];
        [self.cardEntryModule startBuyerVerificationFlow:result
                                       buyerActionString:buyerActionString
                                                moneyMap:moneyMap
                                              locationId:squareLocationId
                                              contactMap:contactMap
                                         paymentSourceId:paymentSourceId];
    } else if ([@"startSecureRemoteCommerce" isEqualToString:call.method]) {
        NSNumber *amount = call.arguments[@"amount"];
        [self.secureRemoteCommerceModule startSecureRemoteCommerce:result
                                                            amount:amount.integerValue];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
