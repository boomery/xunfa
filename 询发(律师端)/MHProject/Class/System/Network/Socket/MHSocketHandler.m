//
//  MHSocketHandler.m
//  MHProject
//
//  Created by MengHuan on 15/4/23.
//  Copyright (c) 2015年 MengHuan. All rights reserved.
//

#import "MHSocketHandler.h"


/**
 *  Socket的HOST
 */
#define SOCKET_HOST @"121.41.91.65"

/**
 *  Socket的PORT
 */
#define SOCKET_PORT 6666

/**
 *  socket连接超时的时间
 */
#define SOCKET_TIME_OUT 60


@implementation MHSocketHandler


+ (MHSocketHandler *)sharedInstance
{
    static MHSocketHandler * handler = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        handler = [[MHSocketHandler alloc] init];
    });
    
    return handler;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                                 delegateQueue:dispatch_get_main_queue()
                       ];
    }
    return self;
}

/**
 *  连接socket
 *
 *  @return 是否连接成功
 */
- (BOOL)connect
{
    BOOL result = NO;
    if (![self isConnect])
    {
        NSError *error = nil;
        result = [self.socket connectToHost:SOCKET_HOST onPort:SOCKET_PORT error:&error];
        if (error != nil || !result)
        {
            DEF_DEBUG(@"connect fail!");
        }
        else
        {
            DEF_DEBUG(@"connect success!");
        }
    }
    
    return result;
}

/**
 *  断开socket
 */
- (void)disConnect
{
    if ([self isConnect])
    {
        [self.socket disconnect];
    }
}

/**
 *  判断socket是否已连接
 *
 *  @return 判断结果
 */
- (BOOL)isConnect
{
    return self.socket.isConnected;
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"didConnectToHost: %@, port:%d", host, port);
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"didWriteDataWithTag: %li", tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"didReadData: %@, tag:%li", data, tag);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"withError: %@", err);
}

@end
