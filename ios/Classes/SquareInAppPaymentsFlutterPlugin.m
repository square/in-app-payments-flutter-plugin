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


@interface SquareInAppPaymentsFlutterPlugin ()

@property (strong, readwrite) FSQIPCardEntry *cardEntryModule;
@property (strong, readwrite) FSQIPApplePay *applePayModule;
@property (strong, readwrite) FSQIPBuyerVerification *buyerVerificationModule;
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
    self.buyerVerificationModule = [[FSQIPBuyerVerification alloc] init];
    [self.buyerVerificationModule initWithMethodChannel:_channel];
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
    } else if ([@"setBuyerVerificationTheme" isEqualToString:call.method]) {
        NSDictionary *theme = call.arguments[@"theme"];
        [self.buyerVerificationModule setTheme:result theme:theme];
    } else if ([@"startBuyerVerificationFlow" isEqualToString:call.method]) {
        NSString *paymentSourceId = call.arguments[@"paymentSourceId"];
        NSString *buyerActionString = call.arguments[@"buyerAction"];
        NSDictionary *moneyMap = call.arguments[@"money"];
        // XODO: convert currency code
        SQIPMoney *money = [[SQIPMoney alloc] initWithAmount:[moneyMap[@"amount"] longValue] currency:SQRDCurrencyCodeMake(moneyMap[@"currencyCode"])];
        
        SQIPBuyerAction *buyerAction;
        if ([@"Store" isEqualToString:buyerActionString]) {
            buyerAction = [SQIPBuyerAction storeAction];
        } else {
            buyerAction = [SQIPBuyerAction chargeActionWithMoney:money];
        }

        NSString *squareLocationId = call.arguments[@"squareLocationId"];

        NSString *givenName = call.arguments[@"givenName"];
        NSString *familyName = call.arguments[@"familyName"];
        // xodo
        ArrayList<String> addressLines = call.arguments[@"addressLines"];
        NSString *city = call.arguments[@"city"];
        NSString *countryCode = call.arguments[@"countryCode"];
        NSString *email = call.arguments[@"email"];
        NSString *phone = call.arguments[@"phone"];
        NSString *postalCode = call.arguments[@"postalCode"];
        NSString *region = call.arguments[@"region"];

        SQIPContact *contact = [[SQIPContact alloc] initWithGivenName:givenName
                                                    familyName:familyName
                                                    email:email
                                                    addressLines:addressLines
                                                    city:city
                                                    region:region
                                                    postalCode:postalCode
                                                    country:countryCode
                                                    phone:phone];

        SQIPVerificationParameters *params = [[SQIPVerificationParameters alloc] initWithPaymentSourceID:paymentSourceId
                                                    buyerAction:buyerAction
                                                    locationID:squareLocationId
                                                    contact:contact];
        [self.buyerVerificationModule startBuyerVerificationFlow:result parameters:params];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
