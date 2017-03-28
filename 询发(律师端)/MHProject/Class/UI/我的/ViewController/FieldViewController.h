//
//  FieldViewController.h
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/14.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "BaseViewController.h"

@interface FieldViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *allFieldsArray;
@property (nonatomic, strong) NSMutableArray *selectedFieldsArray;

@property (nonatomic, strong) NSDictionary *userInfoDict;
@property (nonatomic, copy) void(^saveBlock)(NSMutableArray *selectDictArray);
@end
