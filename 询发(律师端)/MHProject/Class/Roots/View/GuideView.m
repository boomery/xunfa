//
//  GuideView.m
//  PerfectProject
//
//  Created by ZhangHaoZhi on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import "GuideView.h"
#import "LoginViewController.h"

/**
 *  引导页张数
 */
#define DEF_GUIDE_COUNT 3

@implementation GuideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.contentSize                    = CGSizeMake(DEF_WIDTH(self)*DEF_GUIDE_COUNT, DEF_HEIGHT(self));
        self.pagingEnabled                  = YES;
        self.backgroundColor                = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.bounces = NO;
        for (int i=0; i<DEF_GUIDE_COUNT; i++)
        {
            NSString *path          = DEF_SCREEN_IS_5s ? [NSString stringWithFormat:@"guide%d-Default568.png", i] : [NSString stringWithFormat:@"guide%d.png", i];
            UIImageView *imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(DEF_WIDTH(self)*i, 0, DEF_WIDTH(self), DEF_HEIGHT(self))];
            imageView.image         = [UIImage imageWithContentsOfFile:DEF_IMAGE_PATH(path)];
            [self addSubview:imageView];
            
            
            if (i == DEF_GUIDE_COUNT-1)
            {
                imageView.userInteractionEnabled = YES;
                
                // 开始按钮，一般放在最后一张引导页上，frame大小自己根据需要进行调整
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, DEF_WIDTH(self), DEF_HEIGHT(self))];
//                button.backgroundColor = [UIColor redColor];
                [button setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(beginClick:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:button];
            }
        }
    }
    return self;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSInteger count =scrollView.contentOffset.x/self.bounds.size.width;
    
    if (count==2)
    {
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:1 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

//
- (void)beginClick:(UIButton *)btn
{
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
