//
//  Test.m
//  square_mobile_commerce_sdk
//
//  Created by Xiao Hu on 10/17/18.
//

#import "SQMCApplePayNonceResult+FlutterMobileCommerceSdkAdditions.h"
#import "SQMCCard+FlutterMobileCommerceSdkAdditions.h"

@implementation SQMCApplePayNonceResult (FlutterMobileCommerceSdkAdditions)

- (NSMutableDictionary *)jsonDictionary
{
    NSMutableDictionary *applePayNonceResult = [[NSMutableDictionary alloc] init];
    
    applePayNonceResult[@"nonce"] = self.nonce;
    applePayNonceResult[@"card"] = [self.card jsonDictionary];
    
    return applePayNonceResult;
}

@end
