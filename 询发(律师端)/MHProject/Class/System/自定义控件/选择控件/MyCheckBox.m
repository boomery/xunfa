//
//  MyCheckBox.m
//  Fuyph
//
//  Created by bluemobi/thsboy on 15-1-23.
//  Copyright (c) 2015年 bluemobi. All rights reserved.
//

#import "MyCheckBox.h"

@implementation MyCheckBox

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self creatSubViews];
    }
    return self;
}
-(void)creatSubViews{
    //框
    self.rectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5,0,13,self.height)];
    self.rectImgView.image = [UIImage imageNamed:@"gou-no"];
    self.rectImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.rectImgView];
    //勾
    self.selectImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 15, self.height)];
    self.selectImgView.image = [UIImage imageNamed:@"gou"];
//    self.selectImgView.hidden = YES;
    self.selectImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.selectImgView];
    //图片
    self.rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 0, self.width-25, self.height)];
    self.rightImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.rightImgView];
    //文字
    self.rightLbl = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, self.width-25, self.height)];
    self.rightLbl.textColor = [UIColor grayColor];
    self.rightLbl.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.rightLbl];
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    
    self.selectImgView.hidden = !selected;
}


@end
