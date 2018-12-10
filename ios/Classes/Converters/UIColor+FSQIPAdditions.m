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

#import "UIColor+FSQIPAdditions.h"


@implementation UIColor (FSQIPAdditions)

- (UIColor *)fromJsonDictionary:(NSDictionary *)fontDictionary;
{
    NSParameterAssert(fontDictionary[@"r"]);
    NSParameterAssert(fontDictionary[@"g"]);
    NSParameterAssert(fontDictionary[@"b"]);

    CGFloat red = [fontDictionary[@"r"] floatValue] / 255;
    CGFloat green = [fontDictionary[@"g"] floatValue] / 255;
    CGFloat blue = [fontDictionary[@"b"] floatValue] / 255;
    CGFloat alpha = fontDictionary[@"a"] ? [fontDictionary[@"a"] floatValue] : 1.0;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
