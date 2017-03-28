//
//  QLeftLabelCheckBox.m
//
//  Created by Andy on 15-1-22.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "QLeftLabelCheckBox.h"

@implementation QLeftLabelCheckBox
-(instancetype)initWithFrame:(CGRect)frame withArray:(NSArray *)arr{
    if (self = [super initWithFrame:frame]) {
        self.titleArray = arr;
//        _selectedIndex = -1;
        [self creatSubViews];
    }
    return self;
}
-(void)creatSubViews{
    //
    self.leftLbl = [[UILabel alloc] initWithFrame:CGRectMake(0,0,125,self.height)];
    self.leftLbl.font = [UIFont systemFontOfSize:12];
    self.leftLbl.textColor = [UIColor grayColor];
    self.leftLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.leftLbl];
    //
//    float wid = (self.width-100)/self.titleArray.count;
    float wid = 60;
    self.openBt = [[UIButton alloc] initWithFrame:CGRectMake(130,0,wid,self.height)];
    self.openBt.tag = 100;
    self.openBt.titleLabel.font = [UIFont systemFontOfSize:12];
//    self.openBt.selected = YES;
    [self.openBt addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.openBt setImage:[UIImage imageNamed:@"SexRect"] forState:UIControlStateNormal];
    [self.openBt setImage:[UIImage imageNamed:@"SexRed"] forState:UIControlStateSelected];
    self.openBt.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.openBt.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [self.openBt setTitle:self.titleArray[0] forState:UIControlStateNormal];
    [self.openBt setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:self.openBt];
    for (int i = 1; i<self.titleArray.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(130+wid*i,0,wid,self.height)];
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        if (i == 0) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"SexRect"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"SexRed"] forState:UIControlStateSelected];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:btn];
    }
    
}
-(void)setCanEdit:(BOOL)canEdit{
    _canEdit = canEdit;
    self.userInteractionEnabled = _canEdit;
}
-(void)setSelectedIndex:(long)selectedIndex{
    _selectedIndex = selectedIndex;
    UIButton *btn = (UIButton *)[self viewWithTag:_selectedIndex+100];
    btn.selected = YES;
}
-(void)btnClick:(UIButton *)sender{
    if (_selectedIndex >= 0) {
        UIButton *btn = (UIButton *)[self viewWithTag:_selectedIndex+100];
        btn.selected = NO;
    }else{
        self.openBt.selected = NO;
    }
    sender.selected = YES;
    _selectedIndex = sender.tag-100;
}
@end
