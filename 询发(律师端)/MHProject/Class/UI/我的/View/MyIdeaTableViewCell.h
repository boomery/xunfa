//
//  MyIdeaTableViewCell.h
//  MHProject
//
//  Created by 张好志 on 15/6/25.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyIdeaTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel     *myIdeaToPersonLB;     //给某人出的主意
@property(nonatomic,strong)UILabel     *myIdeaTimeLB;         //时间
@property(nonatomic,strong)UILabel     *myIdeaLB;             //我出的主意
@property(nonatomic,strong)UILabel     *questionLB;          //问题标签
@property(nonatomic,strong)UIButton    *questionBtn;          //问题按钮
@property(nonatomic,strong)UILabel     *bottomLineLB;         //下方的线条

//我的主意
+(float)heightForCellWithDict:(NSDictionary *)dict;
-(void)loadCellWithDict:(NSDictionary *)dict;


//我的抢答
-(void)loadCellWithRaceQuestionDict:(NSDictionary *)dict;
+(float)heightForCellWithRaceQuestionDict:(NSDictionary *)dict;

@end
