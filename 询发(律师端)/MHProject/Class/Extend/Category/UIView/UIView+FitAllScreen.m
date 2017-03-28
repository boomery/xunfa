//
//  UIView+FitAllScreen.m
//  Bluemobile
//
//  Created by chenjianglin on 15/4/2.
//  Copyright (c) 2015年 chenjianglin. All rights reserved.
//

#import "UIView+FitAllScreen.h"
#define LayoutSize_px     CGSizeMake(640, 1136)
#define LayoutSize_pt     CGSizeMake(320, 568)

#define kHeight_Ratio     1.05
@implementation UIView (FitAllScreen)
- (void)transformFrameToFitScreenWithLayoutRect:(CGRect)layoutRect
{
    CGRect rect  = CGRectZero;
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        //设备尺寸
        CGSize pixelSize = [UIScreen mainScreen].currentMode.size;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        if (screenSize.height < 568) {
            self.frame = layoutRect;
            return;
        }
        
        
        
//        //设计
//        CGFloat initial_Ratio_H = LayoutSize_px.width / LayoutSize_pt.width;//@2x
//        //        CGFloat initial_Ratio_V = LayoutSize_px.height / LayoutSize_pt.height;//@2x
//        //真实
//        CGFloat current_Ratio_H = pixelSize.width / screenSize.width;//@3x
        //        CGFloat current_Ratio_V = pixelSize.height / screenSize.height;//@3x
        
        //        CGFloat H = initial_Ratio_H / LayoutSize_px.width;
        //        CGFloat V = initial_Ratio_V / LayoutSize_px.height;
        
        
        //我来修改
        //设计
        CGFloat initial_Ratio_H = LayoutSize_px.width / LayoutSize_pt.width;//@2x
        CGFloat initial_Ratio_V = LayoutSize_px.height / LayoutSize_pt.height;//@2x
        //真实
        CGFloat current_Ratio_H = pixelSize.width / screenSize.width;//@3x
        CGFloat current_Ratio_V = pixelSize.height / screenSize.height;//@3x
        
        //        CGFloat H = initial_Ratio_H / LayoutSize_px.width;
        //        CGFloat
        
        
        CGFloat F_X = 0.0f;
        CGFloat F_Y = 0.0f;
        CGFloat F_Width = 0.0f;
        CGFloat F_Height = 0.0f;
        
        //如果水平倍率一样
        if (initial_Ratio_H == current_Ratio_H) {
            //UI图片大小不变，水平间距等按屏幕比率计算,竖直间距不变
//            F_X = layoutRect.origin.x * screenSize.width / LayoutSize_pt.width;
//            F_Y = layoutRect.origin.y;
//            
//            F_Width = layoutRect.size.width * screenSize.width / LayoutSize_pt.width;
//            F_Height = layoutRect.size.height;
            
            /********/
            F_X = layoutRect.origin.x * screenSize.width / LayoutSize_pt.width;
            F_Y = layoutRect.origin.y* screenSize.height / LayoutSize_pt.height;
            
            F_Width = layoutRect.size.width * screenSize.width / LayoutSize_pt.width;
            F_Height = layoutRect.size.height * screenSize.height / LayoutSize_pt.height;
        }else{
//            //UI图标大小等比改变，水平竖直间距等比改变
//            F_X = layoutRect.origin.x * initial_Ratio_H / LayoutSize_px.width * pixelSize.width / current_Ratio_H;
//            //            F_Y = layoutRect.origin.y * initial_Ratio_V / LayoutSize_px.height * pixelSize.height / current_Ratio_V;
//            F_Y = layoutRect.origin.y * kHeight_Ratio;
//            F_Width = layoutRect.size.width * initial_Ratio_H / LayoutSize_px.width * pixelSize.width / current_Ratio_H;
//            //            F_Height = layoutRect.size.height * initial_Ratio_V / LayoutSize_px.height * pixelSize.height / current_Ratio_V;
//            F_Height = layoutRect.size.height * kHeight_Ratio;
            
            
            //我来修改
            //UI图标大小等比改变，水平竖直间距等比改变
            F_X = layoutRect.origin.x * initial_Ratio_H / LayoutSize_px.width * pixelSize.width / current_Ratio_H;
            F_Y = layoutRect.origin.y * initial_Ratio_V / LayoutSize_px.height * pixelSize.height / current_Ratio_V;
            //F_Y = layoutRect.origin.y * kHeight_Ratio;
            F_Width = layoutRect.size.width * initial_Ratio_H / LayoutSize_px.width * pixelSize.width / current_Ratio_H;
            F_Height = layoutRect.size.height * initial_Ratio_V / LayoutSize_px.height * pixelSize.height / current_Ratio_V;
            //F_Height = layoutRect.size.height * kHeight_Ratio;
            
            
            
        }
        
        rect = CGRectMake(F_X, F_Y, F_Width, F_Height);
    }else{
        rect = layoutRect;
    }
    self.frame = rect;
}
+ (CGFloat)transformHeight:(CGFloat)height {
    
    CGFloat T_Height  = 0.0f;
    
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        //设备尺寸
        CGSize pixelSize = [UIScreen mainScreen].currentMode.size;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        if (screenSize.height < 568) {
            return height;
        }

        //设计
        CGFloat initial_Ratio_V = LayoutSize_px.height / LayoutSize_pt.height;//@2x
        //真实
        CGFloat current_Ratio_V = pixelSize.height / screenSize.height;//@3x
        
        //如果水平倍率一样
        if (initial_Ratio_V == current_Ratio_V) {
            //
            T_Height = height * screenSize.height / LayoutSize_pt.height;
            
        }else {
            //UI图标大小等比改变，水平竖直间距等比改变
            //            T_Height = height * initial_Ratio_V / LayoutSize_px.height * pixelSize.height / current_Ratio_V;//1.29.
            T_Height = height * initial_Ratio_V / LayoutSize_px.height * pixelSize.height / current_Ratio_V;
        }
        
    }else{
        T_Height = height;
    }
    return T_Height;
    
//    CGFloat T_Height  = 0.0f;
//    
//    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
//        //设备尺寸
//        CGSize pixelSize = [UIScreen mainScreen].currentMode.size;
//        CGSize screenSize = [UIScreen mainScreen].bounds.size;
//        //设计
//        CGFloat initial_Ratio_V = LayoutSize_px.height / LayoutSize_pt.height;//@2x
//        //真实
//        CGFloat current_Ratio_V = pixelSize.height / screenSize.height;//@3x
//        
//        //如果水平倍率一样
//        if (initial_Ratio_V == current_Ratio_V) {
//            //
//            T_Height = height;
//        }else {
//            //UI图标大小等比改变，水平竖直间距等比改变
//            //            T_Height = height * initial_Ratio_V / LayoutSize_px.height * pixelSize.height / current_Ratio_V;//1.29.
//            T_Height = height * kHeight_Ratio;
//        }
//        
//    }else{
//        T_Height = height;
//    }
//    return T_Height;
    
}

+ (CGFloat)transformHeightSamePxChange:(CGFloat)height {
    CGFloat T_Height  = 0.0f;
    
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        //设备尺寸
        //        CGSize pixelSize = [UIScreen mainScreen].currentMode.size;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        //设计
        //        CGFloat initial_Ratio_V = LayoutSize_px.height / LayoutSize_pt.height;//@2x
        //        //真实
        //        CGFloat current_Ratio_V = pixelSize.height / screenSize.height;//@3x
        
        //如果水平倍率一样
        //        if (initial_Ratio_V == current_Ratio_V) {
        //            //
        //            if (LayoutSize_pt.height == screenSize.height) {
        //                T_Height = height;
        //            }else{
        //                T_Height = height * (screenSize.height - 49 - 64) / (LayoutSize_pt.height - 49 - 64);
        //            }
        //        }else{
        //            //UI图标大小等比改变，水平竖直间距等比改变
        //            T_Height = height * initial_Ratio_V / LayoutSize_px.height * pixelSize.height / current_Ratio_V;
        //        }
        T_Height = height * (screenSize.height - 49 - 64) / (LayoutSize_pt.height - 49 - 64);
    }else{
        T_Height = height;
    }
    return T_Height;
    
}

+ (CGFloat)transformWidth:(CGFloat)width {
    CGFloat H_Width  = 0.0f;
    
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        //设备尺寸
        CGSize pixelSize = [UIScreen mainScreen].currentMode.size;
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        if (screenSize.height < 568) {
            return width;
        }
        //设计
        CGFloat initial_Ratio_H = LayoutSize_px.width / LayoutSize_pt.width;//@2x
        //真实
        CGFloat current_Ratio_H = pixelSize.width / screenSize.width;//@3x
        
        //如果水平倍率一样
        if (initial_Ratio_H == current_Ratio_H) {
            //
            if (LayoutSize_pt.width == screenSize.width) {
                //尺寸一致不变
                H_Width = width;
            }else{
                //与尺寸同比改变
                H_Width = width * screenSize.width / LayoutSize_pt.width;
            }
        }else{
            //与分辨率同比改变
            H_Width = width * initial_Ratio_H / LayoutSize_px.width * pixelSize.width / current_Ratio_H;
        }
        
    }else{
        H_Width = width;
    }
    return H_Width;
    
    
//    CGFloat H_Width  = 0.0f;
//    
//    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
//        //设备尺寸
//        CGSize pixelSize = [UIScreen mainScreen].currentMode.size;
//        CGSize screenSize = [UIScreen mainScreen].bounds.size;
//        //设计
//        CGFloat initial_Ratio_H = LayoutSize_px.width / LayoutSize_pt.width;//@2x
//        //真实
//        CGFloat current_Ratio_H = pixelSize.width / screenSize.width;//@3x
//        
//        //如果水平倍率一样
//        if (initial_Ratio_H == current_Ratio_H) {
//            //
//            if (LayoutSize_pt.width == screenSize.width) {
//                //尺寸一致不变
//                H_Width = width;
//            }else{
//                //与尺寸同比改变
//                H_Width = width * screenSize.width / LayoutSize_pt.width;
//            }
//        }else{
//            //与分辨率同比改变
//            H_Width = width * initial_Ratio_H / LayoutSize_px.width * pixelSize.width / current_Ratio_H;
//        }
//        
//    }else{
//        H_Width = width;
//    }
//    return H_Width;
    
}
@end
