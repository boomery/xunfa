//
//  MHSocketHandler.h
//  MHProject
//
//  Created by MengHuan on 15/4/23.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"


/**
 *  Socket通讯Handler类
 */
@interface MHSocketHandler : NSObject <GCDAsyncSocketDelegate>

/**
 *  socket对象
 */
@property (nonatomic, strong) GCDAsyncSocket *socket;


/**
 *  单例
 *
 *  @return BMSocketHandler的单例对象
 */
+ (MHSocketHandler *)sharedInstance;

/**
 *  连接socket
 *
 *  @return 是否连接成功
 */
- (BOOL)connect;

/**
 *  断开socket
 */
- (void)disConnect;

/**
 *  判断socket是否已连接
 *
 *  @return 判断结果
 */
- (BOOL)isConnect;

@end
