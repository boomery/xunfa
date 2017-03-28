//
//  UserCenterBtn.m
//  MHProject
//
//  Created by 杜宾 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "UserCenterBtn.h"

@implementation UserCenterBtn

-(id)initWithFrame:(CGRect)frame WithImage:(UIImage *)imagePic WithTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self)
    {
        int width = width(18.0);
        int hSpace = ((DEF_SCREEN_WIDTH/3) - width)/2;
        self.picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(hSpace, 5, width, width)];
        self.picImageView.image = imagePic;
        [self addSubview:self.picImageView];
        
        UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(self.picImageView) + 5, self.frame.size.width, width)];
        nameLable.text = title;
        nameLable.textAlignment = 1;
        [self addSubview:nameLable];
        
        if (DEF_SCREEN_IS_6plus)
        {
            nameLable.font = DEF_Font(14);
        }
        else
        {
            nameLable.font = DEF_Font(10);
        }
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
