//
//  NewQuestionView.h
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewQuestionView : UIView

@property(nonatomic,strong)UILabel *questionLabel;  // 问题
@property(nonatomic,strong)UILabel *leftBottomLable; // 左下角的lable
@property(nonatomic,strong)UILabel *rightBottomLable; // 有下角的lable
@property(nonatomic,strong)UIImageView *lineView; // 分割线

@property (nonatomic, strong) id data;
- (id)initWithFrame:(CGRect)frame with:(id)data;
@end
