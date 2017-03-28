//
//  MBProgressManager.h
//  BlueMobiProject
//
//  Created by Andy on 14-8-13.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface MBProgressManager : NSObject 

+ (void)ShowWithText:(NSString *)text fromView:(UIView *)view;
+ (void)hidFormView:(UIView *)view;
+ (void)hidFormView:(UIView *)view afterDelay:(CGFloat)delay;
+ (void)SHowLoadingToView:(UIView *)view;

+ (void)showLoadingToView:(UIView *)view WithTitle:(NSString *)title;
+ (void)hidLoadingFormView:(UIView *)view;

@end
