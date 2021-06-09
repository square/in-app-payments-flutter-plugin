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

#import <Flutter/Flutter.h>
@import SquareInAppPaymentsSDK;
@import SquareBuyerVerificationSDK;

@interface FSQIPCardEntry : NSObject <SQIPCardEntryViewControllerDelegate>

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel;
- (void)startCardEntryFlow:(FlutterResult)result collectPostalCode:(BOOL)collectPostalCode;
- (void)startCardEntryFlowWithVerification:(FlutterResult)result collectPostalCode:(BOOL)collectPostalCode locationId:(NSString *)locationId buyerActionString:(NSString *)buyerActionString moneyMap:(NSDictionary *)moneyMap contactMap:(NSDictionary *)contactMap;
- (void)startGiftCardEntryFlow:(FlutterResult)result;
- (void)completeCardEntry:(FlutterResult)result;
- (void)showCardNonceProcessingError:(FlutterResult)result errorMessage:(NSString *)errorMessage;
- (void)setTheme:(FlutterResult)result theme:(NSDictionary *)theme;
- (void)startBuyerVerificationFlow:(FlutterResult)result buyerActionString:(NSString *)buyerActionString moneyMap:(NSDictionary *)moneyMap locationId:(NSString *)locationId contactMap:(NSDictionary *)contactMap paymentSourceId:(NSString *)paymentSourceId;

@end
