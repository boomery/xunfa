//
//  AppDelegate.h
//  MHProject
//
//  Created by Andy on 15/4/20.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarController.h"
@interface AppDelegate : UIResponder <
UIApplicationDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate,TabBarViewDelegate >

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) TabBarController *tabBarController;
@property (nonatomic, assign) NSInteger timeCount;

@property (nonatomic, copy) NSString *lastQuestion_ID;
@property (nonatomic, assign) BOOL isAtHome;
@property (nonatomic, copy) NSString *chattingTarget;
@property (nonatomic, copy) NSString *chattingQuestion;

@property (nonatomic, strong) UINavigationController *welComeNav;

+ (AppDelegate *)appDelegate;

-(void)changeMainController;
@end

