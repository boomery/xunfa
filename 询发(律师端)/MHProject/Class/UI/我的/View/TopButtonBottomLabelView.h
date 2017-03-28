//
//  TopButtonBottomLabelView.h
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/22.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopButtonBottomLabelView : UIView

@property (nonatomic, strong) UIButton *topButton;

@property (nonatomic, strong) UIImage *topButtonImage;
@property (nonatomic, strong) NSString *topButtonTitle;
@property (nonatomic, strong) NSString *bottomLabelText;
@property (nonatomic, strong) UIColor *bottomLabelColor;
@property (nonatomic, strong) UIColor *topButtonTitleColor;
@end
