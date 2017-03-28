//
//  UIView+FitAllScreen.h
//  Bluemobile
//
//  Created by chenjianglin on 15/4/2.
//  Copyright (c) 2015年 chenjianglin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FitAllScreen)
- (void)transformFrameToFitScreenWithLayoutRect:(CGRect)layoutRect;

+ (CGFloat)transformHeight:(CGFloat)height;

+ (CGFloat)transformHeightSamePxChange:(CGFloat)height;

+ (CGFloat)transformWidth:(CGFloat)width;
@end
