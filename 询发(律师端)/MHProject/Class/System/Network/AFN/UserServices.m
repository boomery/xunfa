//
//  UserServices.m
//  Les
//
//  Created by 朱亮亮 on 14-11-4.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import "UserServices.h"
#import "BMNetworkHandler.h"
#import "SVProgressHUD.h"


@implementation UserServices

#pragma mark - 登录
+ (void)loginByLogin:(NSString *)login
            password:(NSString *)password
     completionBlock:(void(^)(int result, id responseObject))completionBlock
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:login forKey:@"mobileNumber"];
    [params setValue:password forKey:@"password"];
    
    [[BMNetworkHandler sharedInstance] conURL:LOGIN
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
    {
                                     int result = [[returnData objectForKey:@"result"] intValue];
        if (completionBlock)
        {
            completionBlock(result,returnData);
        }
//                                     if (result == 1) {
//                                         if (completionBlock)
//                                         {
//                                             completionBlock(1, [returnData objectForKey:@"data"]);
//                                         }
//                                     }
//                                     else {
////                                         [UIAlertView alertWithTitle:@"提示" message:[returnData objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                                         if (completionBlock) {
//                                             completionBlock(result, nil);
//                                         }
//                                     }
                                 } failureBlock:^(NSError *error) {
                                     if (completionBlock) {
                                         completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
                                     }
                                 }];
}


+ (void)registByMobileNunber:(NSString *)mobileNumber
                    password:(NSString *)password
                    authCode:(NSString *)authCode
             completionBlock:(void(^)(int result, id responseObject))completionBlock;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:mobileNumber forKey:@"mobileNumber"];
    [params setValue:password forKey:@"password"];
    [params setValue:authCode forKey:@"authCode"];
    
    [[BMNetworkHandler sharedInstance] conURL:REGIST
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"result"] intValue];
         
         if (completionBlock)
         {
            completionBlock(result,returnData);
         }
//         if (result == 1)
//         {
//             if (completionBlock)
//             {
//                 completionBlock(1, [returnData objectForKey:@"data"]);
//             }
//         }
//         else {
//             //错误信息打印
//             [UnityLHClass showAlertView:[returnData objectForKey:@"msg"]];
//             if (completionBlock)
//             {
//                 completionBlock(result, nil);
//             }
//         }
     } failureBlock:^(NSError *error) {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma MARK - 获取验证码
+ (void)getAuthCodeBymobileNumber:(NSString *)mobileNumber
                  completionBlock:(void(^)(int result, id responseObject))completionBlock;
{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:mobileNumber forKey:@"mobileNumber"];
    
    [[BMNetworkHandler sharedInstance] conURL:AUTHCODE
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
//         if (result == 1)
//         { // 成功
//             if (completionBlock)
//             {
//                 completionBlock(1, [returnData objectForKey:@"data"]);
//             }
//         }
//         else {
//             //失败
//             //                                         [UIAlertView alertWithTitle:@"提示" message:[returnData objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//             if (completionBlock)
//             {
//                 
//                 completionBlock(result, nil);
//             }
//         }
     } failureBlock:^(NSError *error) {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma MARK -取得城市一览分组后信息
+ (void)getCityListBykeyword:(NSString *)keyword
                  completionBlock:(void(^)(int result, id responseObject))completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:keyword forKey:@"keyword"];
    [[BMNetworkHandler sharedInstance] conURL:COMMONCITYLIST
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
//         if (result == 1)
//         { // 成功
//             if (completionBlock)
//             {
//                 NSLog(@"++++%@",[returnData objectForKey:@"data"]);
//                 completionBlock(1, [returnData objectForKey:@"data"]);
//                 
//             }
//         }
//         else {
//             //失败
//            //[UIAlertView alertWithTitle:@"提示" message:[returnData objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//             if (completionBlock)
//             {
//                 NSLog(@"0+++++");
//                 completionBlock(result, nil);
//             }
//         }
     } failureBlock:^(NSError *error) {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
 
}

#pragma MARK -取得省份一览信息
+ (void)getProvinceCompletionBlock:(void(^)(int result, id responseObject))completionBlock
{

    
    [[BMNetworkHandler sharedInstance] conURL:PROVINCELIST
                                  networkType:NetWorkGET
                                       params:nil
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
//         if (result == 1)
//         { // 成功
//             if (completionBlock)
//             {
//                 NSLog(@"++++%@",[returnData objectForKey:@"data"]);
//                 completionBlock(1, [returnData objectForKey:@"data"]);
//                 
//             }
//         }
//         else {
//             //失败
//             //[UIAlertView alertWithTitle:@"提示" message:[returnData objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//             if (completionBlock)
//             {
//                 NSLog(@"0+++++");
//                 completionBlock(result, nil);
//             }
//         }
     } failureBlock:^(NSError *error) {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
}

#pragma MARK -取得城市一览信息
+ (void)getCityListByprovinceId:(NSString *)provinceId
             completionBlock:(void(^)(int result, id responseObject))completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:provinceId forKey:@"provinceId"];
    
    [[BMNetworkHandler sharedInstance] conURL:COMMONCITYLIST
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }

//         if (result == 1)
//         { // 成功
//             if (completionBlock)
//             {
//                 NSLog(@"++++%@",[returnData objectForKey:@"data"]);
//                 completionBlock(1, returnData);
//                 
//             }
//         }
//         else {
//             //失败
//             //[UIAlertView alertWithTitle:@"提示" message:[returnData objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//             if (completionBlock)
//             {
//                 NSLog(@"0+++++");
//                 completionBlock(result, nil);
//             }
//         }
     } failureBlock:^(NSError *error) {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
    
}

#pragma mark---取得用户信息
+ (void)getUserInfoWithUserId:(NSString *)userId
                completionBlock:(void(^)(int result, id responseObject))completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:GETUSERINFO
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }

         
     } failureBlock:^(NSError *error) {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];

}


#pragma mark---保存用户的保修信息
+ (void)saveUserRepairInfoWithUserId:(NSString *)userId
                      materialsname:(NSString *)materialsname
                           doorDate:(NSString *)doorDate
                           doorTime:(NSString *)doorTime
                         mobilePhone:(NSString *)mobilePhone
                            address:(NSString *)address
                             remark:(NSString *)remark
                        allMultiUrl:(NSArray * )allMultiUrlArray
              completionBlock:(void(^)(int result, id responseObject))completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:materialsname forKey:@"materialsname"];
    [params setValue:doorDate forKey:@"doorDate"];
    [params setValue:doorTime forKey:@"doorTime"];
    [params setValue:mobilePhone forKey:@"mobilePhone"];
    [params setValue:address forKey:@"address"];
    [params setValue:remark forKey:@"remark"];

    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableDictionary *imageDic = [[NSMutableDictionary alloc] init];
    for (int i = 0; i<allMultiUrlArray.count; i++)
    {
        //
//        id imageData = allMultiUrlArray[i];
        
        NSData *imageData = UIImageJPEGRepresentation(allMultiUrlArray[i], 0.5);
        [arr addObject:imageData];
        
    }
    [imageDic setValue:arr forKey:@"allMultiUrl"];
    
//    NSMutableDictionary *imageDic = [[NSMutableDictionary alloc] init];
//    [imageDic setValue:allMultiUrlArray forKey:@"allMultiUrl"];
    
    [[BMNetworkHandler sharedInstance]conURL:REPAIRSAVE
                                 networkType:NetWorkPOST
                                      params:params
                                      images:imageDic
                                    delegate:nil
                                     showHUD:YES
                                successBlock:^(id returnData)
    {
        int result = [[returnData objectForKey:@"status"] intValue];
        if (completionBlock)
        {
            completionBlock(result,returnData);
        }

    } failureBlock:^(NSError *error) {
        if (completionBlock) {
            completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
        }

    }];
//    [[BMNetworkHandler sharedInstance] conURL:REPAIRSAVE
//                                  networkType:NetWorkPOST
//                                       params:params
//                                     delegate:nil
//                                      showHUD:YES
//                                 successBlock:^(id returnData)
//     {
//         
//         int result = [[returnData objectForKey:@"status"] intValue];
//         if (completionBlock)
//         {
//             completionBlock(result,returnData);
//         }
//
//         
//     } failureBlock:^(NSError *error) {
//         if (completionBlock) {
//             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
//         }
//     }];
    
}

#pragma MARK -用户完善个人资料
+ (void)perfectUserInfoByuserId:(NSString *)userId
                userName:(NSString *)userName
                realName:(NSString *)realName
                emailAddress1:(NSString *)emailAddress1
                birthdate:(NSString *)birthdate
                image:(NSString *)image
                mobileNumber:(NSString *)mobileNumber
                completionBlock:(void(^)(int result, id responseObject))completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:userName forKey:@"userName"];
    [params setValue:realName forKey:@"realName"];
    [params setValue:emailAddress1 forKey:@"emailAddress1"];
    [params setValue:birthdate forKey:@"birthdate"];
    [params setValue:image forKey:@"image"];
    [params setValue:mobileNumber forKey:@"mobileNumber"];
    
    [[BMNetworkHandler sharedInstance] conURL:MEMBERPERFECT
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         int result = [[returnData objectForKey:@"status"] intValue];
         if (result == 1)
         { // 成功
             if (completionBlock)
             {
                 NSLog(@"++++%@",[returnData objectForKey:@"data"]);
                 completionBlock(1, returnData);
                 
             }
         }
         else {
             //失败
             //[UIAlertView alertWithTitle:@"提示" message:[returnData objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
             if (completionBlock)
             {
                 NSLog(@"0+++++");
                 completionBlock(result, nil);
             }
         }
     } failureBlock:^(NSError *error) {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
    
}



#pragma mark---查看用户的保修历史
+ (void)getUserRepairInfoWithUserId:(NSString *)userId
              completionBlock:(void(^)(int result, id responseObject))completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    
    [[BMNetworkHandler sharedInstance] conURL:REPAIRLIST
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
         
         
     } failureBlock:^(NSError *error) {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}



#pragma mark---保修处理打分
+ (void)setUserRepairGradeWithUserId:(NSString *)userId
                           repairId:(NSString *)repairId
                           fraction:(NSString *)fraction
                    completionBlock:(void(^)(int result, id responseObject))completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    [params setValue:repairId forKey:@"repairId"];
    [params setValue:fraction forKey:@"fraction"];
    
    [[BMNetworkHandler sharedInstance] conURL:SETREPAIRGRADE
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
         
         
     } failureBlock:^(NSError *error) {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}

#pragma mark--获取保修详情
+ (void)getUserRepairDetailWithRepairId:(NSString *)repairId
                     completionBlock:(void(^)(int result, id responseObject))completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:repairId forKey:@"repairId"];
    
    [[BMNetworkHandler sharedInstance] conURL:REPAIRDETAILS
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
         
         
     } failureBlock:^(NSError *error) {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}


#pragma mark--保存用户的投诉建议信息
+ (void)saveUserCompsuggWithUserId:(NSString *)userId
                        completionBlock:(void(^)(int result, id responseObject))completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:REPAIRDETAILS
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
         
         
     } failureBlock:^(NSError *error) {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}

#pragma mark--查看用户的投诉建议历史
+ (void)getUserCompsuggWithUserId:(NSString *)userId
                   completionBlock:(void(^)(int result, id responseObject))completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:userId forKey:@"userId"];
    
    [[BMNetworkHandler sharedInstance] conURL:REPAIRDETAILS
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
         
         
     } failureBlock:^(NSError *error) {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}



#pragma mark--查看投诉建议详情
+ (void)getUserCompsuggDetailWithCompsuggId:(NSString *)compsuggId
                  completionBlock:(void(^)(int result, id responseObject))completionBlock
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:compsuggId forKey:@"compsuggId"];
    
    [[BMNetworkHandler sharedInstance] conURL:REPAIRDETAILS
                                  networkType:NetWorkGET
                                       params:params
                                     delegate:nil
                                      showHUD:YES
                                 successBlock:^(id returnData)
     {
         
         int result = [[returnData objectForKey:@"status"] intValue];
         if (completionBlock)
         {
             completionBlock(result,returnData);
         }
         
         
     } failureBlock:^(NSError *error) {
         if (completionBlock) {
             completionBlock(API_COULD_NOT_CONNECT_ERROR, nil);
         }
     }];
    
}

@end
