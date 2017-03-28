//
//  UIColor+HexColor.m
//  GaoDunShcool2.0
//
//  Created by Andy on 13-9-25.
//  Copyright (c) 2013年 Andy. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)

+ (UIColor *)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha {
    CGFloat red = (hex >> 16 & 0xFF) / 255.0f;
    CGFloat green = (hex >> 8 & 0xFF) / 255.0f;
    CGFloat blue = (hex & 0xFF) / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
