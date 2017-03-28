//
//  QuestionHeadView.h
//  MHProject
//
//  Created by 张好志 on 15/6/21.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionHeadView : UIView

@property (nonatomic,strong)UILabel *nameLB;//名字
@property (nonatomic,strong)UILabel *questionContentLB;//问题内容

- (id)initWithFrame:(CGRect)frame withData:(id)data;

@end
