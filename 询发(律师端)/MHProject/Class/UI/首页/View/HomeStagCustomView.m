//
//  HomeStagCustomView.m
//  MHProject
//
//  Created by 杜宾 on 15/7/16.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "HomeStagCustomView.h"

@implementation HomeStagCustomView
-(id)init
{
    self = [super init];
    if (self)
    {
//        self.backgroundColor = [UIColor orangeColor];
        
        //
        self.stagLable = [[UILabel alloc]initForAutoLayout];
        [self addSubview:self.stagLable];
        [self.stagLable autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:0];
        [self.stagLable autoPinEdge:ALEdgeTop  toEdge:ALEdgeTop ofView:self withOffset:0];
        [self.stagLable autoPinEdge:ALEdgeBottom  toEdge:ALEdgeBottom ofView:self withOffset:0];
        [self.stagLable autoPinEdge:ALEdgeLeft  toEdge:ALEdgeLeft ofView:self withOffset:20 relation:NSLayoutRelationGreaterThanOrEqual];
        
        //
        self.stagImagePic = [[UIImageView alloc]initForAutoLayout];
        [self addSubview:self.stagImagePic];
        [self.stagImagePic autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.stagLable withOffset:0];
        [self.stagImagePic autoPinEdge:ALEdgeTop  toEdge:ALEdgeTop ofView:self withOffset:0];
        [self.stagImagePic autoPinEdge:ALEdgeBottom  toEdge:ALEdgeBottom ofView:self withOffset:0];
        [self.stagImagePic autoPinEdge:ALEdgeLeft  toEdge:ALEdgeLeft ofView:self withOffset:0 relation:NSLayoutRelationGreaterThanOrEqual];
        self.stagImagePic.contentMode = UIViewContentModeScaleAspectFit;
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
