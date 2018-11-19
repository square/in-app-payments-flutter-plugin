//
//  Test.m
//  square_in_app_payments
//
//  Created by Xiao Hu on 10/17/18.
//

#import "UIFont+FSQIPAdditions.h"


@implementation UIFont (FSQIPAdditions)

- (UIFont *)fromJsonDictionary:(NSDictionary *)fontDictionary;
{
    assert(fontDictionary[@"size"]);
    NSString *fontName = self.fontName;
    if (fontDictionary[@"name"]) {
        fontName = fontDictionary[@"name"];
    }
    return [UIFont fontWithName:fontName size:[fontDictionary[@"size"] floatValue]];
}

@end
