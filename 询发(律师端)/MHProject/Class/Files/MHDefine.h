//
//  MHDefine.h
//  PerfectProject
//
//  Created by DuBin on 14/12/3.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//




#import "MHLogDefine.h"
#import "MHPathDefine.h"
#import "MHViewDefine.h"
#import "MHLabelDefine.h"
#import "MHPersistentDefine.h"
#import "MHNotificationDefine.h"

#import "XYAlertViewHeader.h"

#ifndef PerfectProject_MHDefine_h
#define PerfectProject_MHDefine_h

// 底部TabBar的高度
#define DEF_TAB_BAR_HEIGHT 50

/**
 *  在此处定义宏
 */

// 此App中使用的自定义字体名称
#define DEF_Font_DFShaoNvW5     @"DFShaoNvW5"
#define DEF_Font_8              @"8"
#define DEF_Font_akaDylanPlain  @"akaDylanPlain"
#define DEF_Font_MBXS           @"2.0-"



//字号

#define DEF_Font(float) [UIFont systemFontOfSize:float];

// 5s
#define DEF_Font_5s [UIFont systemFontOfSize:14];

// 6s
#define DEF_Font_6s [UIFont systemFontOfSize:16];

// 6plus
#define DEF_Font_6plus [UIFont systemFontOfSize:18];




// 判断是否为3.5屏
#define DEF_640_960 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define DEF_640_1136 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


#endif
