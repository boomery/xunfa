//
//  MessageManager.m
//  MHProject
//
//  Created by ZhangChaoxin on 15/7/31.
//  Copyright (c) 2015年 Andy. All rights reserved.
//
#define UNREAD_MESSAGE_KEY @"UNREAD_MESSAGE_KEY"
#import "AppDelegate.h"
#import "MessageManager.h"
@implementation MessageManager

+ (MessageManager *)sharedMessageManager
{
    static MessageManager *messageManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageManager = [[self alloc] init];
    });
    return messageManager;
}
+ (void)addNewUnreadMessage
{
    NSNumber *number = DEF_PERSISTENT_GET_OBJECT(UNREAD_MESSAGE_KEY);
    if (number)
    {
        NSInteger num = [number integerValue];
        num ++;
        [self setUnreadMessageWithNSInetgerNumber:num];
    }
    else
    {
        [self setUnreadMessageWithNSInetgerNumber:1];
    }
}

+ (void)setUnreadMessageWithNumber:(NSString *)number
{
    NSInteger num = [number integerValue];
    [self setUnreadMessageWithNSInetgerNumber:num];
}

+ (void)minusUnreadMessage
{
    NSNumber *number = DEF_PERSISTENT_GET_OBJECT(UNREAD_MESSAGE_KEY);
    if (number)
    {
        NSInteger num = [number integerValue];
        if (num != 0)
        {
            num --;
        }
        [self setUnreadMessageWithNSInetgerNumber:num];
    }
    else
    {
        [self setUnreadMessageWithNSInetgerNumber:0];
    }
}

+ (void)setUnreadMessageWithNSInetgerNumber:(NSInteger)number
{
    AppDelegate *delegate = [AppDelegate appDelegate];
    if (number == 0)
    {
        delegate.tabBarController.tabBarView.messageRedDot.hidden = YES;
    }
    else
    {
        delegate.tabBarController.tabBarView.messageRedDot.hidden = NO;
    }
    DEF_PERSISTENT_SET_OBJECT([NSNumber numberWithInteger:number], UNREAD_MESSAGE_KEY);
}

+ (BOOL)shouldHideRedDot
{
    NSNumber *number = DEF_PERSISTENT_GET_OBJECT(UNREAD_MESSAGE_KEY);
    if (number)
    {
        NSInteger num = [number integerValue];
        if (num > 0)
        {
            return NO;
        }
    }
    return YES;
}
@end
