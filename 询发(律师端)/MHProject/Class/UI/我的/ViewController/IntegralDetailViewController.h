//
//  IntegralDetailViewController.h
//  MHProject
//
//  Created by 张好志 on 15/7/16.
//  Copyright (c) 2015年 Andy. All rights reserved.
//积分明细

#import "BaseViewController.h"

@interface IntegralDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UITableView *pointDetailTableView;
@property (nonatomic,strong)NSMutableArray *pointArray;


@end
