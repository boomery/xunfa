//
//  HZAddImageButton.m
//  MHProject
//
//  Created by 张好志 on 15/6/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "HZAddImageButton.h"

@implementation HZAddImageButton
-(id)initWithFrame:(CGRect)frame WithImage:(UIImage *)imagePic
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *picImageView = [[UIImageView alloc]init];
        picImageView.center = CGPointMake(frame.size.width/2.0, frame.size.height/2.0);
        picImageView.bounds = CGRectMake(0, 0, 40, 40);
        picImageView.image = imagePic;
        [self addSubview:picImageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
