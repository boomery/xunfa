//
//  Tools.m
//  BestShopping
//
//  Created by Andyon 15/1/13.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "Tools.h"

@implementation Tools
//做ios版本之间的适配
//不同的ios版本,调用不同的方法,实现相同的功能
+(CGSize)sizeOfStr:(NSString *)str
           andFont:(UIFont *)font
        andMaxSize:(CGSize)size
  andLineBreakMode:(NSLineBreakMode)mode
{
    CGSize s;
    if ([[[UIDevice currentDevice]systemVersion]doubleValue]>=7.0)
    {
        NSDictionary *dic=@{NSFontAttributeName:font};
        s = [str boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:dic context:nil].size;
    }
    else
    {
        s=[str sizeWithFont:font constrainedToSize:size lineBreakMode:mode];
    }
    return s;
}

@end
