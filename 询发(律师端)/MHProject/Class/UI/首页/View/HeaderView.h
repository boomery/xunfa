//
//  HeaderView.h
//  MHProject
//
//  Created by 杜宾 on 15/6/17.
//  Copyright (c) 2015年 杜宾. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property(nonatomic,strong)UILabel *questionLable;  // 问题
@property(nonatomic,strong)UILabel *leftBottomLable; // 左下角的lable
@property(nonatomic,strong)UILabel *rightBottomLable; // 有下角的lable
@property(nonatomic,strong)UIImageView *lineView; // 分割线
@property(nonatomic,strong)UIImageView *sTag;   // 标签
@property(nonatomic,strong)UIImageView *sIdea;   // 主意

@property (nonatomic, strong) UIImageView *starImageView;
@property(nonatomic,strong)UIButton *collecBtn;  //收藏按钮
@property(nonatomic,strong)UIButton *reportBtn;  //举报按钮
@property(nonatomic,strong)UIButton *collecTextBtn;  //收藏lab
@property(nonatomic,strong)NSMutableArray *imageUrlArray;//用于保存显示的图片资源
@property (nonatomic, strong) id data;
- (id)initWithFrame:(CGRect)frame withDictionary:(NSDictionary *)data isContainImage:(BOOL)isContainImage;

@end
