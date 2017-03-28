//
//  MHAsiNetworkItem.m
//  MHProject
//
//  Created by Andy on 15/4/23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MHAsiNetworkItem.h"
#import "MHAsiNetworkHandler.h"
#import "JsonManager.h"
#import "NSString+MHCommon.h"
#import "ASIFormDataRequest.h"
#import "DataHander.h"
#import "ASIDownloadCache.h"
@implementation MHAsiNetworkItem


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
                      failureBlock:(MHAsiFailureBlock)failureBlock
{
    if (self = [super init])
    {
        self.networkType    = networkType;
        self.url            = url;
        self.params         = params;
        self.delegate       = delegate;
        self.hashValue      = hashValue;
        self.showHUD        = showHUD;
        
        if (networkType == MHAsiNetWorkGET)
        {
            NSMutableString *requestStr = [[NSMutableString alloc] init];
            NSEnumerator *enumerator    = [params keyEnumerator];
            id paramKey                 = nil;
            if ((paramKey = [enumerator nextObject]))
            {
                [requestStr appendFormat:@"?%@=%@",paramKey,[params objectForKey:paramKey]];
            }
            while ((paramKey = [enumerator nextObject]))
            {
                [requestStr appendFormat:@"&%@=%@",paramKey,[params objectForKey:paramKey]];
            }
            
            // 传cookie
//            [self.httpRequest setRequestCookies:<#(NSMutableArray *)#>]
            
            // 传header头
//            [self.httpRequest setRequestHeaders:<#(NSMutableDictionary *)#>];
            
            
            self.httpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url,requestStr]]];
            [self.httpRequest setRequestMethod:@"GET"];
        }
        else if (networkType == MHAsiNetWorkPOST)
        {
            self.httpRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.url]];
            [self.httpRequest setRequestMethod:@"POST"];
            
            
            // 传cookie
//            [self.httpRequest setRequestCookies:<#(NSMutableArray *)#>]
            
            // 传header头
//            [self.httpRequest setRequestHeaders:<#(NSMutableDictionary *)#>];
            
            ASIFormDataRequest *form    = (ASIFormDataRequest *) self.httpRequest;
            NSEnumerator *enumerator    = [params keyEnumerator];
            id paramKey                 = nil;
            while ((paramKey = [enumerator nextObject]))
            {
                [form setPostValue:[params objectForKey:paramKey] forKey:paramKey];
            }
        }
        
        if (showHUD) {
            [DataHander  showDlg];
        }
        
        __weak ASIHTTPRequest *weekHttpRequest  = self.httpRequest;
        __weak MHAsiNetworkItem *weekSelf       = self;
        
        self.httpRequest.timeOutSeconds         = MHAsi_API_TIME_OUT;
        
        // 成功
        [self.httpRequest setCompletionBlock:^(void){
            if (showHUD) {
                [DataHander  hideDlg];
            }
            NSString *responseString = [[NSString alloc] initWithData:weekHttpRequest.responseData
                                                             encoding:NSUTF8StringEncoding
                                        ];
#if DEBUG
//            NSLog(@"BM网络请求接口url:%@的回返数据 responseString:\n%@", url, responseString);
#endif
            // 如果是.net后台返回数据，并且json数据有xml包着的话，请释放这一句
//            responseString = [responseString ignoreDotNetSpecialString];
            
            // 如果返回值有html特殊字符，请释放这一句
//            responseString = [responseString ignoreHTMLSpecialString];
            id returnData = [JsonManager JSONValue:responseString];
            if (successBlock)
            {
                successBlock(returnData);
            }
            // 请求结束，移除该网络请求项
            [[MHAsiNetworkHandler sharedInstance] removeItem:weekSelf];
        }];
        
        // 失败
        [self.httpRequest setFailedBlock:^(void) {
//            if (showHUD) {
//                [[DataHander sharedDataHander] hideDlg];
//            }

#if DEBUG
            NSLog(@"BM网络请求接口url:%@访问错误 error:\n%@", url, weekHttpRequest.error);
#endif
            [DataHander  showErrorWithTitle:@"亲，网络通讯异常"];
            if (failureBlock)
            {
                failureBlock(weekHttpRequest.error);
            }
            
            // 请求结束，移除该网络请求项
            [[MHAsiNetworkHandler sharedInstance] removeItem:weekSelf];
        }];
        
        // 添加网络请求项，开始异步请求
        [[MHAsiNetworkHandler sharedInstance] addItem:self];
        [self.httpRequest startAsynchronous];
        
        // 如需同步请求，重写此方法
//        [self.httpRequest startSynchronous];
    }
    
    return self;
}


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
                              failureBlock:(MHAsiFailureBlock)failureBlock
{
    if (self = [super init])
    {
        self.networkType    = networkType;
        self.url            = url;
        self.delegate       = delegate;
        self.hashValue      = hashValue;
        
        if (networkType == MHAsiNetWorkGET)
        {
            self.httpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.url]];
            [self.httpRequest setRequestMethod:@"GET"];
        }
        else if (networkType == MHAsiNetWorkPOST)
        {
            self.httpRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.url]];
            [self.httpRequest setRequestMethod:@"POST"];
        }
        
        [self.httpRequest setShowAccurateProgress:YES];
        [self.httpRequest setDownloadProgressDelegate:delegate];
        [self.httpRequest setDefaultResponseEncoding:NSUTF8StringEncoding];
        
        __weak ASIHTTPRequest *weekHttpRequest  = self.httpRequest;
        __weak MHAsiNetworkItem *weekSelf       = self;
        
        // 开始下载
        [self.httpRequest setStartedBlock:^(void){
            
#if DEBUG
            NSLog(@"BM网络下载url:%@开始下载 ", url);
#endif
            
            if (startBlock) {
                startBlock();
            }
        }];
        
        // 下载成功
        [self.httpRequest setCompletionBlock:^(void){
            
#if DEBUG
            NSLog(@"BM网络下载url:%@下载完成 ", url);
#endif
            
            if (successBlock) {
                successBlock(weekHttpRequest.responseData);
            }
            
            [[MHAsiNetworkHandler sharedInstance] removeItem:weekSelf];
        }];
        
        // 下载失败
        [self.httpRequest setFailedBlock:^(void) {
            
#if DEBUG
            NSLog(@"BM网络下载url:%@下载失败 error:\n%@", url, weekHttpRequest.error);
#endif
            if (failureBlock) {
                failureBlock(weekHttpRequest.error);
            }
            
            [[MHAsiNetworkHandler sharedInstance] removeItem:weekSelf];
        }];
        
        [[MHAsiNetworkHandler sharedInstance] addItem:self];
        [self.httpRequest startAsynchronous];
    }
    
    return self;
}


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
                                failureBlock:(MHAsiFailureBlock)failureBlock
{
    if (self = [super init])
    {
        self.networkType    = networkType;
        self.url            = url;
        self.params         = params;
        self.delegate       = delegate;
        self.hashValue      = hashValue;
        self.showHUD        = showHUD;
        
#if DEBUG
        NSLog(@"BM网络请求接口url------->:%@", url);
        NSLog(@"BM网络请求接口params------->:%@", params);
#endif
        
        if (networkType == MHAsiNetWorkPOST)
        {
            // add
            if (userInfo != nil)
            {
                self.httpRequest.userInfo = userInfo;
            }
            
            self.httpRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:self.url]];
            [self.httpRequest setRequestMethod:@"POST"];
            
            ASIFormDataRequest *form    = (ASIFormDataRequest *)self.httpRequest;
            NSEnumerator *enumerator    = [params keyEnumerator];
            id paramKey                 = nil;
            while ((paramKey = [enumerator nextObject]))
            {
                [form setPostValue:[params objectForKey:paramKey] forKey:paramKey];
            }
            
            // 设置file
            NSEnumerator *fileDataEnumerator = [fileDataparams keyEnumerator];
            id fileDataparamKey = nil;
            
            int i = 0;
            while ((fileDataparamKey = [fileDataEnumerator nextObject]))
            {
                i++;
                
                NSString *fileName = [NSString stringWithFormat:@"myphoto%d.jpg",i];
                
                [form addData:[fileDataparams objectForKey:fileDataparamKey]
                 withFileName:fileName
               andContentType:@"multipart/form-data"
                       forKey:fileDataparamKey
                 ];
                
                [form setData:[fileDataparams objectForKey:fileDataparamKey] withFileName:@"myphoto.jpg" andContentType:@"image/jpeg" forKey:@"photo"];
                [form setData:[fileDataparams objectForKey:fileDataparamKey] forKey:fileDataparamKey];
            }
            
            [self.httpRequest buildPostBody];
        }
        
        __weak ASIHTTPRequest *weekHttpRequest  = self.httpRequest;
        __weak MHAsiNetworkItem *weekSelf       = self;
        
        self.httpRequest.timeOutSeconds         = MHAsi_API_TIME_OUT;
        
        [self.httpRequest setCompletionBlock:^(void){
            
            NSString *responseString = [[NSString alloc] initWithData:weekHttpRequest.responseData
                                                             encoding:NSUTF8StringEncoding
                                        ];
            
#if DEBUG
//            NSLog(@"BM网络请求接口url:%@的回返数据 responseString:\n%@", url, responseString);
            
#endif
            // 如果是.net后台返回数据，并且json数据有xml包着的话，请释放这一句
//            responseString = [responseString ignoreDotNetSpecialString];
            
            // 如果返回值有html特殊字符，请释放这一句
//            responseString = [responseString ignoreHTMLSpecialString];
            
            id returnData = [JsonManager JSONValue:responseString];
            
            if (successBlock)
            {
                successBlock(returnData);
                
            }
            
            [[MHAsiNetworkHandler sharedInstance] removeItem:weekSelf];
        }];
        
        [self.httpRequest setFailedBlock:^(void) {
            
#if DEBUG
            NSLog(@"BM网络请求接口url:%@访问错误 error:\n%@", url, weekHttpRequest.error);
#endif
            if (failureBlock)
            {
                failureBlock(weekHttpRequest.error);
            }
            
            [[MHAsiNetworkHandler sharedInstance] removeItem:weekSelf];
        }];
        
        [[MHAsiNetworkHandler sharedInstance] addItem:self];
        [self.httpRequest startAsynchronous];
    }
    
    return self;
}

@end
