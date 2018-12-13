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
