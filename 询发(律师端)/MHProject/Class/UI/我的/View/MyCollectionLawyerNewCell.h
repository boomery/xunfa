//
//  MyCollectionLawyerNewCell.h
//  MHProject
//
//  Created by 杜宾 on 15/7/28.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionLawyerNewCell : UITableViewCell
@property(nonatomic,strong)UIButton    *lawerHeadImageBtn;   //头像
@property(nonatomic,strong)UILabel     *lawerNameLB;         //名字
@property(nonatomic,strong)UILabel     *lawergradeLB;        //等级
@property(nonatomic,strong)UILabel     *laweryearLB;         //年限
@property(nonatomic,strong)UILabel     *lawerIntroductionLB; //律师介绍
@property(nonatomic,strong)UILabel     *lawershanchangSortLB;//律师擅长分类
//@property(nonatomic,strong)UIButton    *lawerPhoneBtn;       //打电话按
@property(nonatomic,strong)UILabel     *bottomLineLB;          //下方的线条


@property(nonatomic,strong)UIView     *bgView;          //下方的线条

@property(nonatomic,strong)UILabel     *shanLabOne;          //下方的线条
@property(nonatomic,strong)UILabel     *shanLabTwo;          //下方的线条
@property(nonatomic,strong)UILabel     *shanLabThree;          //下方的线条
@property(nonatomic,strong)NSMutableArray      *shanArray;          //下方的线条

@property(nonatomic,strong)UILabel     *heHuoLab;          //下方的线条
@property(nonatomic,strong)UILabel     *cityLan;          //下方的线条
@property(nonatomic,strong)UILabel     *lvSuoLab;          //下方的线条


+(float)heightForCellWithDict:(NSDictionary *)dict;
-(void)loadCellWithDict:(NSDictionary *)dict;

@end
