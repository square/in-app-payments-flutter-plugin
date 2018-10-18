//
//  Test.m
//  square_mobile_commerce_sdk_flutter_plugin
//
//  Created by Xiao Hu on 10/17/18.
//

#import "SQMCCardEntryResult+FlutterMobileCommerceSdkAdditions.h"
#import "SQMCCard+FlutterMobileCommerceSdkAdditions.h"

@implementation SQMCCardEntryResult (FlutterMobileCommerceSdkAdditions)

- (NSMutableDictionary *)jsonDictionary
{
    NSMutableDictionary *cardEntryResult = [[NSMutableDictionary alloc] init];
    
    cardEntryResult[@"nonce"] = self.nonce;
    cardEntryResult[@"card"] = [self.card jsonDictionary];
    
    return cardEntryResult;
}

@end
