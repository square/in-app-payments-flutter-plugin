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

#import "FSQIPErrorUtilities.h"
#import "FSQIPSecureRemoteCommerce.h"
#import "Converters/SQIPCardDetails+FSQIPAdditions.h"

@interface FSQIPSecureRemoteCommerce ()

@property (strong, readwrite) FlutterMethodChannel *channel;

@end

static NSString *const FSQIPOnMaterCardNonceRequestSuccessEventName = @"onMaterCardNonceRequestSuccess";
static NSString *const FSQIPOnMasterCardNonceRequestFailureEventName = @"onMasterCardNonceRequestFailure";

@implementation FSQIPSecureRemoteCommerce

- (void)initWithMethodChannel:(FlutterMethodChannel *)channel{
    self.channel = channel;
}

- (void)startSecureRemoteCommerce:(FlutterResult)result amount:(NSString *)amount{
    UIViewController *rootViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    
    SQIPSecureRemoteCommerceParameters params;
    params.amount = [amount intValue];
    
    [[SQIPSecureRemoteCommerce alloc]
     createPaymentRequest: rootViewController
     secureRemoteCommerceParameters: params
     completionHandler:^(SQIPCardDetails * _Nullable cardDetails, NSError * _Nullable error) {
        if(cardDetails != NULL){
            [self.channel invokeMethod:FSQIPOnMaterCardNonceRequestSuccessEventName arguments:[cardDetails jsonDictionary]];
        }else if (error != NULL){
            NSString *debugCode = error.userInfo[SQIPErrorDebugCodeKey];
            NSString *debugMessage = error.userInfo[SQIPErrorDebugMessageKey];
            [self.channel invokeMethod:FSQIPOnMasterCardNonceRequestFailureEventName
                             arguments:[FSQIPErrorUtilities callbackErrorObject:FlutterInAppPaymentsUsageError
                                                                        message:error.localizedDescription
                                                                      debugCode:debugCode
                                                                   debugMessage:debugMessage]];
        }
    }];
    result(nil);
}

@end
