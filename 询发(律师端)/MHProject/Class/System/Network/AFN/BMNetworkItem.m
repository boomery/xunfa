//
//  BMNetworkItem.m
//  BlueMobiProject
//
//  Created by 朱 亮亮 on 14-5-12.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import "BMNetworkItem.h"
#import "BMNetworkHandler.h"
//#import "NSString+Common.h"
#import "JsonHandler.h"
#import "NSObject+SBJSON.h"

@implementation BMNetworkItem

/**
 *  普通的网络请求
 *
 *  @param networkType  <#networkType description#>
 *  @param url          <#url description#>
 *  @param params       <#params description#>
 *  @param delegate     <#delegate description#>
 *  @param hashValue    <#hashValue description#>
 *  @param showHUD      <#showHUD description#>
 *  @param successBlock <#successBlock description#>
 *  @param failureBlock <#failureBlock description#>
 *
 *  @return <#return value description#>
 */
- (BMNetworkItem *) initWithtype:(NetWorkType) networkType
                             url:(NSString *) url
                          params:(NSDictionary *) params
                        delegate:(id) delegate
                       hashValue:(NSUInteger) hashValue
                         showHUD:(BOOL) showHUD
                    successBlock:(NWSuccessBlock) successBlock
                    failureBlock:(NWFailureBlock) failureBlock
{
    if (self = [super init])
    {
        self.networkType = networkType;
        self.url = url;
        self.params = params;
        self.delegate = delegate;
        self.hashValue = hashValue;
        self.showHUD = showHUD;
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
        
        [[BMNetworkHandler sharedInstance] addItem:self];
        NSLog(@"BM网络请求接口url：%@\n参数：%@", url, params);
        
        if (networkType == NetWorkGET)
        {
//            __weak BMNetworkItem *weakSelf = self;
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            self.httpRequest = [manager GET:url
                                 parameters:params
                                    success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSLog(@"BM网络请求接口url:%@的回返数据 responseString:\n%@....%@", url, responseObject,[responseObject class]);
//                NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//                id returnData = [JsonHandler JSONValue:responseObject];
                if (self.successBlock)
                {
                    self.successBlock(responseObject);
                }
                [[BMNetworkHandler sharedInstance] removeItem:self];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error)
            {
                NSLog(@"BM网络请求接口url:%@访问错误 error:\n%@", url, error);
                if (self.failureBlock)
                {
                    self.failureBlock(error);
                } else {
//                    [UIAlertView alertWithTitle:@"提示" message:@"网络异常，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                }
                [[BMNetworkHandler sharedInstance] removeItem:self];
            }];
        }
        else if (networkType == NetWorkPOST)
        {
//            __weak BMNetworkItem *weakSelf = self;
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            self.httpRequest = [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"BM网络请求接口url:%@的回返数据 responseString:\n%@", url, responseObject);
                
                if (self.successBlock) {
                    self.successBlock(responseObject);
                }
                [[BMNetworkHandler sharedInstance] removeItem:self];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"BM网络请求接口url:%@访问错误 error:\n%@", url, error);
                if (self.failureBlock) {
                    self.failureBlock(error);
                } else {
//                    [UIAlertView alertWithTitle:@"提示" message:@"网络异常，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                }
                [[BMNetworkHandler sharedInstance] removeItem:self];
            }];
        }
    }
    
    return self;
}

/**
 *  表单上传
 *
 *  @param networkType  <#networkType description#>
 *  @param url          <#url description#>
 *  @param params       <#params description#>
 *  @param images       <#images description#>
 *  @param delegate     <#delegate description#>
 *  @param hashValue    <#hashValue description#>
 *  @param showHUD      <#showHUD description#>
 *  @param successBlock <#successBlock description#>
 *  @param failureBlock <#failureBlock description#>
 *
 *  @return <#return value description#>
 */
- (BMNetworkItem *) initWithtype:(NetWorkType) networkType
                             url:(NSString *) url
                          params:(NSDictionary *) params
                          images:(NSDictionary *) images
                        delegate:(id) delegate
                       hashValue:(NSUInteger) hashValue
                         showHUD:(BOOL) showHUD
                    successBlock:(NWSuccessBlock) successBlock
                    failureBlock:(NWFailureBlock) failureBlock
{
    if (self = [super init])
    {
        self.networkType = networkType;
        self.url = url;
        self.params = params;
        self.delegate = delegate;
        self.hashValue = hashValue;
        self.showHUD = showHUD;
        self.successBlock = successBlock;
        self.failureBlock = failureBlock;
        
        [[BMNetworkHandler sharedInstance] addItem:self];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //manager.responseSerializer.
                    [manager POST:url
                       parameters:params
        constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             NSArray *imageArray = [[NSArray alloc] initWithArray:[images objectForKey:@"allMultiUrl"]];
             for (int i = 0; i<imageArray.count; i++)
             {
                 [formData appendPartWithFileData:imageArray[i] name:@"allMultiUrl"
                                         fileName:[NSString stringWithFormat:@"test%d.png",i]
                                         mimeType:@"image/pjpeg"];
             }
         }success:^(AFHTTPRequestOperation *operation, id responseObject)
          {
//              NSData* data = [NSData dataWithBytes:(__bridge const void *)([responseObject dataUsingEncoding:NSUTF8StringEncoding]) length:[responseObject length]];
//              NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             NSLog(@"图片上传成功: %@", responseObject);
              NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
             if (self.successBlock)
             {
                 self.successBlock(json);
             }
             [[BMNetworkHandler sharedInstance] removeItem:self];
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
          {
             NSLog(@"图片上传失败: %@", error);
             if (self.failureBlock) {
                 self.failureBlock(error);
             } else
             {
                 
             }
             [[BMNetworkHandler sharedInstance] removeItem:self];
         }];
        
        
//        for (NSData *image in images)
//        {
//            NSLog(@"图片：%@", image);
//            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//            [manager POST:url
//               parameters:params
//constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
//            {
//
//                
//                for (NSString *keyString in [images allKeys])
//                {
//                    NSData *imgData = [images objectForKey:keyString];
//                    if (imgData.length > 0) {
//                        
//                        [formData appendPartWithFormData:imgData name:keyString];
//                        NSLog(@"图片上传%@",keyString);
//                    }
//                }
//            } success:^(AFHTTPRequestOperation *operation, id responseObject)
//             {
//                NSLog(@"图片上传成功: %@", responseObject);
//                if (self.successBlock) {
//                    self.successBlock(responseObject);
//                }
//                [[BMNetworkHandler sharedInstance] removeItem:self];
//            } failure:^(AFHTTPRequestOperation *operation, NSError *error)
//             {
//                NSLog(@"图片上传失败: %@", error);
//                if (self.failureBlock) {
//                    self.failureBlock(error);
//                } else
//                {
//
//                }
//                [[BMNetworkHandler sharedInstance] removeItem:self];
//            }];
//        }
    }
    return self;
}

- (BMNetworkItem *) initDownloadWithtype:(NetWorkType) networkType
                                     url:(NSString *) url
                                delegate:(id) delegate
                               hashValue:(NSUInteger) hashValue
                              startBlock:(NWStartBlock) startBlock
                            successBlock:(NWSuccessBlock) successBlock
                            failureBlock:(NWFailureBlock) failureBlock
{
    if (self = [super init])
    {
        self.networkType = networkType;
        self.url = url;
        self.delegate = delegate;
        self.hashValue = hashValue;
    }
    
    return self;
}

@end
