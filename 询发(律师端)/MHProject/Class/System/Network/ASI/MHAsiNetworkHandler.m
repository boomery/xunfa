//
//  MHAsiNetworkHandler.m
//  MHProject
//
//  Created by Andy on 15/4/23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MHAsiNetworkHandler.h"
#import "MHAsiNetworkItem.h"

@implementation MHAsiNetworkHandler

+ (MHAsiNetworkHandler *)sharedInstance
{
    static MHAsiNetworkHandler *handler = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        handler = [[MHAsiNetworkHandler alloc] init];
    });
    
    return handler;
}

#pragma mark - 取消网络请求
/**
 *  取消网络请求
 *
 *  @param delelgate 网络请求的委托
 *
 *  @return 是否取消成功
 */
- (BOOL)cancelForDelegate:(id)delelgate
{
    NSUInteger hashValue = [delelgate hash];
    
    BOOL flag = NO;
    
    for (MHAsiNetworkItem *item in self.networkItems)
    {
        if (item.hashValue == hashValue)
        {
            [self removeItem:item];
            flag = YES;
        }
    }
    
    return flag;
}


#pragma mark - 添加一个网络请求项
/**
 *  添加一个网络请求项
 *
 *  @param networkItem 网络请求的委托
 */
- (void)addItem:(MHAsiNetworkItem *)networkItem
{
    if (networkItem.showHUD)
    {
        _showHUDReqCount++;
        
        if (_showHUDReqCount == 1)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MHAsi_SHOW_HUD object:nil];
        }
    }
    
    [self.networkItems addObject:networkItem];
}


#pragma mark - 移除一个网络请求项
/**
 *  移除一个网络请求项
 *
 *  @param networkItem 网络请求的委托
 */
- (void)removeItem:(MHAsiNetworkItem *)networkItem
{
    if (networkItem.showHUD)
    {
        _showHUDReqCount--;
        
        if (_showHUDReqCount == 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MHAsi_HIDE_HUD object:nil];
        }
    }
    
    [networkItem.httpRequest clearDelegatesAndCancel];
    [self.networkItems removeObject:networkItem];
}


#pragma mark - 创建一个网络请求项
/**
 *  创建一个网络请求项
 *
 *  @param url          网络请求URL
 *  @param networkType  网络请求方式
 *  @param params       网络请求参数
 *  @param delegate     网络请求的委托，如果没有取消网络请求的需求，可传nil
 *  @param showHUD      是否显示HUD
 *  @param successBlock 请求成功后的block
 *  @param failureBlock 请求失败后的block
 *
 *  @return 根据网络请求的委托delegate而生成的唯一标示
 */
- (NSUInteger)conURL:(NSString *)url
         networkType:(MHAsiNetWorkType)networkType
              params:(NSMutableDictionary *)params
            delegate:(id)delegate
             showHUD:(BOOL)showHUD
        successBlock:(MHAsiSuccessBlock)successBlock
        failureBlock:(MHAsiFailureBlock)failureBlock
{
    /// 如果有一些公共处理，可以写在这里

#if DEBUG_LOG
    NSLog(@"网络请求接口url:%@", url);
    
    NSLog(@"MHAsi网络请求params:%@", params);
#endif
    
    NSUInteger hashValue = [delegate hash];
    MHAsiNetworkItem *item = [[MHAsiNetworkItem alloc] initWithtype:networkType
                                                                url:url
                                                             params:params
                                                           delegate:delegate
                                                          hashValue:hashValue
                                                            showHUD:showHUD
                                                       successBlock:successBlock
                                                       failureBlock:failureBlock];
    return item.hashValue;
}


#pragma mark - 创建一个下载的网络请求项
/**
 *  创建一个下载的网络请求项
 *
 *  @param url          下载地址URL
 *  @param delegate     网络请求的委托，如果没有取消网络请求的需求，可传nil
 *  @param startBlock   请求开始后的block
 *  @param successBlock 请求成功后的block
 *  @param failureBlock 请求失败后的block
 *
 *  @return 根据网络请求的委托delegate而生成的唯一标示
 */
- (NSUInteger)downloadURL:(NSString *)url
                 delegate:(id)delegate
               startBlock:(MHAsiStartBlock)startBlock
             successBlock:(MHAsiSuccessBlock)successBlock
             failureBlock:(MHAsiFailureBlock)failureBlock
{
#if DEBUG_LOG
    NSLog(@"BM网络下载url:%@", url);
#endif
    
    NSUInteger hashValue = [delegate hash];
    MHAsiNetworkItem *item = [[MHAsiNetworkItem alloc] initDownloadWithtype:MHAsiNetWorkPOST
                                                                        url:url
                                                                   delegate:delegate
                                                                  hashValue:hashValue
                                                                 startBlock:startBlock
                                                               successBlock:successBlock
                                                               failureBlock:failureBlock];
    return item.hashValue;
}


#pragma mark - 创建一个上传的网络请求项
/**
 *  创建一个上传的网络请求项
 *
 *  @param url              上传地址URL
 *  @param networkType      网络请求方式
 *  @param params           网络请求参数
 *  @param fileDataparams   上传的文件参数
 *  @param userInfo         可以设置一个上下文userInfo到request对象中，当请求响应完后可以通过访问request对象的userInfo获取里面的信息，可传nil
 *  @param delegate         网络请求的委托，如果没有取消网络请求的需要，可传nil
 *  @param showHUD          是否显示HUD
 *  @param successBlock     请求成功后的block
 *  @param failureBlock     请求失败后的block
 *
 *  @return 根据网络请求的委托delegate而生成的唯一标示
 */
- (NSUInteger)uploadFileURL:(NSString *)url
                networkType:(MHAsiNetWorkType)networkType
                     params:(NSMutableDictionary *)params
             fileDataparams:(NSMutableDictionary *)fileDataparams
               withUserInfo:(NSMutableDictionary *)userInfo
                   delegate:(id)delegate
                    showHUD:(BOOL)showHUD
               successBlock:(MHAsiSuccessBlock)successBlock
               failureBlock:(MHAsiFailureBlock)failureBlock
{
#if DEBUG_LOG
    NSLog(@"BM网络请求接口uploadFile－－>url--->:%@", url);
    NSLog(@"BM网络请求uploadFile－－>params--->:%@", params);
#endif
    
    NSUInteger hashValue = [delegate hash];
    MHAsiNetworkItem *item = [[MHAsiNetworkItem alloc]initUploadFileWithtype:networkType
                                                                         url:url
                                                                      params:params
                                                              fileDataparams:fileDataparams
                                                                withUserInfo:userInfo
                                                                    delegate:delegate
                                                                   hashValue:hashValue
                                                                     showHUD:showHUD
                                                                successBlock:successBlock
                                                                failureBlock:failureBlock];
    
    return item.hashValue;
}

@end
