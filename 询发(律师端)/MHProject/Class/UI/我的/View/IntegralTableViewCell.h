//
//  IntegralTableViewCell.h
//  MHProject
//
//  Created by 张好志 on 15/7/23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel     *titleLB;
@property(nonatomic,strong)UILabel     *dateLB;
@property(nonatomic,strong)UILabel     *balanceLB;
@property(nonatomic,strong)UILabel     *integralCountLB;

+(float)heightForCellWithDict:(NSDictionary *)dict;
-(void)loadCellWithDict:(NSDictionary *)dict;

#pragma mark -- 积点
-(void)loadCellWithDotDict:(NSDictionary *)dict;


@end
