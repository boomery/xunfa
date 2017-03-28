//
//  MHAsiNetworkItem.h
//  MHProject
//
//  Created by Andy on 15/4/23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHAsiNetworkDefine.h"
#import "ASIHTTPRequest.h"

/**
 *  网络请求子项
 */
@interface MHAsiNetworkItem : NSObject


/**
 *  网络请求方式
 */
@property (nonatomic, assign) MHAsiNetWorkType networkType;

/**
 *  网络请求URL
 */
@property (nonatomic, strong) NSString *url;

/**
 *  网络请求参数
 */
@property (nonatomic, strong) NSDictionary *params;

/**
 *  网络请求的委托
 */
@property (nonatomic, assign) id delegate;

/**
 *  网络请求的委托delegate的唯一标示，因为delegate不能直接作为Key，所以转化了一步，用hashValue代替
 */
@property (nonatomic, assign) NSUInteger hashValue;

/**
 *  是否显示HUD
 */
@property (nonatomic, assign) BOOL showHUD;

/**
 *  MHConnItem对象中封装的ASIHTTPRequest成员变量
 */
@property (nonatomic, strong) ASIHTTPRequest *httpRequest;


#pragma mark - 创建一个网络请求项，开始请求网络
/**
 *  创建一个网络请求项，开始请求网络
 *
 *  @param networkType  网络请求方式
 *  @param url          网络请求URL
 *  @param params       网络请求参数
 *  @param delegate     网络请求的委托，如果没有取消网络请求的需求，可传nil
 *  @param hashValue    网络请求的委托delegate的唯一标示
 *  @param showHUD      是否显示HUD
 *  @param successBlock 请求成功后的block
 *  @param failureBlock 请求失败后的block
 *
 *  @return MHAsiNetworkItem对象
 */
- (MHAsiNetworkItem *)initWithtype:(MHAsiNetWorkType)networkType
                               url:(NSString *)url
                            params:(NSDictionary *)params
                          delegate:(id)delegate
                         hashValue:(NSUInteger)hashValue
                           showHUD:(BOOL)showHUD
                      successBlock:(MHAsiSuccessBlock)successBlock
                      failureBlock:(MHAsiFailureBlock)failureBlock;


#pragma mark - 创建一个下载的网络请求项，开始请求网络
/**
 *  创建一个下载的网络请求项，开始请求网络
 *
 *  @param networkType  网络请求方式
 *  @param url          网络请求URL
 *  @param params       网络请求参数
 *  @param delegate     网络请求的委托，如果没有取消网络请求的需求，可传nil
 *  @param hashValue    网络请求的委托delegate的唯一标示
 *  @param startBlock   请求开始后的block
 *  @param successBlock 请求成功后的block
 *  @param failureBlock 请求失败后的block
 *
 *  @return MHAsiNetworkItem对象
 */
- (MHAsiNetworkItem *)initDownloadWithtype:(MHAsiNetWorkType)networkType
                                       url:(NSString *)url
                                  delegate:(id)delegate
                                 hashValue:(NSUInteger)hashValue
                                startBlock:(MHAsiStartBlock)startBlock
                              successBlock:(MHAsiSuccessBlock)successBlock
                              failureBlock:(MHAsiFailureBlock)failureBlock;


#pragma mark - 创建一个上传的网络请求项，开始请求网络
/**
 *  创建一个上传的网络请求项，开始请求网络
 *
 *  @param networkType      网络请求方式
 *  @param url              网络请求URL
 *  @param params           网络请求参数
 *  @param fileDataparams   网络请求文件参数
 *  @param userInfo         可以设置一个上下文userInfo到request对象中，当请求响应完后可以通过访问request对象的userInfo获取里面的信息，可传nil
 *  @param delegate         网络请求的委托，如果没有取消网络请求的需求，可传nil
 *  @param hashValue        网络请求的委托delegate的唯一标示
 *  @param successBlock     请求成功后的block
 *  @param failureBlock     请求失败后的block
 *
 *  @return MHAsiNetworkItem对象
 */
- (MHAsiNetworkItem *)initUploadFileWithtype:(MHAsiNetWorkType)networkType
                                         url:(NSString *)url
                                      params:(NSDictionary *)params
                              fileDataparams:(NSDictionary *)fileDataparams
                                withUserInfo:(NSDictionary *)userInfo
                                    delegate:(id)delegate
                                   hashValue:(NSUInteger)hashValue
                                     showHUD:(BOOL)showHUD
                                successBlock:(MHAsiSuccessBlock)successBlock
                                failureBlock:(MHAsiFailureBlock)failureBlock;

@end
