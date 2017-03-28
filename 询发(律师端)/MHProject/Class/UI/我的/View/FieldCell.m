//
//  FieldCell.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/14.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "FieldCell.h"

@implementation FieldCell
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.frame = self.bounds;
        titleButton.layer.cornerRadius = 2;
        titleButton.userInteractionEnabled = NO;
        titleButton.clipsToBounds = YES;
        titleButton.backgroundColor = [UIColor whiteColor];
        [titleButton setTitleColor:DEF_RGB_COLOR(111, 111, 111) forState:UIControlStateNormal];
        titleButton.titleLabel.font = DEF_Font(18);
        [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self addSubview:titleButton];
        _titleButton = titleButton;
    }
    return self;
}
- (void)setIsSelected:(BOOL)isSelected
{
    self.titleButton.selected = isSelected;
    if (isSelected)
    {
        self.titleButton.backgroundColor = [UIColor colorWithRed:0.99 green:0.45 blue:0.25 alpha:1];
    }
    else
    {
        self.titleButton.backgroundColor = [UIColor whiteColor];
    }
}
@end
