//
//  MyTitleBar.m
//  Fuyph
//
//  Created by Andy on 15-1-21.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MyTitleBar.h"

@implementation MyTitleBar
@synthesize titleBlock;

-(instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)arr{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _index = 0;
        self.titleArray = arr;
        [self creatSubViews];
    }
    return self;
}
-(void)creatSubViews{
    UILabel *lineLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, DEF_SCREEN_WIDTH, LINE_HEIGHT)];
    lineLB.backgroundColor = DEF_RGB_COLOR(196, 196, 196);
    [self addSubview:lineLB];

    float wid = DEF_SCREEN_WIDTH/self.titleArray.count;
    for (int i = 0;i<self.titleArray.count; i++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(wid*i, 5,wid ,35)];
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        btn.selected = NO;
        if (i==0)
        {
            btn.selected = YES;
        }
        btn.tag = 100+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        [btn setTitleColor:DEF_RGB_COLOR(142, 142, 147) forState:UIControlStateNormal];
        [btn setTitleColor:DEF_RGB_COLOR(0, 160, 235) forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
//        UIView *grayline = [[UIView alloc] initWithFrame:CGRectMake(0, 30, wid, 1)];
//        grayline.hidden = YES;
//        grayline.backgroundColor = [UIColor lightGrayColor];
//        [self addSubview:grayline];
        //
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 34, wid, 1)];
        line.tag = 999;
        line.hidden = YES;
        line.backgroundColor = DEF_RGB_COLOR(0, 160, 235);
        [btn addSubview:line];
        if (i==0)
        {
            line.hidden = NO;
            lastBtn = btn;
        }
        
        

//        else
//        {
//            UIView *lineSu = [[UIView alloc] initWithFrame:CGRectMake(0, 8, 1, 19)];
//            lineSu.backgroundColor = [UIColor redColor];
//            [btn addSubview:lineSu];
//        }
    }
}
-(void)btnClick:(UIButton *)sender{
    sender.selected = YES;
    if (lastBtn) {
        UIView *lastLine = [lastBtn viewWithTag:999];
        lastLine.hidden = YES;
        lastBtn.selected = NO;
    }
    UIView *line = [sender viewWithTag:999];
    line.hidden  = NO;
    lastBtn = sender;
    _index = sender.tag - 100;
    titleBlock(sender.tag-100);
}
-(void)setIndex:(long)index{
    _index = index;
    UIButton *btn = (UIButton *)[self viewWithTag:100+index];
    [self btnClick:btn];
}
@end
