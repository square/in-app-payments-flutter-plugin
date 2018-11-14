//
//  Test.m
//  square_mobile_commerce_sdk
//
//  Created by Xiao Hu on 10/17/18.
//

#import "SQIPCard+FlutterMobileCommerceSdkAdditions.h"

@implementation SQIPCard (FlutterMobileCommerceSdkAdditions)

- (NSMutableDictionary *)jsonDictionary
{
    NSMutableDictionary *card = [[NSMutableDictionary alloc] init];
    
    card[@"lastFourDigits"] = self.lastFourDigits;
    card[@"expirationMonth"] = @(self.expirationMonth);
    card[@"expirationYear"] = @(self.expirationYear);
    card[@"postalCode"] = self.postalCode;
    card[@"brand"] = [self _stringForBrand:self.brand];
    
    return card;
}

#pragma mark - Private Methods
- (NSString *)_stringForBrand:(SQIPCardBrand)brand
{
    NSString *result = nil;
    switch (brand) {
            case SQIPCardBrandVisa:
            result = @"VISA";
            break;
            case SQIPCardBrandMastercard:
            result = @"MASTERCARD";
            break;
            case SQIPCardBrandAmericanExpress:
            result = @"AMERICAN_EXPRESS";
            break;
            case SQIPCardBrandDiscover:
            result = @"DISCOVER";
            break;
            case SQIPCardBrandDiscoverDiners:
            result = @"DISCOVER_DINERS";
            break;
            case SQIPCardBrandJCB:
            result = @"JCB";
            break;
            case SQIPCardBrandChinaUnionPay:
            result = @"CHINA_UNIONPAY";
            break;
            case SQIPCardBrandOtherBrand:
            result = @"OTHER_BRAND";
            break;
    }
    return result;
}

@end
