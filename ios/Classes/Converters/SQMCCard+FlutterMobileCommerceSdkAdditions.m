//
//  Test.m
//  square_mobile_commerce_sdk_flutter_plugin
//
//  Created by Xiao Hu on 10/17/18.
//

#import "SQMCCard+FlutterMobileCommerceSdkAdditions.h"

@implementation SQMCCard (FlutterMobileCommerceSdkAdditions)

- (NSMutableDictionary *)jsonDictionary
{
    NSMutableDictionary *card = [[NSMutableDictionary alloc] init];
    
    card[@"lastFourDigits"] = self.lastFourDigits;
    card[@"expirationMonth"] = @(self.expirationMonth);
    card[@"expirationYear"] = @(self.expirationYear);
    card[@"postalCode"] = self.postalCode;
    card[@"brand"] = [self getBrandString:self.brand];
    
    return card;
}

- (NSString *)getBrandString:(SQMCCardBrand)brand
{
    NSString *result = nil;
    switch (brand) {
            case SQMCCardBrandVisa:
            result = @"VISA";
            break;
            case SQMCCardBrandMastercard:
            result = @"MASTERCARD";
            break;
            case SQMCCardBrandAmericanExpress:
            result = @"AMERICAN_EXPRESS";
            break;
            case SQMCCardBrandDiscover:
            result = @"DISCOVER";
            break;
            case SQMCCardBrandDiscoverDiners:
            result = @"DISCOVER_DINERS";
            break;
            case SQMCCardBrandJCB:
            result = @"JCB";
            break;
            case SQMCCardBrandChinaUnionPay:
            result = @"CHINA_UNIONPAY";
            break;
            case SQMCCardBrandOther:
            result = @"OTHER_BRAND";
            break;
    }
    return result;
}

@end
