//
//  QuestionListDetailViewController.h
//  MHProject
//
//  Created by 张好志 on 15/7/6.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "BaseViewController.h"
@class HeaderView;

@interface QuestionListDetailViewController : BaseViewController

@property (nonatomic, strong) HeaderView *headerView;
@property (strong, nonatomic) UITableView *questionDetalTableView;
//接收上一个界面传递的问题
@property (nonatomic, strong) NSDictionary *questionDetailDict;

@property(nonatomic,strong) NSString *questionID;

@property (nonatomic ,strong) void(^reloadBlock)();

@end
