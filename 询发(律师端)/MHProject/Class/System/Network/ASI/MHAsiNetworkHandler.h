//
//  MHAsiNetworkHandler.h
//  MHProject
//
//  Created by Andy on 15/4/23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHAsiNetworkDefine.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


@class MHAsiNetworkItem;

/**
 *  网络请求Handler类
 */
@interface MHAsiNetworkHandler : NSObject


/**
 *  网络请求项的数组，储存当前正在请求中的那些网络请求项
 */
@property (nonatomic, strong) NSMutableArray *networkItems;

/**
 *  需要显示HUD的网络请求的个数
 */
@property (nonatomic, readonly) NSUInteger showHUDReqCount;


/**
 *  单例
 *
 *  @return BMNetworkHandler的单例对象
 */
+ (MHAsiNetworkHandler *)sharedInstance;


#pragma mark - 取消网络请求
/**
 *  取消网络请求
 *
 *  @param delelgate 网络请求的委托
 *
 *  @return 是否取消成功
 */
- (BOOL)cancelForDelegate:(id)delelgate;


#pragma mark - 添加一个网络请求项
/**
 *  添加一个网络请求项
 *
 *  @param networkItem 网络请求的委托
 */
- (void)addItem:(MHAsiNetworkItem *)networkItem;


#pragma mark - 移除一个网络请求项
/**
 *  移除一个网络请求项
 *
 *  @param networkItem 网络请求的委托
 */
- (void)removeItem:(MHAsiNetworkItem *)networkItem;


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
        failureBlock:(MHAsiFailureBlock)failureBlock;


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
             failureBlock:(MHAsiFailureBlock)failureBlock;


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
               failureBlock:(MHAsiFailureBlock)failureBlock;

@end
