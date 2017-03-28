//
//  UserLawyerInfoView.m
//  MHProject
//
//  Created by 杜宾 on 15/7/23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "UserLawyerInfoView.h"

@implementation UserLawyerInfoView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        self.myInfoLeft = [[UILabel alloc]initWithFrame:CGRectMake(10, 0,75,44)];
        [self addSubview:_myInfoLeft];
        self.myInfoLeft.font = DEF_Font(16);
        self.myInfoLeft.textColor = DEF_RGB_COLOR(61, 61, 71);
        self.myInfoLeft.textAlignment = NSTextAlignmentLeft;
        
        UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, 43-LINE_HEIGHT, DEF_SCREEN_WIDTH, LINE_HEIGHT)];
        line.backgroundColor = DEF_RGB_COLOR(214, 213, 217);
        [self addSubview:line];

        
        self.myInfoRight = [[UILabel alloc]initWithFrame:CGRectMake(DEF_RIGHT(_myInfoLeft), 0,DEF_SCREEN_WIDTH - DEF_WIDTH(self.myInfoLeft),44)];
        [self addSubview:_myInfoRight];
        self.myInfoRight.font = DEF_Font(16);
        self.myInfoRight.textColor = DEF_RGB_COLOR(142, 142, 147);
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
