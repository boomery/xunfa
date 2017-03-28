//
//  MBProgressManager.m
//  BlueMobiProject
//
//  Created by Andy on 14-8-13.
//  Copyright (c) 2014年 Andy. All rights reserved.
//

#import "MBProgressManager.h"
#define HudTag 99999

@implementation MBProgressManager

+ (void)ShowWithText:(NSString *)text fromView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
	
	// Configure for text only and offset down
	hud.mode = MBProgressHUDModeText;
	hud.labelText = text;
	hud.margin = 10.f;
	hud.yOffset = 150.f;
	hud.removeFromSuperViewOnHide = YES;
	
	[hud hide:YES afterDelay:3];
}
+ (void)hidFormView:(UIView *)view
{
    MBProgressHUD *viewHud = (MBProgressHUD *)[view viewWithTag:HudTag];
    if (viewHud)
    {
        [viewHud hide:YES afterDelay:0.1];
    }
}

+ (void)hidFormView:(UIView *)view afterDelay:(CGFloat)delay
{
    MBProgressHUD *viewHud = (MBProgressHUD *)[view viewWithTag:HudTag];
    if (viewHud)
    {
        [viewHud hide:YES afterDelay:delay];
    }
}

+ (void)SHowLoadingToView:(UIView *)view
{
    MBProgressHUD *viewHud = (MBProgressHUD *)[view viewWithTag:HudTag];
    if (!viewHud)
    {
        MBProgressHUD *hud  = [[MBProgressHUD alloc] initWithView:view];
        hud.tag = HudTag;
        hud.removeFromSuperViewOnHide = YES;
        [view addSubview:hud];
        hud.labelText = @"正在加载...";
        [hud show:YES];
    }
//	hud.delegate = self;
}

+ (void)showLoadingToView:(UIView *)view WithTitle:(NSString *)title
{
    MBProgressHUD *viewHud = (MBProgressHUD *)[view viewWithTag:HudTag];
    if (!viewHud)
    {
        MBProgressHUD *hud  = [[MBProgressHUD alloc] initWithView:view];
        hud.tag = HudTag;
        hud.removeFromSuperViewOnHide = YES;
        [view addSubview:hud];
        hud.labelText = title;
        [hud show:YES];
    }
    //	hud.delegate = self;
}
+ (void)hidLoadingFormView:(UIView *)view
{
    MBProgressHUD *viewHud = (MBProgressHUD *)[view viewWithTag:HudTag];
    if (viewHud)
    {
        [viewHud hide:YES];
    }
}


@end
