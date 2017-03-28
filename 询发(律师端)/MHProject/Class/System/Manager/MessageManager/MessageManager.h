//
//  MessageManager.h
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/31.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageManager : NSObject

+ (MessageManager *)sharedMessageManager;

+ (void)addNewUnreadMessage;

+ (void)minusUnreadMessage;

+ (void)setUnreadMessageWithNumber:(NSString *)number;

+ (void)setUnreadMessageWithNSInetgerNumber:(NSInteger)number;

+ (BOOL)shouldHideRedDot;
@end
