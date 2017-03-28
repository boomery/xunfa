//
//  ProfessionalInformationViewController.h
//  MHProject
//
//  Created by 张好志 on 15/7/14.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "BaseViewController.h"

@interface ProfessionalInformationViewController : BaseViewController

@property (nonatomic, strong) NSDictionary *userInfoDict;
@property (nonatomic, copy) void(^saveBlock)();

@end
