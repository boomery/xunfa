//
//  CustomHeaderReusableView.m
//  MHProject
//
//  Created by 杜宾 on 15/6/27.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "CustomHeaderReusableView.h"

@implementation CustomHeaderReusableView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        区头
        [self creatHeaderView:frame];
        
    }
    
    return self;
}
-(void)creatHeaderView:(CGRect)frame
{
    self.tagLable = [[UILabel alloc]initWithFrame:CGRectMake(12, 20, DEF_SCREEN_WIDTH, 30)];
    self.tagLable.textColor = DEF_RGB_COLOR(142, 147, 147);
    [self addSubview:self.tagLable];
    
    self.lineImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 10, DEF_SCREEN_WIDTH, 1)];
     self.lineImage.backgroundColor = DEF_RGB_COLOR(214, 214, 217);
    [self addSubview:self.lineImage];
    
}


@end
