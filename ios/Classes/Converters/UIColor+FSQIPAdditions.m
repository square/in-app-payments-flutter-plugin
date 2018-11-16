//
//  Test.m
//  square_in_app_payments
//
//  Created by Xiao Hu on 10/17/18.
//

#import "UIColor+FSQIPAdditions.h"

@implementation UIColor (FSQIPAdditions)

- (UIColor*) fromJsonDictionary:(NSDictionary*)fontDictionary;
{
    assert(fontDictionary[@"r"]);
    assert(fontDictionary[@"g"]);
    assert(fontDictionary[@"b"]);
    
    CGFloat red = [fontDictionary[@"r"] floatValue] / 255;
    CGFloat green = [fontDictionary[@"g"] floatValue] / 255;
    CGFloat blue =[fontDictionary[@"b"] floatValue] / 255;
    CGFloat alpha = 1.0;
    if (fontDictionary[@"a"]) {
        alpha = [fontDictionary[@"a"] floatValue];
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
