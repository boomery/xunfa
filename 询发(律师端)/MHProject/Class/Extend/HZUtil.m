//
//  HZUtil.m
//  MHProject
//
//  Created by 张好志 on 15/6/22.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "HZUtil.h"

@implementation HZUtil

+ (CGFloat)getHeightWithString:(NSString *)str fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSString *detailStr = str;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    if (detailStr && ![detailStr isKindOfClass:[NSNull class]])
    {
        CGSize ziTiSize = [detailStr boundingRectWithSize:CGSizeMake(width , 3000)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        float height = ziTiSize.height;
        return height;
    }
    return 0;
}

+ (CGFloat)getWidthWithString:(NSString *)str fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSString *detailStr = str;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    if (detailStr && ![detailStr isKindOfClass:[NSNull class]])
    {
        CGSize ziTiSize = [detailStr boundingRectWithSize:CGSizeMake(width , 3000)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        float wid = ziTiSize.width;
        return wid;
    }
    return 0;
}

//获取图片的大小 (单位M)
+ (CGFloat)getImageSizeWithImage:(UIImage *)image
{
    NSData *imgData = nil;
    if (UIImagePNGRepresentation(image) == nil) {
        //将图片转换为JPG格式的二进制数据
        imgData = UIImageJPEGRepresentation(image, 1);
    } else {
        //将图片转换为PNG格式的二进制数据
        imgData = UIImagePNGRepresentation(image);
    }
    float length = imgData.length;
    
    float folderSize = 0.0;
    folderSize =length/(1024.0*1024.0);
    DEF_DEBUG(@"图片大小:%.2fM",folderSize);
    return folderSize;
}

@end
