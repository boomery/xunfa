//
//  ProgressImageView.h
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/20.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPieProgressView.h"
@interface ProgressImageView : UIView <UIScrollViewDelegate>

@property (nonatomic, strong) SDPieProgressView *pie;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGFloat progress;

@end
