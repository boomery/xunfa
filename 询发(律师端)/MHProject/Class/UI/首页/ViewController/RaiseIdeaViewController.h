//
//  RaiseIdeaViewController.h
//  MHProject
//
//  Created by 张好志 on 15/6/21.
//  Copyright (c) 2015年 Andy. All rights reserved.
//出个主意


#import "BaseViewController.h"


#import <QuartzCore/QuartzCore.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import <iflyMSC/IFlySpeechUtility.h>
//无语音控件
#import <iflyMSC/IFlyRecognizerView.h>
#import "RecognizerFactory.h"
#import "ISRDataHelper.h"
#import <iflyMSC/IFlySpeechRecognizerDelegate.h>
#import "PopupView.h"
/**
 无UI语音识别demo
 使用该功能仅仅需要四步
 1.创建识别对象；
 2.设置识别参数；
 3.有选择的实现识别回调；
 4.启动识别
 */

@class QuestionModel;

@interface RaiseIdeaViewController : BaseViewController<IFlyRecognizerViewDelegate>

@property (nonatomic, strong) QuestionModel *questionModel;
@property (nonatomic, strong) NSString *answerID;
//识别对象
@property (nonatomic, strong) IFlyRecognizerView * iflyRecognizerView;
@property (nonatomic, strong) PopupView *popView;
@property (nonatomic, strong) NSString             * result;

//抢答页面进入详情，提交后提示在我的抢答中查看
@property (nonatomic, assign) BOOL isRace;

//接收从上个界面传递的问题字典
@property(nonatomic, strong) NSDictionary *questionDetailDict;

@property (nonatomic, copy) void(^giveIdeaSuccessBlock)();

@end
