//
//  XYAlertViewHeader.h
//
//  Created by Andy on 7/27/12.
//  Copyright (c) 2012 Telenavsoftware. All rights reserved.
//

#ifndef XYAlertViewDemo_XYAlertViewHeader_h
#define XYAlertViewDemo_XYAlertViewHeader_h

#import "XYAlertView.h"
#import "XYLoadingView.h"
#import "XYAlertViewManager.h"

//#define XYShowAlert(_MSG_) [[XYAlertViewManager sharedAlertViewManager] showAlertView:_MSG_]
#define XYShowAlert(_MSG_,_BUTTON_) [[XYAlertViewManager sharedAlertViewManager] showAlertView:_MSG_ btnTitle:_BUTTON_]

//[XYAlertViewManager sharedAlertViewManager] sho
#define XYShowLoading(_MSG_) [[XYAlertViewManager sharedAlertViewManager] showLoadingView:_MSG_]

#endif
