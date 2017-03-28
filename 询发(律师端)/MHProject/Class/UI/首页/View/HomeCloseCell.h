//
//  HomeCloseCell.h
//  MHProject
//
//  Created by 杜宾 on 15/7/3.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCloseCell : UITableViewCell

@property(nonatomic,strong)UIView *bgView; // 底部视图

@property(nonatomic,strong)UILabel     *questionLable;    // 问题
@property(nonatomic,strong)UILabel     *name;             // 人名
@property(nonatomic,strong)UIButton    *userImageBtn;        // 头像
@property(nonatomic,strong)UILabel     *leftBottomLable;  // 左下角的lable
@property(nonatomic,strong)UILabel     *rightBottomLable; // 有下角的lable
//@property(nonatomic,strong)UIImageView *lineView;         // 分割线
@property(nonatomic,strong)UILabel *dateLable;  //日期

-(void)loadCellWithDict:(NSDictionary *)dict;

+(float)heightForCellWithDict:(NSDictionary *)dict;


@end
