//
//  MHViewDefine.h
//  PerfectProject
//
//  Created by DuBin on 14/12/3.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#ifndef PerfectProject_MHViewDefine_h
#define PerfectProject_MHViewDefine_h
#import "UIView+FitAllScreen.h"
/**
 *	获取视图宽度
 *
 *	@param 	view 	视图对象
 *
 *	@return	宽度
 */
#define DEF_WIDTH(view) view.bounds.size.width

/**
 *	获取视图高度
 *
 *	@param 	view 	视图对象
 *
 *	@return	高度
 */
#define DEF_HEIGHT(view) view.bounds.size.height

/**
 *	获取视图原点横坐标
 *
 *	@param 	view 	视图对象
 *
 *	@return	原点横坐标
 */
#define DEF_LEFT(view) view.frame.origin.x

/**
 *	获取视图原点纵坐标
 *
 *	@param 	view 	视图对象
 *
 *	@return	原点纵坐标
 */
#define DEF_TOP(view) view.frame.origin.y

/**
 *	获取视图右下角横坐标
 *
 *	@param 	view 	视图对象
 *
 *	@return	右下角横坐标
 */
#define DEF_RIGHT(view) (DEF_LEFT(view) + DEF_WIDTH(view))

/**
 *	获取视图右下角纵坐标
 *
 *	@param 	view 	视图对象
 *
 *	@return	右下角纵坐标
 */
#define DEF_BOTTOM(view) (DEF_TOP(view) + DEF_HEIGHT(view))

/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

/**
 *  主屏的size
 */
#define DEF_SCREEN_SIZE   [[UIScreen mainScreen] bounds].size

/**
 *  主屏的frame
 */
#define DEF_SCREEN_FRAME  [UIScreen mainScreen].applicationFrame

/**
 *	生成RGB颜色
 *
 *	@param 	red 	red值（0~255）
 *	@param 	green 	green值（0~255）
 *	@param 	blue 	blue值（0~255）
 *
 *	@return	UIColor对象
 */
#define DEF_RGB_COLOR(_red, _green, _blue) [UIColor colorWithRed:(_red)/255.0f green:(_green)/255.0f blue:(_blue)/255.0f alpha:1]

/**
 *	生成RGBA颜色
 *
 *	@param 	red 	red值（0~255）
 *	@param 	green 	green值（0~255）
 *	@param 	blue 	blue值（0~255）
 *	@param 	alpha 	blue值（0~1）
 *
 *	@return	UIColor对象
 */
#define DEF_RGBA_COLOR(_red, _green, _blue, _alpha) [UIColor colorWithRed:(_red)/255.0f green:(_green)/255.0f blue:(_blue)/255.0f alpha:(_alpha)]

/**
 *	生成RGB颜色
 *
 *	@param 	rgb 	RGB颜色值（必须0x开头，例如:0xffffff）
 *
 *	@return	UIColor对象
 */
#define DEF_RGB_INT_COLOR(rgb) [UIColor colorWithRGB:rgb]

/**
 *	生成RGBA颜色
 *
 *	@param 	string 	颜色描述字符串，带“＃”开头
 *
 *	@return	UIColor对象
 */
#define DEF_STRING_COLOR(string) [UIColor colorWithString:string]

/**
 *  判断屏幕尺寸是否为640*1136 5s,5
 *
 *	@return	判断结果（YES:是 NO:不是）
 */
#define DEF_SCREEN_IS_5s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)



/**
 *  判断屏幕尺寸是否为750*1334  6
 *
 *	@return	判断结果（YES:是 NO:不是）
 */
#define DEF_SCREEN_IS_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  判断屏幕尺寸是否为1080*1920 6plus
 *
 *	@return	判断结果（YES:是 NO:不是）
 */

#define DEF_SCREEN_IS_6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1080, 1920), [[UIScreen mainScreen] currentMode].size) : NO)


// 线条宽度
#define LINE_HEIGTH DEF_SCREEN_IS_6plus ? 1.0/3.0 : 1.0/2.0


//按比例算

#define width(float) float/320.0*DEF_SCREEN_WIDTH

#define height(float) float/568.0*DEF_SCREEN_HEIGHT

#define TRANSFORM_HEIGHT(height) [UIView transformHeight:height]
#define TRANSFORM_WIDTH(width) [UIView transformWidth:width]

#define FONT DEF_Font(DEF_SCREEN_WIDTH == 320.0 ? 14.0 : 16.0)

#define LINE_HEIGHT (DEF_SCREEN_IS_6plus ? 1/3.0:1/2.0)
//问题的字体颜色

#define  QuestionColor DEF_RGB_COLOR(100, 99, 105)

#define  NameColor     DEF_RGB_COLOR(142, 147, 147)

#define  LeftStagColor DEF_RGB_COLOR(0, 160, 233);

#define RightIdearColoe DEF_RGB_COLOR(178, 196, 205);
#endif
