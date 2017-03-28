//
//  MycollectionQuestionCell.h
//  MHProject
//
//  Created by 杜宾 on 15/7/15.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeStagCustomView;
@interface MycollectionQuestionCell : UITableViewCell
@property(nonatomic,strong)UILabel     *questionLable;    // 问题
@property(nonatomic,strong)UILabel     *name;             // 人名
@property(nonatomic,strong)UIButton    *userImageBtn;        // 头像
@property(nonatomic,strong)UILabel     *leftBottomLable;  // 左下角的lable
@property(nonatomic,strong)UILabel     *rightBottomLable; // 有下角的lable
@property(nonatomic,strong)UIImageView *lineView;         // 分割线

@property(nonatomic,strong)UILabel *dateLable;  //日期


@property(nonatomic,strong)UILabel *adopt;  //采纳回复
@property(nonatomic,strong)UIImageView *adoptImagePic;  //采纳回复图片



@property(nonatomic,strong)HomeStagCustomView *rigth;

@property(nonatomic,strong)HomeStagCustomView *left;

//@property(nonatomic,strong)UIImageView *adoptImagePic;//采纳


//-(void)CreatCustomQuestionCell;
//-(void)setQUestionText:(NSString *)text;

-(void)loadCellWithDict:(NSDictionary *)dict;

+(float)heightForCellWithDict:(NSDictionary *)dict;
@end
