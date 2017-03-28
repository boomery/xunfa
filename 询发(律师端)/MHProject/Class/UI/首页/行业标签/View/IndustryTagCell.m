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
        
        [self initCollectionWith:frame];
    }
    return self;
}
-(void)initCollectionWith:(CGRect)frame
{
//    图片
    self.imagePic = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 70, 70)];
    self.imagePic.userInteractionEnabled = YES;
    [self addSubview:self.imagePic];
//    
    self.nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0,   DEF_BOTTOM(self.imagePic)+10, frame.size.width, 20)];
    self.nameLable.font = [UIFont systemFontOfSize:15];
    self.nameLable.textAlignment = 1;
    self.nameLable.textColor = DEF_RGB_COLOR(142, 147, 147);


    [self addSubview:self.nameLable];
}


@end
