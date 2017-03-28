//
//  CompletedCell.h
//  MHProject
//
//  Created by 杜宾 on 15/8/25.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletedCell : UITableViewCell
@property(nonatomic,strong)UIImageView *userPhotoImage;//头像

@property(nonatomic,strong)UILabel *nameLab;//名字

@property(nonatomic,strong)UILabel *timeLab;//时间

@property(nonatomic,strong)UILabel *contentLale;//内容

@property(nonatomic,strong)UILabel *statusLab;//内容


-(void)loadCompletedCellWithDict:(NSDictionary *)dict;


@end
