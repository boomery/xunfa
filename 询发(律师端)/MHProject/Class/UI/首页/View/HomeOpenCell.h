//
//  HomeOpenCell.h
//  MHProject
//
//  Created by 杜宾 on 15/7/3.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeStagCustomView;
@interface HomeOpenCell : UITableViewCell
@property(nonatomic,strong)UIView *bgView; // 底部视图

@property(nonatomic,strong)UIButton    *userImageBtn;        // 头像
@property(nonatomic,strong)UILabel     *name;             // 人名
@property(nonatomic,strong)UIImageView *rushImageView;  //待抢答图标
@property(nonatomic,strong)UILabel     *questionLable;    // 问题
@property(nonatomic,strong)HomeStagCustomView *left;//左下角的标签
@property(nonatomic,strong)UILabel *dateLable;  //日期

//@property(nonatomic,strong)UILabel  *leftBottomLable;//左下角的lable
//@property(nonatomic,strong)UILabel  *rightBottomLable;//有下角的lable
//@property(nonatomic,strong)UIImageView *lineView;  //分割线
//@property(nonatomic,strong)UIButton    *rushBtn;  //抢的按钮

-(void)loadCellWithDict:(NSDictionary *)dict;
+(float)heightForCellWithDict:(NSDictionary *)dict;

@end
