//
//  AboutPersonView.h
//  MHProject
//
//  Created by 杜宾 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface AboutPersonView : UIView
@property (nonatomic,strong)UILabel *nameLB;//名字
@property (nonatomic,strong)UILabel *questionContentLB;//问题内容

- (id)initWithFrame:(CGRect)frame withData:(id)data;

@end
