//
//  IndustryTagCell.m
//  MHProject
//
//  Created by 杜宾 on 15/6/27.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "IndustryTagCell.h"

@implementation IndustryTagCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.layer.borderColor = [DEF_RGB_COLOR(231, 230, 235) CGColor];
        if (DEF_SCREEN_IS_6plus)
        {
            self.layer.borderWidth = 1/6.0;
        }
        else
        {
            self.layer.borderWidth = 1/4.0;
        }
        [self initCollectionWith:frame];
    }
    return self;
}
-(void)initCollectionWith:(CGRect)frame
{
    //    图片
    self.imagePic = [[UIImageView alloc]initWithFrame:CGRectMake((DEF_SCREEN_WIDTH/4.0-TRANSFORM_HEIGHT(40))/2.0, TRANSFORM_HEIGHT(10), TRANSFORM_HEIGHT(40.0), TRANSFORM_HEIGHT(40.0))];
    self.imagePic.userInteractionEnabled = YES;
    [self addSubview:self.imagePic];
    //
    self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0,   DEF_BOTTOM(self.imagePic), frame.size.width, TRANSFORM_HEIGHT(20.0))];
    self.nameLable.font = [UIFont systemFontOfSize:13.5];
    self.nameLable.textAlignment = 1;
    self.nameLable.textColor = DEF_RGB_COLOR(142, 142, 147);
    [self addSubview:self.nameLable];
}


@end
