//
//  UIColor+HexColor.h
//  GaoDunShcool2.0
//
//  Created by Andy on 13-9-25.
//  Copyright (c) 2013年 Andy. All rights reserved.
//

/*
 * @brief 设置自定义颜色的一个分类 如#f2f2f2 
 */
#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+ (UIColor *)colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha;

@end
