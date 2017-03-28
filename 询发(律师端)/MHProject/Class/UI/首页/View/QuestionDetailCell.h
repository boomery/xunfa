//
//  QuestionDetailCell.h
//  MHProject
//
//  Created by 杜宾 on 15/6/17.
//  Copyright (c) 2015年 杜宾. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCFireworksButton.h"
#import "LawerHearImageBtn.h"
@interface QuestionDetailCell : UITableViewCell

@property(nonatomic,strong)UIImageView       *topImageLine;
@property(nonatomic,strong)LawerHearImageBtn *userImageBtn; // 头像
@property(nonatomic,strong)UILabel           *name;  // 人名
@property(nonatomic,strong)UILabel           *gradeLab;  //等级
@property(nonatomic,strong)UILabel           *yearLab;  //年限
@property(nonatomic,strong)UILabel           *addressLab;  //地点
@property(nonatomic,strong)UILabel           *questionLable;//问题
@property(nonatomic,strong)UIImageView       *adoptImagePic;//采纳回复
@property(nonatomic,strong)MCFireworksButton *praiseBtn; // 点赞按钮
@property(nonatomic,strong)UILabel           *praiseCount; // 点赞的数量
@property(nonatomic,strong)UILabel           *timeLable;//几分钟前回复的
@property(nonatomic,strong)UIImageView       *bottomShortLineImage;//下方短线条
@property(nonatomic,strong)UIImageView       *cellLastLine;//cell最下方的线条


-(void)loadCellWithDict:(NSDictionary *)diction WithHeadName:(NSString *)headName;
+(float)heightForCellWithDict:(NSDictionary *)dict;


@end
