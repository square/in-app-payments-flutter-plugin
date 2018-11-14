//
//  Test.m
//  square_mobile_commerce_sdk
//
//  Created by Xiao Hu on 10/17/18.
//

#import "SQIPCardDetails+FlutterMobileCommerceSdkAdditions.h"
#import "SQIPCard+FlutterMobileCommerceSdkAdditions.h"

@implementation SQIPCardDetails (FlutterMobileCommerceSdkAdditions)

- (NSMutableDictionary *)jsonDictionary
{
    NSMutableDictionary *cardEntryResult = [[NSMutableDictionary alloc] init];
    
    cardEntryResult[@"nonce"] = self.nonce;
    cardEntryResult[@"card"] = [self.card jsonDictionary];
    
    return cardEntryResult;
}

@end
