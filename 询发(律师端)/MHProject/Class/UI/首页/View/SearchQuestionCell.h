//
//  SearchQuestionCell.h
//  MHProject
//
//  Created by 杜宾 on 15/6/27.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeStagCustomView;
@interface SearchQuestionCell : UITableViewCell
@property(nonatomic,strong)UILabel *questionLable;

@property(nonatomic,strong)HomeStagCustomView *left;

@property(nonatomic,strong)HomeStagCustomView *right;

@property(nonatomic,strong)UILabel *dateLable;

+(float)heightForCellWithDict:(NSDictionary *)dict;
-(void)loadCellWithDict:(NSDictionary *)dict;



@end
