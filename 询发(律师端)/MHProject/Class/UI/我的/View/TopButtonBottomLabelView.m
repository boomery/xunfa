//
//  TopButtonBottomLabelView.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/22.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "TopButtonBottomLabelView.h"
@interface TopButtonBottomLabelView ()
@property (nonatomic, strong) UILabel *bottomLabel;
@end

@implementation TopButtonBottomLabelView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIButton *topButton = [[UIButton alloc] initForAutoLayout];
        [self addSubview:topButton];
        [topButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:12];
        [topButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:12];
        [topButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
        [topButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-80/3.3];
        topButton.titleLabel.font = DEF_Font(11.5);
        [topButton setTitleColor:[UIColor colorWithRed:0.99 green:0.53 blue:0.44 alpha:1] forState:UIControlStateNormal];
        self.topButton = topButton;
        
        UILabel *bottomLabel = [[UILabel alloc] initForAutoLayout];
        [self addSubview:bottomLabel];
        [bottomLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:topButton withOffset:0];
        [bottomLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10];
        [bottomLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:topButton];
        bottomLabel.font = [UIFont boldSystemFontOfSize:13.5];
        self.bottomLabel = bottomLabel;
    
    }
    return self;
}

- (void)setTopButtonImage:(UIImage *)topButtonImage
{
    [self.topButton setImage:topButtonImage forState:UIControlStateNormal];
}
- (void)setTopButtonTitle:(NSString *)topButtonTitle
{
    [self.topButton setTitle:topButtonTitle forState:UIControlStateNormal];
}
- (void)setTopButtonTitleColor:(UIColor *)topButtonTitleColor
{
    [self.topButton setTitleColor:topButtonTitleColor forState:UIControlStateNormal];
}
- (void)setBottomLabelText:(NSString *)bottomLabelText
{
    self.bottomLabel.text = bottomLabelText;
}
- (void)setBottomLabelColor:(UIColor *)bottomLabelColor
{
    self.bottomLabel.textColor = bottomLabelColor;
}

@end
