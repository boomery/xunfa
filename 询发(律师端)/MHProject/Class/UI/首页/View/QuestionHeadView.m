//
//  QuestionHeadView.m
//  MHProject
//
//  Created by 张好志 on 15/6/21.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "QuestionHeadView.h"
#import "HZUtil.h"

@implementation QuestionHeadView

- (id)initWithFrame:(CGRect)frame withData:(id)data
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        //
        //姓名
        UILabel *questionNameLable = [[UILabel alloc]initForAutoLayout];
        [self addSubview:questionNameLable];
        questionNameLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.5];
        [questionNameLable autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:10];
        [questionNameLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10];
        [questionNameLable autoSetDimensionsToSize:CGSizeMake(100, 24)];
        questionNameLable.text = data[@"name"];
        questionNameLable.textColor = NameColor;
        
        
        UILabel *timeLable = [[UILabel alloc]initForAutoLayout];
        [self addSubview:timeLable];
        timeLable.font = [UIFont systemFontOfSize:12];
        timeLable.textColor = DEF_RGB_COLOR(142, 142, 147);
        timeLable.textAlignment = 2;
        [timeLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10];
        [timeLable autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:questionNameLable withOffset:0];
        [timeLable autoSetDimensionsToSize:CGSizeMake(100, 20)];
        timeLable.text = data[@"created_at"];
        
        //
        NSString *str =data[@"content"];
        float height = [HZUtil getHeightWithString:str fontSize:16 width:DEF_SCREEN_WIDTH-20];
        self.questionContentLB = [[UILabel alloc]initWithFrame:CGRectMake(10, 44, DEF_SCREEN_WIDTH-20, height+5)];
        self.questionContentLB.font = [UIFont systemFontOfSize:16];
        self.questionContentLB.numberOfLines = 0;
        self.questionContentLB.textColor = DEF_RGB_COLOR(61, 61, 71);
        self.questionContentLB.text = str;
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
