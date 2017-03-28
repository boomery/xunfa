//
//  QuestionHuDongViewController.h
//  MHProject
//
//  Created by 张好志 on 15/6/26.
//  Copyright (c) 2015年 Andy. All rights reserved.
//问题互动

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

@class QuestionModel;
@interface QuestionHuDongViewController : BaseViewController

@property (nonatomic,strong)  QuestionModel *questionModel;

//识别对象
@property (nonatomic, strong) IFlyRecognizerView * iflyRecognizerView;
@property (nonatomic, strong) NSString             * result;
@property (nonatomic, strong) PopupView *popView;

//接收从上个界面传递的问题字典
@property(nonatomic, strong) NSDictionary *questionDetailDict;
@property (nonatomic, strong) NSDictionary *answerDict;

//律师只能在点击自己的答案才能与用户互动
@property (nonatomic, assign) BOOL canEdit;

//如果是从消息页面进入的，点击律师头像直接进入个人中心
@property (nonatomic, assign) BOOL isFromNews;

@property (nonatomic, copy) NSString *questionID;

//保存答案的id
@property (nonatomic, copy) NSString *answerID;

//消息页面传来的消息ID，将此ID的消息置为已读
@property (nonatomic, copy) NSString *messageID;
@end
