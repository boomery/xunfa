//
//  OrderInfoView.m
//  MHProject
//
//  Created by 张好志 on 15/8/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "OrderInfoView.h"

@implementation OrderInfoView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //
        self.backgroundColor = [UIColor whiteColor];
        self.myInfoLeft = [[UILabel alloc]initWithFrame:CGRectMake(12, 0,DEF_SCREEN_WIDTH/2.0,self.height)];
        [self addSubview:_myInfoLeft];
        self.myInfoLeft.font = DEF_Font(18);
        self.myInfoLeft.textColor = DEF_RGB_COLOR(144, 144, 147);
        self.myInfoLeft.textAlignment = NSTextAlignmentLeft;

        //
        UIView *lineView = [[UIView alloc]initForAutoLayout];
        [self addSubview:lineView];
        [lineView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        [lineView autoSetDimensionsToSize:CGSizeMake(self.width, LINE_HEIGTH)];
        lineView.backgroundColor = DEF_RGB_COLOR(214, 214, 217);
        
        
        //
        self.myInfoRight = [[UILabel alloc]initForAutoLayout];
        [self addSubview:_myInfoRight];
        [self.myInfoRight autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
        [self.myInfoRight autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.myInfoLeft withOffset:-15];
        [self.myInfoRight autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-12];
        [self.myInfoRight autoSetDimension:ALDimensionHeight toSize:self.height];
        self.myInfoRight.font = DEF_Font(18);
        self.myInfoRight.textColor = DEF_RGB_COLOR(61, 61, 71);
        self.myInfoRight.textAlignment = 2;
        
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
