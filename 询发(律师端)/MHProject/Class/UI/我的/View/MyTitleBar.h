//
//  MyTitleBar.h
//  Fuyph
//
//  Created by Andy on 15-1-21.
//  Copyright (c) 2015年 Andy. All rights reserved.
//
typedef void(^TitleBarBlock)(long index);

#import <UIKit/UIKit.h>

@interface MyTitleBar : UIView
{
    UIButton *lastBtn;
}
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,copy) TitleBarBlock titleBlock;

@property (nonatomic,assign) long index;

-(instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)arr;

@end
