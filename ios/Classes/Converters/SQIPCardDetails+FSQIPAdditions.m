//
//  Test.m
//  square_in_app_payments
//
//  Created by Xiao Hu on 10/17/18.
//

#import "SQIPCardDetails+FSQIPAdditions.h"
#import "SQIPCard+FSQIPAdditions.h"


@implementation SQIPCardDetails (FSQIPAdditions)

- (NSMutableDictionary *)jsonDictionary
{
    NSMutableDictionary *cardEntryResult = [[NSMutableDictionary alloc] init];

    cardEntryResult[@"nonce"] = self.nonce;
    cardEntryResult[@"card"] = [self.card jsonDictionary];

    return cardEntryResult;
}

@end
