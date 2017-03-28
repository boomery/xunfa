//
//  UserServices.h
//  Les
//
//  Created by 朱亮亮 on 14-11-4.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMNetWorkURLs.h"

@class UserModel;
@interface UserServices : NSObject

#pragma mark - 登录

/**
 *  登录接口
 *
 *  @param login           登录名（手机或邮箱）
 *  @param password        密码
 *  @param completionBlock 回调
 */
+ (void)loginByLogin:(NSString *)login
            password:(NSString *)password
     completionBlock:(void(^)(int result, id responseObject))completionBlock;


#pragma mark - 注册
+ (void)registByMobileNunber:(NSString *)mobileNumber
                    password:(NSString *)password
                    authCode:(NSString *)authCode
             completionBlock:(void(^)(int result, id responseObject))completionBlock;


#pragma MARK - 获取验证码
+ (void)getAuthCodeBymobileNumber:(NSString *)mobileNumber
                  completionBlock:(void(^)(int result, id responseObject))completionBlock;


#pragma mark-完善个人资料

#pragma MARK -取得城市一览分组后信息
+ (void)getCityListBykeyword:(NSString *)keyword
             completionBlock:(void(^)(int result, id responseObject))completionBlock;





#pragma MARK -取得省份一览信息
+ (void)getProvinceCompletionBlock:(void(^)(int result, id responseObject))completionBlock;


#pragma MARK -取得城市一览信息
+ (void)getCityListByprovinceId:(NSString *)provinceId
                completionBlock:(void(^)(int result, id responseObject))completionBlock;



#pragma mark---取得用户信息
+ (void)getUserInfoWithUserId:(NSString *)userID
              completionBlock:(void(^)(int result, id responseObject))completionBlock;


#pragma mark---保存用户的保修信息
+ (void)saveUserRepairInfoWithUserId:(NSString *)userId
                       materialsname:(NSString *)materialsname
                            doorDate:(NSString *)doorDate
                            doorTime:(NSString *)doorTime
                         mobilePhone:(NSString *)mobilePhone
                             address:(NSString *)address
                              remark:(NSString *)remark
                         allMultiUrl:(NSArray * )allMultiUrlArray
                     completionBlock:(void(^)(int result, id responseObject))completionBlock;

#pragma mark---查看用户的保修历史
+ (void)getUserRepairInfoWithUserId:(NSString *)userID
                    completionBlock:(void(^)(int result, id responseObject))completionBlock;

#pragma mark---保修处理打分
+ (void)setUserRepairGradeWithUserId:(NSString *)userID
                            repairId:(NSString *)repairId
                            fraction:(NSString *)fraction
                     completionBlock:(void(^)(int result, id responseObject))completionBlock;

#pragma mark--获取保修详情
+ (void)getUserRepairDetailWithRepairId:(NSString *)repairId
                        completionBlock:(void(^)(int result, id responseObject))completionBlock;

#pragma mark--保存用户的投诉建议信息
+ (void)saveUserCompsuggWithUserId:(NSString *)userId
                   completionBlock:(void(^)(int result, id responseObject))completionBlock;

#pragma mark--查看用户的投诉建议历史
+ (void)getUserCompsuggWithUserId:(NSString *)userId
                  completionBlock:(void(^)(int result, id responseObject))completionBlock;

#pragma MARK -用户完善个人资料
+ (void)perfectUserInfoByuserId:(NSString *)userId
                       userName:(NSString *)userName
                       realName:(NSString *)realName
                  emailAddress1:(NSString *)emailAddress1
                      birthdate:(NSString *)birthdate
                          image:(NSString *)image
                   mobileNumber:(NSString *)mobileNumber
                completionBlock:(void(^)(int result, id responseObject))completionBlock;

#pragma mark--查看投诉建议详情
+ (void)getUserCompsuggDetailWithCompsuggId:(NSString *)compsuggId
                            completionBlock:(void(^)(int result, id responseObject))completionBlock;


@end
