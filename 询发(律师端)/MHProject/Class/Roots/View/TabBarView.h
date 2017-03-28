//
//  TabBarView.h
//  PerfectProject
//
//  Created by ZhangHaoZhi on 14/12/12.
//  Copyright (c) 2014年 M.H Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TabBarView;

/**
 *  TabBarView的委托协议
 */
@protocol TabBarViewDelegate <NSObject>
@optional
/**
 *  TabBarView被选中的item
 *
 *  @param tabBarView 当前TabBarView对象
 *  @param index      被选中的item的index
 */
- (void)tabBarView:(TabBarView *)tabBarView didSelectAtIndex:(NSInteger)index;

@end



/**
 *  App下导航栏
 */
@interface TabBarView : UIView

/**
 *  TabBarView对象
 */
@property (nonatomic, assign) id<TabBarViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) UIButton *lastBtn;

@property (nonatomic, strong) UIView *raceRedDot;
@property (nonatomic, strong) UIView *messageRedDot;


- (void)selectTabWithIndex:(NSInteger)index;
//只改变按钮状态
- (void)resetSelectButtonWithIndex:(NSInteger)index;


@end
