//
//  CategoryDeatilViewController.h
//  MHProject
//
//  Created by 张好志 on 15/7/13.
//  Copyright (c) 2015年 Andy. All rights reserved.
//分类详情列表

#import "BaseViewController.h"

@class QuestionCustomCell;
@interface CategoryDeatilViewController : BaseViewController

@property(strong,nonatomic)PullingRefreshTableView *questionListTableView;
@property(strong,nonatomic)NSMutableArray          *questionListArray;
@property(nonatomic,assign)long                     pageNumber;

@property(nonatomic,strong)NSString *categoryID;

@end
