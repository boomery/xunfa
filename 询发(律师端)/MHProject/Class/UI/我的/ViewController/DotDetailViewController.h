//
//  PointDetailViewController.h
//  MHProject
//
//  Created by 张好志 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//积点明细

#import "BaseViewController.h"

@interface DotDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UITableView *pointDetailTableView;
@property (nonatomic,strong)NSMutableArray *pointArray;

@end
