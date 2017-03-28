//
//  UserCenterViewController.h
//  MHProject
//
//  Created by 杜宾 on 15/6/24.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "BaseViewController.h"
@class AboutPersonView;
@class UserCenterBtn;
@interface UserCenterViewController : BaseViewController

@property (strong, nonatomic) AboutPersonView *aboutPersonView;
@property (strong, nonatomic) AboutPersonView *caseView;
@property (strong, nonatomic) UserCenterBtn   *userBtn;
@property (strong, nonatomic) NSDictionary    *diction;
@property (nonatomic, copy) void(^reloadBlock)();
@end
