//
//  LawerCommentCell.h
//  MHProject
//
//  Created by 张好志 on 15/6/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//评价律师cell

#import <UIKit/UIKit.h>
#import "StarsView.h"

@interface LawerCommentCell : UITableViewCell

@property(nonatomic,strong)UIButton    *userImageBtn;   //头像
@property(nonatomic,strong)UILabel     *userNameLB;         //名字
@property(nonatomic,strong)StarsView   *startView;
@property(nonatomic,strong)UILabel     *timeLB;        //时间
@property(nonatomic,strong)UILabel     *commentContentLB; //评价律师内容
@property(nonatomic,strong)UILabel     *bottomLineLB;          //下方的线条

+(float)heightForCellWithDict:(NSDictionary *)dict;
-(void)loadCellWithDict:(NSDictionary *)dict;

@end