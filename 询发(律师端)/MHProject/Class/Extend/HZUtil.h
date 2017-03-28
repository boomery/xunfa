//
//  HZUtil.h
//  MHProject
//
//  Created by 张好志 on 15/6/22.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZUtil : NSObject

+ (CGFloat)getHeightWithString:(NSString *)str fontSize:(CGFloat)fontSize width:(CGFloat)width;
+ (CGFloat)getWidthWithString:(NSString *)str fontSize:(CGFloat)fontSize width:(CGFloat)width;


//获取图片的大小 (单位M)
+ (CGFloat)getImageSizeWithImage:(UIImage *)image;


@end
