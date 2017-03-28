//
//  HZDeleteButton.m
//  MHProject
//
//  Created by 张好志 on 15/6/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "HZDeleteButton.h"

@implementation HZDeleteButton
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *picImageView = [[UIImageView alloc]init];
        picImageView.frame = CGRectMake(frame.size.width-5, -5, 10, 10);
        picImageView.image = [UIImage imageNamed:@"ic-delet"];
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
