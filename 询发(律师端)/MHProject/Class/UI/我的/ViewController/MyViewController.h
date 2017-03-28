//
//  MyViewController.h
//  MHProject
//
//  Created by 杜宾 on 15/5/11.
//  Copyright (c) 2015年 杜宾. All rights reserved.
//

#import "BaseViewController.h"

@interface MyViewController : BaseViewController
@property (nonatomic,strong) UITableView *myInfoTableView;//我的个人信息列表
@property (nonatomic,strong) NSDictionary *userInfoDict;

@end
