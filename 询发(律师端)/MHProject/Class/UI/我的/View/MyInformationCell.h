//
//  MyInformationCell.h
//  MHProject
//
//  Created by 杜宾 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyInformationCell : UITableViewCell

@property(nonatomic,strong)UILabel *questionLable;

@property(nonatomic,strong)UIView *downLine;

@property(nonatomic,strong)UIView *upLine;

@property(nonatomic,strong)UIImageView *pointView;

@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)UILabel *dateLable;


+(float)heightForCellWithDict:(NSDictionary *)dict;
-(void)loadCellWithDict:(NSDictionary *)dict;


@end
