//
//  UIImage+Resize.h
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/16.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)
- (UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
@end
