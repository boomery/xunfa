//
//  MyInfoNewTableViewCell.h
//  MHProject
//
//  Created by 张好志 on 15/8/3.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInfoNewTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *topLine;
@property(nonatomic,strong)UILabel     *lawyerTipLB;//律师的回复信息
@property(nonatomic,strong)UILabel     *timeLB;//时间
@property(nonatomic,strong)UIImageView *enterImageView;//进入的三角符号
@property(nonatomic,strong)UILabel     *questionLB;//原来的问题
@property(nonatomic,strong)UIImageView *bottomLine;//cell最下方的线条

+(float)heightForCellWithDict:(NSDictionary *)dict;
-(void)loadCellWithDict:(NSDictionary *)dict;

@end
