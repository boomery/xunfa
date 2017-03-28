//
//  SearchListViewController.h
//  MHProject
//
//  Created by 杜宾 on 15/6/27.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "BaseViewController.h"
#import <iflyMSC/IFlySpeechConstant.h>
#import <iflyMSC/IFlySpeechUtility.h>
#import "RecognizerFactory.h"
#import "ISRDataHelper.h"
#import <iflyMSC/IFlySpeechRecognizerDelegate.h>
#import <iflyMSC/IFlyRecognizerView.h>
#import "PopupView.h"

/**
 无UI语音识别demo
 使用该功能仅仅需要四步
 1.创建识别对象；
 2.设置识别参数；
 3.有选择的实现识别回调；
 4.启动识别
 */

@interface SearchListViewController : BaseViewController<IFlyRecognizerViewDelegate>

//识别对象
@property (nonatomic, strong) IFlyRecognizerView   *iflyRecognizerView;
@property (nonatomic, strong) PopupView            *popView;
@property (nonatomic, strong) NSString             *result;

@property(strong,nonatomic)PullingRefreshTableView *questionListTableView;
@property (nonatomic,assign) long pageNumber;

@end
