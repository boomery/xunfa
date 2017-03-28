//
//  ShareView.h
//  BlueMobiProject
//
//  Created by Andy on 15/1/29.
//  Copyright (c) 2015年 Andy All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  分享成功后执行的block
 */
typedef void(^ShareSuccessBlock)(void);

// 新浪分享
typedef void(^SinaBlock)(void);

// 取消分享
typedef void(^CancleBlock)(void);

// 点击屏幕取消
typedef void(^CloseBlock)(void);

/**
 *  分享页面
 */
@interface ShareView : UIView
{
    AppDelegate *_appDelegate;

}
/**
 *  分享的标题
 */
@property (strong, nonatomic) NSString *shareTitle;

/**
 *  分享的简介
 */
@property (strong, nonatomic) NSString *shareDescription;

/**
 *  缩略图
 */
@property (strong, nonatomic) UIImage *shareThumbImage;

/**
 *  分享的链接
 */
@property (nonatomic, copy) NSString *shareURLStr;

@property (nonatomic, retain) UIViewController *controller;

//block
@property (nonatomic, copy) ShareSuccessBlock shareBlock;

@property (nonatomic, copy) SinaBlock sinaBlock;

@property (nonatomic, copy) CancleBlock cancleBlock;

@property (nonatomic, copy) CloseBlock closeBlock;

///imagePath
@property(nonatomic,copy)NSString * imagePath;


/**
 *  分享成功后执行的block
 *
 *  @param block //
 */
- (void)doSomethingAfterShareCompletion:(ShareSuccessBlock)block;

//
- (void)sinaShare:(SinaBlock)completion;

//
- (void)cancleShare:(CancleBlock)completion;

- (void)closeShar:(CloseBlock)completion;

@end
