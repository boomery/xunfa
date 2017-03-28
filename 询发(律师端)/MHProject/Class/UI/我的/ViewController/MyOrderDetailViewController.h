//
//  MyOrderDetailViewController.h
//  MHProject
//
//  Created by 张好志 on 15/8/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//预约详情

#import "BaseViewController.h"

@interface MyOrderDetailViewController : BaseViewController

//接收从上个我的预约界面传递过来的订单id
@property(nonatomic,strong)NSString *orderID;

@property(nonatomic,copy) void(^ReloadDataBlock)();

@end
