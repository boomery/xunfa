//
//  PointDetailCell.h
//  MHProject
//
//  Created by 张好志 on 15/7/7.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointDetailCell : UITableViewCell

@property(nonatomic,strong)UIImageView *pointView;
@property(nonatomic,strong)UIView      *upLine;
@property(nonatomic,strong)UIView      *downLine;
@property(nonatomic,strong)UILabel     *dateLable;

@property(nonatomic,strong)UIView      *pointBgView;
@property(nonatomic,strong)UILabel     *pointLB;
@property(nonatomic,strong)UIView      *detailBgView;
@property(nonatomic,strong)UILabel     *pointDetailLB;

+(float)heightForCellWithDict:(NSDictionary *)dict;
-(void)loadCellWithDict:(NSDictionary *)dict;


-(void)loadCellWithPointDict:(NSDictionary *)dict;


@end
