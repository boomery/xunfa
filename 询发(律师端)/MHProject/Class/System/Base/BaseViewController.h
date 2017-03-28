//
//  BaseViewController.h
//  PerfectProject
//
//  Created by DuBin on 14/11/19.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

#pragma mark - 错误提示
/**
 *  错误提示
 *
 *  @param msg 提示的内容
 */
- (void)errorTipHUDByMsg:(NSString *)msg;



#pragma mark -- 自定义的导航条

//#pragma mark - 显示默认的NavBar 左侧返回按钮
/**
 *  显示默认的NavBar
 *
 *  @param navTitle 标题
 *  @param view     显示在指定的view上
 */
- (void)showNavBarDefaultHUDByNavTitle:(NSString *)navTitle
                                inView:(UIView *)view
                                isBack: (BOOL)isBack;

//#pragma mark - 显示导航条上边的右侧返回按钮
/**
 *  显示默认的NavBar
 *
 *  @param navTitle 标题
 *  @param view     显示在指定的view上
 */
- (void)showNavBarWithTwoBtnHUDByNavTitle:(NSString *)navTitle
                               rightTitle:(NSString *)rightTitle
                                   inView:(UIView *)view
                                   isBack:(BOOL)isBack;

- (void)showNavBarWithTwoBtnHUDByNavTitle:(NSString *)navTitle
                                leftImage:(NSString *)leftImage
                                leftTitle:(NSString *)leftTitle
                               rightImage:(NSString *)rightImage
                               rightTitle:(NSString *)rightTitle
                                   inView:(UIView *)view
                                   isBack:(BOOL)isBack;



























//
/**
 *  添加导航栏左边按钮，可能是返回，也可能是其他功能
 *  可能是文字显示也可能是图片
 *  @param img  图片路径
 *  @param text 文字
 */
- (void)addLeftNavBarBtnByImg:(NSString *)img andWithText:(NSString *)text;

// 子类可重写
- (void)leftNavItemClick;

/**
 *  导航栏右按钮
 *
 *  @param img  img  图片路径
 *  @param text text 文字
 */
- (void)addRightNavBarBtnByImg:(NSString *)img andWithText:(NSString *)text;

- (void)addRIghtButtonWithTitle:(NSString *)title;

- (void)rightNavItemClick;

/**
 *  导航栏 的标题
 *
 *  @param title 标题内容
 */
- (void) addNavBarTitle:(NSString *)title;


/**
 *  创建滚动视图
 *
 */
@property (nonatomic, strong) UIScrollView *contentScrollView;
- (void)creatContScrollView;


@end
