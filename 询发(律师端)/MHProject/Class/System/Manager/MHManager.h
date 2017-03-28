//
//  MHManager.h
//  MHProject
//
//  Created by DuBin on 15/5/13.
//  Copyright (c) 2015年 DuBin. All rights reserved.
//

#ifndef MHProject_MHManager_h
#define MHProject_MHManager_h


#import "StoreKitManager.h"
#import "JsonManager.h"
#import "CMManager.h"
#import "SoundManager.h"
#import "TSRegularExpressionUtil.h"
#import "NSString+blankString.h"
#import "MHAsiNetworkUrl.h"
#import "PullingRefreshTableView.h"
#import "MBProgressManager.h"
#import "DataHander.h"
#import "MobClick.h"

//宏定义AlertView
#define SHOW_ALERT(_message_) UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:_message_ delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]; \
[alert show];


#define ProgressShowText(showText, showView)   [MBProgressManager ShowWithText:showText fromView:showView]
#define ProgressHid(hidView)   [MBProgressManager hidFormView:hidView]
#define ProgressShoLoading(showView)    [MBProgressManager SHowLoadingToView:showView]
#define ProgressHidWithDelay(showView,delay)    [MBProgressManager hidFormView:showView afterDelay:delay]


#define ShowLoadingView(showView,title)    [MBProgressManager showLoadingToView: showView WithTitle:NSLocalizedString(title, nil)]
#define HiddenLoadingView(showView)    [MBProgressManager hidLoadingFormView:showView]



#endif
