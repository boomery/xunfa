//
//  AboutPersonView.m
//  MHProject
//
//  Created by 杜宾 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "AboutPersonView.h"
#import "HZUtil.h"

@implementation AboutPersonView
- (id)initWithFrame:(CGRect)frame withData:(id)data
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        //
        
        //
        self.nameLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, DEF_SCREEN_WIDTH-20, 30)];
        self.nameLB.textColor = DEF_RGB_COLOR(0, 0, 0);
        self.nameLB.text = @"个人简介：";
        self.nameLB.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.nameLB];
        
        //
        NSString *str =data;
        
        DEF_DEBUG(@"%@",str);
        float height = [HZUtil getHeightWithString:str fontSize:16 width:DEF_SCREEN_WIDTH-20];
        self.questionContentLB = [[UILabel alloc]initWithFrame:CGRectMake(DEF_LEFT(self.nameLB), DEF_BOTTOM(self.nameLB), DEF_WIDTH(self.nameLB), height+10)];
        self.questionContentLB.font = [UIFont systemFontOfSize:16];
        self.questionContentLB.textColor = DEF_RGB_COLOR(90, 91, 95);
        
        self.questionContentLB.numberOfLines = 0;
        
        if ([NSString isBlankString:str])
        {
            self.questionContentLB.text = @"无";
        }
        else
        {
            self.questionContentLB.text = str;
        }
        
        self.questionContentLB.backgroundColor = [UIColor clearColor];
        //        self.questionContentLB.backgroundColor = [UIColor greenColor];
        [self addSubview:self.questionContentLB];
        
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
