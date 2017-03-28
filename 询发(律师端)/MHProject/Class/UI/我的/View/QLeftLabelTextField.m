//
//  QLeftLabelTextField.m
//  Fuyph
//
//  Created by Andy on 15-1-22.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "QLeftLabelTextField.h"

@implementation QLeftLabelTextField

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = DEF_RGB_COLOR(202, 202, 202).CGColor;
        self.layer.borderWidth = LINE_HEIGHT;
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        [self creatSubViews];
    }
    return self;
}

-(void)creatSubViews{
    self.leftLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, self.height)];
    self.leftLbl.font = [UIFont systemFontOfSize:16];
    self.leftLbl.textColor = DEF_RGB_COLOR(51, 51, 51);
    self.leftLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.leftLbl];
    //
    self.rightField = [[UITextField alloc] initWithFrame:CGRectMake(DEF_RIGHT(self.leftLbl)+10, 2.5, self.width-DEF_WIDTH(self.leftLbl), self.height-5)];
    self.rightField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,8,self.height-5)];
    self.rightField.leftViewMode = UITextFieldViewModeAlways;
    self.rightField.clearButtonMode = UITextFieldViewModeAlways;
    self.rightField.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.rightField];
    
    //
    UIView *rightBgView =[[UIView alloc]initWithFrame:CGRectMake(0, 2.5, 20, self.height-5)];
    self.rightField.rightView = rightBgView;
    self.rightField.rightViewMode = UITextFieldViewModeAlways;
    //
    self.rightImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 8, 10, DEF_HEIGHT(rightBgView)-16)];
    [self.rightImageBtn setBackgroundImage:[UIImage imageNamed:@"arrow-right"] forState:UIControlStateNormal];
    self.rightImageBtn.imageView.contentMode =UIViewContentModeScaleAspectFit;
    [rightBgView addSubview:self.rightImageBtn];

    //
//    self.rightLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, self.height)];
//    self.rightLbl.font = [UIFont systemFontOfSize:20];
//    self.rightLbl.textColor = [UIColor grayColor];
//    self.rightLbl.textAlignment = NSTextAlignmentRight;
//    self.rightField.rightView = self.rightLbl;
//    self.rightField.rightViewMode = UITextFieldViewModeAlways;
//    self.rightLbl.backgroundColor = [UIColor redColor];
}
-(void)setCanEdit:(BOOL)canEdit{
    _canEdit = canEdit;
    self.rightField.enabled = _canEdit;
    self.rightField.layer.borderColor = _canEdit ? [UIColor grayColor].CGColor : [UIColor clearColor].CGColor;
    self.backgroundColor = _canEdit ? [UIColor whiteColor] : DEF_RGB_COLOR(240, 240, 240);
;
}
@end
