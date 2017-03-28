//
//  LawerTableViewCell.h
//  MHProject
//
//  Created by 张好志 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LawerTableViewCell : UITableViewCell

@property(nonatomic,strong)UIButton    *lawerHeadImageBtn;   //头像
@property(nonatomic,strong)UILabel     *lawerNameLB;         //名字
@property(nonatomic,strong)UILabel     *lawergradeLB;        //等级
@property(nonatomic,strong)UILabel     *laweryearLB;         //年限
@property (nonatomic, strong) UILabel *areaLabel;            //擅长领域
@property(nonatomic,strong)UILabel     *lawerIntroductionLB; //律师介绍
@property(nonatomic,strong)UILabel     *lawershanchangSortLB;//律师擅长分类
@property(nonatomic,strong)UIButton    *lawerPhoneBtn;       //打电话按
@property(nonatomic,strong)UILabel     *bottomLineLB;          //下方的线条

+(float)heightForCellWithDict:(NSDictionary *)dict;
-(void)loadCellWithDict:(NSDictionary *)dict;

@end
