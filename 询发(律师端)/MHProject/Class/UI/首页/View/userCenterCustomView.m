//
//  userCenterCustomView.m
//  MHProject
//
//  Created by 杜宾 on 15/7/17.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "userCenterCustomView.h"

@implementation userCenterCustomView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.topNumberLabl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 10)];
        [self addSubview:self.topNumberLabl];
        self.topNumberLabl.textAlignment = 1;
        self.topNumberLabl.textColor = DEF_RGB_COLOR(61, 61, 71);
        
        
        self.topLable = [[UILabel alloc]initWithFrame:CGRectMake(0, DEF_BOTTOM(self.topNumberLabl)+5, DEF_WIDTH(self), 10)];
        [self addSubview:self.topLable];
        self.topLable.textAlignment = 1;
        self.topLable.textColor = DEF_RGB_COLOR(142, 142, 147);
        self.topNumberLabl.font = DEF_Font(13.5);
        self.topLable.font = DEF_Font(11.5);
        
        
            
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
