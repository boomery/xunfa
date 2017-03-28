//
//  MHAsiNetworkAPI.m
//  MHProject
//
//  Created by Andy on 15/4/23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import "MHAsiNetworkAPI.h"
#import "MHAsiNetworkHandler.h"
#import "MHAsiNetworkUrl.h"


@implementation MHAsiNetworkAPI


#pragma mark --
#pragma mark -- 公共方法，获取时间戳和城市信息


#pragma mark - 推送
/**
 *  推送
 *   @param app_name
 *   @param app_version
 *   @param device_uid
 *   @param device_token
 */
+ (void)pushToServerWithApp_name:(NSString *)app_name
                     app_version:(NSString *)app_version
                      device_uid:(NSString *)device_uid
                    device_token:(NSString *)device_token
                    SuccessBlock:(MHAsiSuccessBlock)successBlock
                    failureBlock:(MHAsiFailureBlock)failureBlock
                         showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    //配置user_id
    NSString *user_id = DEF_PERSISTENT_GET_OBJECT(DEF_UserID);
    if (!user_id)
    {
        user_id = @"0";//如果用户id不存在就传 0
    }
    [params setValue:user_id forKey:@"user_id"];
    
    [params setValue:app_name forKey:@"app_name"];
    [params setValue:app_version forKey:@"app_version"];
    [params setValue:device_uid forKey:@"device_uid"];
    [params setValue:device_token forKey:@"device_token"];
    
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_Apns_device
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
    
}


#pragma mark - 1、获取城市区域
/**
 *  获取城市区域
 */
+ (void)getCityBySuccessBlock:(MHAsiSuccessBlock)successBlock
                 failureBlock:(MHAsiFailureBlock)failureBlock
                      showHUD:(BOOL)showHUD
{
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_getCity
                                     networkType:MHAsiNetWorkGET
                                          params:nil
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
    
}
#pragma mark - 2、获取时间戳
/**
 *  时间戳  (在入口类中获取)
 */
+ (void)getTimestampBySuccessBlock:(MHAsiSuccessBlock)successBlock
                   failureBlock:(MHAsiFailureBlock)failureBlock
                        showHUD:(BOOL)showHUD
{
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_timestamp
                                     networkType:MHAsiNetWorkGET
                                          params:nil
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

#pragma mark - 抢答推送相关
/**
 * 抢答推送相关
 *
 *  @param enable_race   抢答开关(1是开启，-1是关闭)
 */
+ (void)automaticRaceQuestionByuid:(NSString *)uid
                         timestamp:(NSString *)timestamp
                              sign:(NSString *)sign
                       enable_race:(NSString *)enable_race
                      SuccessBlock:(MHAsiSuccessBlock)successBlock
                      failureBlock:(MHAsiFailureBlock)failureBlock
                           showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:enable_race forKey:@"enable_race"];

    DEF_DEBUG(@"律师自动抢答请求参数：params:%@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@%@",DEF_API_Lawyer,uid];
    
    [[MHAsiNetworkHandler sharedInstance] conURL:url
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}

#pragma mark - 消息通知开关
/**
 *  消息通知开关
 *
 *  @param enable_notify  消息通知开关(1是开启，-1是关闭)
 */
+ (void)permitOrForbidNotifyWithuid:(NSString *)uid
                          timestamp:(NSString *)timestamp
                               sign:(NSString *)sign
                      enable_notify:(NSString *)enable_notify
                       SuccessBlock:(MHAsiSuccessBlock)successBlock
                       failureBlock:(MHAsiFailureBlock)failureBlock
                            showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:enable_notify forKey:@"enable_notify"];
    
    DEF_DEBUG(@"是否允许通知请求参数：params:%@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@%@",DEF_API_Lawyer,uid];
    
    [[MHAsiNetworkHandler sharedInstance] conURL:url
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}





#pragma mark --
#pragma mark -- 登录、注册、忘记密码、个人信息相关

#pragma mark - 1、登录
/**
 * 登录
 *
 *  @param mobile   手机号码
 *  @param password 密码
 */

+ (void)loginWithMobile:(NSString *)mobile
               password:(NSString *)password
           SuccessBlock:(MHAsiSuccessBlock)successBlock
           failureBlock:(MHAsiFailureBlock)failureBlock
                showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:mobile forKey:@"mobile"];
    //密码需要MD5加密
    NSString *md5PassWord = [password md5];
    [params setValue:md5PassWord forKey:@"password"];
    
    DEF_DEBUG(@"登录：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_login
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
    
}

#pragma mark - 2、获取验证码
/**
 *  验证码
 *
 *  @param mobile   手机号码
 */

+ (void)getRecodeWithMobile:(NSString *)mobile
               SuccessBlock:(MHAsiSuccessBlock)successBlock
               failureBlock:(MHAsiFailureBlock)failureBlock
                    showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:mobile forKey:@"mobile"];
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_recode
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}
#pragma mark - 2、忘记密码
/**
 *  验证码
 *
 *  @param mobile   手机号码
 */
+ (void)getForgetRecodeWithMobile:(NSString *)mobile
                     SuccessBlock:(MHAsiSuccessBlock)successBlock
                     failureBlock:(MHAsiFailureBlock)failureBlock
                          showHUD:(BOOL)showHUD
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:mobile forKey:@"mobile"];
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_forgetRecode
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}
#pragma mark - 3、检验验证码
/**
 * 检验验证码
 *
 *  @param mobile   手机号码
 *  @param recode   验证码
 */

+ (void)checkRecodeWithMobile:(NSString *)mobile
                       recode:(NSString *)recode
                 SuccessBlock:(MHAsiSuccessBlock)successBlock
                 failureBlock:(MHAsiFailureBlock)failureBlock
                      showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:mobile forKey:@"mobile"];
    [params setValue:recode forKey:@"recode"];
    
    DEF_DEBUG(@"验证验证码：%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_checkRecode
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

#pragma mark - 4、注册协议
/**
 * 注册协议
 */
+ (void)registerAgreementWithSuccessBlock:(MHAsiSuccessBlock)successBlock
                             failureBlock:(MHAsiFailureBlock)failureBlock
                                  showHUD:(BOOL)showHUD
{
    DEF_DEBUG(@"%@",DEF_API_register_agreement);
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_register_agreement
                                     networkType:MHAsiNetWorkGET
                                          params:nil
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

#pragma mark - 关于询法
/**
 * 关于询法
 */
+ (void)getAboutUsInfoWithSuccessBlock:(MHAsiSuccessBlock)successBlock
                          failureBlock:(MHAsiFailureBlock)failureBlock
                               showHUD:(BOOL)showHUD
{
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_about_us
                                     networkType:MHAsiNetWorkGET
                                          params:nil
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}

#pragma mark - 修改密码
/**
 * 修改密码
 *
 *  @param mobile   手机号码
 *  @param recode   验证码
 *  @param password 密码
 */

+ (void)changePassWordWithMobile:(NSString *)mobile
                          recode:(NSString *)recode
                        password:(NSString *)password
                    SuccessBlock:(MHAsiSuccessBlock)successBlock
                    failureBlock:(MHAsiFailureBlock)failureBlock
                         showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:mobile forKey:@"mobile"];
    [params setValue:recode forKey:@"recode"];
    //密码需要MD5加密
    NSString *md5PassWord = [password md5];
    [params setValue:md5PassWord forKey:@"password"];
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_modifyPassword
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
    
}



#pragma mark - 退出登录
/**
 *  退出登录
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */

+ (void)loginOutWithUid:(NSString *)uid
              timestamp:(NSString *)timestamp
                   sign:(NSString *)sign
           SuccessBlock:(MHAsiSuccessBlock)successBlock
           failureBlock:(MHAsiFailureBlock)failureBlock
                showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    DEF_DEBUG(@"退出登录：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_login_out
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
    
}



#pragma mark -- 问题相关
#pragma mark -- 问题相关（抢答问题、抢答、问题列表）

#pragma mark -- 1、获取问题列表
/**
 *   获取问题列表
 *
 *  @param uid   用户的user_id
 */

+ (void)getQuestionListWithUserID:(NSString *)user_ID
                     SuccessBlock:(MHAsiSuccessBlock)successBlock
                     failureBlock:(MHAsiFailureBlock)failureBlock
                          showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:user_ID forKey:@"uid"];
//    NSString *url = [NSString stringWithFormat:@"%@?uid=%@",DEF_API_questionsList,user_ID];
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_questionsList
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

#pragma mark -- 2、获取待抢答的问题列表
/**
 *   获取待抢答的问题列表
 *
 */
+ (void)getRaceQuestionListWithuid:(NSString *)uid
                         timestamp:(NSString *)timestamp
                              sign:(NSString *)sign
                      SuccessBlock:(MHAsiSuccessBlock)successBlock
                               failureBlock:(MHAsiFailureBlock)failureBlock
                                    showHUD:(BOOL)showHUD
{
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];

    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_RaceQuestionsList
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}
#pragma mark -- 3、回答待抢答的问题
/**
 *   回答待抢答的问题
 *
 *  @param uid   用户的user_id
 *  @param timestamp   用户的timestamp
 *  @param sign   用户的sign
 *  @param question_id   用户的question_id
 */
+ (void)answerRaceQuestionByuid:(NSString *)uid
                      timestamp:(NSString *)timestamp
                           sign:(NSString *)sign
                    question_id:(NSString *)question_id
                   SuccessBlock:(MHAsiSuccessBlock)successBlock
                   failureBlock:(MHAsiFailureBlock)failureBlock
                        showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:question_id forKey:@"question_id"];
    
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_AnswerRaceQuestion
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}


#pragma mark -- 4、更新回复内容及状态
/**
 *  更新回复内容及状态
 *
 *  @param uid   用户的user_id
 *  @param timestamp   用户的timestamp
 *  @param sign   用户的sign
 *  @param answer_id    answer_id
 *  @param content      内容
 *  @param state       状态(0表示正常,4表示放弃
 */
+ (void)updateAnswerRaceQuestionByuid:(NSString *)uid
                      timestamp:(NSString *)timestamp
                           sign:(NSString *)sign
                      answer_id:(NSString *)answer_id
                        content:(NSString *)content
                          state:(NSString *)state
                   SuccessBlock:(MHAsiSuccessBlock)successBlock
                   failureBlock:(MHAsiFailureBlock)failureBlock
                        showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:answer_id forKey:@"answer_id"];
    [params setValue:content forKey:@"content"];
    [params setValue:state forKey:@"state"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_AnswerRaceQuestion,answer_id];

    
    [[MHAsiNetworkHandler sharedInstance] conURL:url
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}

#pragma mark -- 5、问题详情
/**
 *  问题详情
 *
 *  @param uid   用户的question_id
 */
+ (void)getQuestionDetailQuestion_id:(NSString *)question_id
                        SuccessBlock:(MHAsiSuccessBlock)successBlock
                        failureBlock:(MHAsiFailureBlock)failureBlock
                             showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:question_id forKey:@"question_id"];
    [params setValue:DEF_PERSISTENT_GET_OBJECT(DEF_UserID) forKey:@"uid"];
    NSString  *url= [NSString stringWithFormat:@"%@/%@",DEF_API_questionsDetail,question_id];
    
    [[MHAsiNetworkHandler sharedInstance] conURL:url
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

#pragma mark - 获取问题全部详情
+ (void)getQuestionAllDetailWithUid:(NSString *)uid
                          timestamp:(NSString *)timestamp
                               sign:(NSString *)sign
                        Question_id:(NSString *)question_id
                       SuccessBlock:(MHAsiSuccessBlock)successBlock
                       failureBlock:(MHAsiFailureBlock)failureBlock
                            showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:question_id forKey:@"id"];
    
    NSString  *url= [NSString stringWithFormat:@"%@/%@",DEF_API_Question_AllDetail,question_id];
    
    DEF_DEBUG(@"%@  %@",params,url);
    
    
    
    [[MHAsiNetworkHandler sharedInstance] conURL:url
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}
#pragma mark - 获取某一回答的追问

+ (void)getQuestionPlusAnswer_id:(NSString *)answer_id
                             uid:(NSString *)uid
                    SuccessBlock:(MHAsiSuccessBlock)successBlock
                    failureBlock:(MHAsiFailureBlock)failureBlock
                         showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:answer_id forKey:@"answer_id"];
    [params setValue:uid forKey:@"uid"];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_QuestionPlus,answer_id];
    [[MHAsiNetworkHandler sharedInstance] conURL:url
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

#pragma  mark - 继续追问
+ (void)getQuestionPlusSendMessageByuid:(NSString *)uid
                              timestamp:(NSString *)timestamp
                                   sign:(NSString *)sign
                              answer_id:(NSString *)answer_id
                                content:(NSString *)content
                           SuccessBlock:(MHAsiSuccessBlock)successBlock
                           failureBlock:(MHAsiFailureBlock)failureBlock
                                showHUD:(BOOL)showHUD

{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:answer_id forKey:@"answer_id"];
    [params setValue:content forKey:@"content"];
    
    DEF_DEBUG(@"%@%@",params,DEF_API_QuestionPlusSendMessage);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_QuestionPlusSendMessage
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

#pragma  mark - 回答追问
+ (void)getAnswerPlusSendMessageByuid:(NSString *)uid
                            timestamp:(NSString *)timestamp
                                 sign:(NSString *)sign
                            answer_id:(NSString *)answer_id
                              content:(NSString *)content
                         SuccessBlock:(MHAsiSuccessBlock)successBlock
                         failureBlock:(MHAsiFailureBlock)failureBlock
                              showHUD:(BOOL)showHUD

{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:answer_id forKey:@"answer_id"];
    [params setValue:content forKey:@"content"];
    
    DEF_DEBUG(@"%@%@",params,DEF_API_QuestionPlusSendMessage);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_AnswerPlusSendMessage
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

#pragma mark -- 举报
/**
 *  举报
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 *  @param qid         问题id
 act=(question/answer/ping)举报问题/回复/评论
 */
+ (void)reportQuestionToServerWithuid:(NSString *)uid
                            timestamp:(NSString *)timestamp
                                 sign:(NSString *)sign
                                  qid:(NSString *)qid
                                  act:(NSString *)act
                         SuccessBlock:(MHAsiSuccessBlock)successBlock
                         failureBlock:(MHAsiFailureBlock)failureBlock
                              showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:qid forKey:@"id"];
    [params setValue:act forKey:@"act"];
    
    DEF_DEBUG(@"举报的参数：params:%@",params);
    
    NSString *ur = [NSString stringWithFormat:@"%@/%@",DEF_API_tip_offQuestion,qid];
    [[MHAsiNetworkHandler sharedInstance] conURL:ur
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
    
}

#pragma mark - 点赞
+ (void)pointPraiseQuestionToServerWithuid:(NSString *)uid
                                 timestamp:(NSString *)timestamp
                                      sign:(NSString *)sign
                                       qid:(NSString *)qid
                                       act:(NSString *)act
                              SuccessBlock:(MHAsiSuccessBlock)successBlock
                              failureBlock:(MHAsiFailureBlock)failureBlock
                                   showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:qid forKey:@"id"];
    [params setValue:act forKey:@"act"];
    
    
    NSString *ur = [NSString stringWithFormat:@"%@/%@",DEF_API_pointPraise,qid];
    \
    //    DEF_DEBUG(@"%@ %@",params,ur);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:ur
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}


#pragma mark -- 我的相关
#pragma mark -- 个人资料（查看修改）、消息通知、我的抢答、我的主意、我的收藏、积点明细

#pragma mark - 1、获取律师信息
/**
 * 获取个人信息
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 *  @param id         律师id
 */

+ (void)getLawyerInfoByuid:(NSString *)uid
                 timestamp:(NSString *)timestamp
                      sign:(NSString *)sign
                 lawyer_id:(NSString *)lawyer_id
              SuccessBlock:(MHAsiSuccessBlock)successBlock
              failureBlock:(MHAsiFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:lawyer_id forKey:@"lawyer_id"];

    DEF_DEBUG(@"律师信息请求参数：params:%@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@%@",DEF_API_Lawyer,lawyer_id];
    
    [[MHAsiNetworkHandler sharedInstance] conURL:url
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
    
}

#pragma mark - 2、编辑律师的个人资料
/**
 * 获取个人信息
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 *  @param id         律师id
 *  @param [name/email/avatar/birth/address/introduce]
           [姓名/email/头像/出生日期/地址/简介]
 */

+ (void)changeLawerInfoByuid:(NSString *)uid
                   timestamp:(NSString *)timestamp
                        sign:(NSString *)sign
                   lawyer_id:(NSString *)lawyer_id
                      avatar:(NSString *)avatar
                       birth:(NSString *)birth
                         sex:(NSString *)sex
              lawyer_company:(NSString *)lawyer_company
                  work_title:(NSString *)work_title
                       email:(NSString *)email
                     city:(NSString *)city
                     region:(NSString *)region
                   introduce:(NSString *)introduce
                SuccessBlock:(MHAsiSuccessBlock)successBlock
                failureBlock:(MHAsiFailureBlock)failureBlock
                     showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:lawyer_id forKey:@"id"];
    [params setValue:avatar forKey:@"avatar"];
    [params setValue:birth forKey:@"birth"];
    [params setValue:sex forKey:@"sex"];
    [params setValue:lawyer_company forKey:@"lawyer_company"];
    [params setValue:work_title forKey:@"work_title"];
    [params setValue:email forKey:@"email"];
    [params setValue:city forKey:@"city"];
    [params setValue:region forKey:@"region"];
    [params setValue:introduce forKey:@"introduce"];
    DEF_DEBUG(@"修改律师个人信息：params:%@",params);
    
    NSString *url = [NSString stringWithFormat:@"%@%@",DEF_API_Lawyer,lawyer_id];
    [[MHAsiNetworkHandler sharedInstance] conURL:url
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}
#pragma mark - 2.1、编辑律师的职业信息
/**
 * 获取个人信息
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 *  @param id         律师id
 *  @param [name/email/avatar/birth/address/introduce]
 [姓名/email/头像/出生日期/地址/简介]
 */
+ (void)changeLawerProfessionalInfoByuid:(NSString *)uid
                   timestamp:(NSString *)timestamp
                        sign:(NSString *)sign
                   lawyer_id:(NSString *)lawyer_id
                       photo:(NSString *)photo
                    category:(NSString *)category
              edu_background:(NSString *)edu_background
               work_language:(NSString *)work_language
          work_qualification:(NSString *)work_qualification
                work_history:(NSString *)work_history
                   work_case:(NSString *)work_case
                SuccessBlock:(MHAsiSuccessBlock)successBlock
                failureBlock:(MHAsiFailureBlock)failureBlock
                     showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:lawyer_id forKey:@"id"];
    [params setValue:photo forKey:@"photo"];
    [params setValue:category forKey:@"category"];
    [params setValue:edu_background forKey:@"edu_background"];
    [params setValue:work_language forKey:@"work_language"];
    [params setValue:work_qualification forKey:@"work_qualification"];
    [params setValue:work_history forKey:@"work_history"];
    [params setValue:work_case forKey:@"work_case"];
    DEF_DEBUG(@"修改律师个人信息：params:%@",params);
    NSString *url = [NSString stringWithFormat:@"%@%@",DEF_API_Lawyer,lawyer_id];
    [[MHAsiNetworkHandler sharedInstance] conURL:url
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}
#pragma mark - 3、上传图片
/**
 * 上传图片
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */
+ (void)postAskQuestionImageToServerWithuid:(NSString *)uid
                                  timestamp:(NSString *)timestamp
                                       sign:(NSString *)sign
                                 imageArray:(NSArray *)imageArray
                               SuccessBlock:(MHAsiSuccessBlock)successBlock
                               failureBlock:(MHAsiFailureBlock)failureBlock
                                    showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:imageArray forKey:@"body"];
    
    DEF_DEBUG(@"上传图片的参数：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_UserUploadImage
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}



#pragma mark - 4、我的积分
/**
 *  我的积分
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */
+ (void)getMyPointWithuid:(NSString *)uid
                timestamp:(NSString *)timestamp
                     sign:(NSString *)sign
             SuccessBlock:(MHAsiSuccessBlock)successBlock
             failureBlock:(MHAsiFailureBlock)failureBlock
                  showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    DEF_DEBUG(@"我积分的参数：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_GetMyPoint
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

#pragma mark - 4、我的积点
/**
 *  我的积点
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */
+ (void)getMyDotWithuid:(NSString *)uid
                timestamp:(NSString *)timestamp
                     sign:(NSString *)sign
             SuccessBlock:(MHAsiSuccessBlock)successBlock
             failureBlock:(MHAsiFailureBlock)failureBlock
                  showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    DEF_DEBUG(@"我积点的参数：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_GetMyDot
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

#pragma mark - 获取提现的支付宝账户信息
/**
 *  获取提现的支付宝账户信息
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */
+ (void)getMoneyAccountInfoByuid:(NSString *)uid
                       timestamp:(NSString *)timestamp
                            sign:(NSString *)sign
                    SuccessBlock:(MHAsiSuccessBlock)successBlock
                    failureBlock:(MHAsiFailureBlock)failureBlock
                         showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    DEF_DEBUG(@"获取提现的支付宝账户信息的参数：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_MyDotMoneyAccount
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}



#pragma mark - 提现设置
/**
 *  提现设置
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 *  @param account     支付账户
 */
+ (void)settingMoneyAccountByuid:(NSString *)uid
                       timestamp:(NSString *)timestamp
                            sign:(NSString *)sign
                         account:(NSString *)account
                    SuccessBlock:(MHAsiSuccessBlock)successBlock
                    failureBlock:(MHAsiFailureBlock)failureBlock
                         showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:account forKey:@"account"];

    DEF_DEBUG(@"提现账户设置的参数：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_MyDotMoneyAccount
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}

#pragma mark - 提现申请
/**
 *  提现申请
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 [dot_num/amount/account]
 积点数/变现金额/支付账号
 */
+ (void)applyForDotToMoneyWithuid:(NSString *)uid
                        timestamp:(NSString *)timestamp
                             sign:(NSString *)sign
                          dot_num:(NSString *)dot_num
                           amount:(NSString *)amount
                          account:(NSString *)account
                     SuccessBlock:(MHAsiSuccessBlock)successBlock
                     failureBlock:(MHAsiFailureBlock)failureBlock
                          showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:dot_num forKey:@"dot_num"];
    [params setValue:amount forKey:@"amount"];
    [params setValue:account forKey:@"account"];
    
    DEF_DEBUG(@"提现申请的参数：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_dot_to_moneyApply
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}




#pragma mark - 5、我的抢答
/**
 * 我的抢答
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */
+ (void)getMyRaceQuestionAnswerWithuid:(NSString *)uid
                             timestamp:(NSString *)timestamp
                                  sign:(NSString *)sign
                          SuccessBlock:(MHAsiSuccessBlock)successBlock
                          failureBlock:(MHAsiFailureBlock)failureBlock
                               showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    DEF_DEBUG(@"我的抢答参数：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_getMyRaceQuestionAnswer
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}

#pragma mark - 6、我的消息
/**
 * 我的消息
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */
+ (void)getMyMessageWithuid:(NSString *)uid
                  timestamp:(NSString *)timestamp
                       sign:(NSString *)sign
               SuccessBlock:(MHAsiSuccessBlock)successBlock
               failureBlock:(MHAsiFailureBlock)failureBlock
                    showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    DEF_DEBUG(@"我的消息参数：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_getMyMessage
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}
+ (void)updateMyMessageWithuid:(NSString *)uid
                     timestamp:(NSString *)timestamp
                          sign:(NSString *)sign
                     messageID:(NSString *)messageID
                  SuccessBlock:(MHAsiSuccessBlock)successBlock
                  failureBlock:(MHAsiFailureBlock)failureBlock
                       showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:messageID forKey:@"id"];
    DEF_DEBUG(@"我的消息参数：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:[NSString stringWithFormat:@"%@/%@",DEF_API_updateMessage,messageID]
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}
#pragma mark - 7、我的主意
/**
 *  我的主意
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */
+ (void)getMyIdeaInfoByuid:(NSString *)uid
                 timestamp:(NSString *)timestamp
                      sign:(NSString *)sign
              SuccessBlock:(MHAsiSuccessBlock)successBlock
              failureBlock:(MHAsiFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    
    DEF_DEBUG(@"我的主意：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_MyIdea
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

#pragma mark -- 8、添加收藏问题
/**
 *  添加收藏问题
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */
+ (void)addMyFavoriteQuestionInfoByuid:(NSString *)uid
                             timestamp:(NSString *)timestamp
                                  sign:(NSString *)sign
                           question_id:(NSString *)question_id
                          SuccessBlock:(MHAsiSuccessBlock)successBlock
                          failureBlock:(MHAsiFailureBlock)failureBlock
                               showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:question_id forKey:@"question_id"];
    
    DEF_DEBUG(@"添加收藏：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_AddFavoriteQuestion
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
    
}

#pragma mark - 9、我收藏的问题
/**
 *  我收藏的问题
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */
+ (void)getMyFavoriteQuestionInfoByuid:(NSString *)uid
                             timestamp:(NSString *)timestamp
                                  sign:(NSString *)sign
                          SuccessBlock:(MHAsiSuccessBlock)successBlock
                          failureBlock:(MHAsiFailureBlock)failureBlock
                               showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    
    DEF_DEBUG(@"我的收藏：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_MyFavoriteQuestion
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
    
}

#pragma mark - 10、我收藏的律师
/**
 *  我收藏的律师
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */
+ (void)getMyFavoriteLawersInfoByuid:(NSString *)uid
                           timestamp:(NSString *)timestamp
                                sign:(NSString *)sign
                        SuccessBlock:(MHAsiSuccessBlock)successBlock
                        failureBlock:(MHAsiFailureBlock)failureBlock
                             showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    
    DEF_DEBUG(@"我收藏的律师：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_MyFavoriteLawer
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}
#pragma mark - 11、添加我收藏的律师
/**
 *  添加我收藏的律师
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 *  @param lawyer_id        lawyer_id
 */
+ (void)addMyFavoriteLawerToServerWithuid:(NSString *)uid
                                timestamp:(NSString *)timestamp
                                     sign:(NSString *)sign
                                lawyer_id:(NSString *)lawyer_id
                             SuccessBlock:(MHAsiSuccessBlock)successBlock
                             failureBlock:(MHAsiFailureBlock)failureBlock
                                  showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:lawyer_id forKey:@"lawyer_id"];
    
    DEF_DEBUG(@"添加我收藏的律师的params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_AddFavoriteLawer
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
    
}

#pragma mark - 12、删除收藏相关
/**
 *  我收藏的律师
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 act=question/lawyer,
 id=question_id/lawyer_id
 */
//删除收藏的问题或者律师
+ (void)deleteMyFavoriteInfoByuid:(NSString *)uid
                        timestamp:(NSString *)timestamp
                             sign:(NSString *)sign
                              act:(NSString *)act
                            idStr:(NSString *)idStr
                     SuccessBlock:(MHAsiSuccessBlock)successBlock
                     failureBlock:(MHAsiFailureBlock)failureBlock
                          showHUD:(BOOL)showHUD
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:act forKey:@"act"];
    [params setValue:idStr forKey:@"id"];
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_DeleteMyFavorite
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}




#pragma mark -- 获取对律师的评论信息
/**
 * 获取对律师的评论信息
 *
 * @param uid   用户的user_id

 */
+ (void)getLawerPingWithUid:(NSString *)uid
                   timestamp:(NSString *)timestamp
                        sign:(NSString *)sign
                   lawyer_id:(NSString *)lawyer_id
                SuccessBlock:(MHAsiSuccessBlock)successBlock
                failureBlock:(MHAsiFailureBlock)failureBlock
                     showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:lawyer_id forKey:@"lawyer_id"];
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_LawerPing
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
    
}

#pragma mark -- 分类相关

#pragma mark - 获取分类ID
+ (void)getCategoryIdSuccessBlock:(MHAsiSuccessBlock)successBlock
                     failureBlock:(MHAsiFailureBlock)failureBlock
                          showHUD:(BOOL)showHUD
{
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_getCategoryId
                                     networkType:MHAsiNetWorkGET
                                          params:nil
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

#pragma 问题列表
/**
 *
 *
 *  @param uid        (签名参数)用户id
 *  @param page_num    也说
 *  @param limit      每页的数量
 */


//首页的问题列表
+ (void)getQuestionListWithUserID:(NSString *)user_ID
                         page_num:(NSString *)pagNumber
                            limit:(NSString *)limit
                      category_id:(NSString *)category_id
                     SuccessBlock:(MHAsiSuccessBlock)successBlock
                     failureBlock:(MHAsiFailureBlock)failureBlock
                          showHUD:(BOOL)showHUD;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:user_ID forKey:@"uid"];
    [params setValue:pagNumber forKey:@"page_num"];
    [params setValue:limit forKey:@"limit"];
    [params setValue:category_id forKey:@"category_id"];
    
    DEF_DEBUG(@"%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_questionsList
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}
#pragma mark - 搜索
/**
 *  点赞
 *
 *  @param uid        (签名参数)用户id
 *  @param content     搜索内容
 *  @param page_num    分页
 *  @param limit       一页显示多少
 */
+ (void)searchQuestionWithContent:(NSString *)content
                              uid:(NSString *)uid
                         page_num:(NSString *)page_num
                            limit:(NSString *)limit
                     SuccessBlock:(MHAsiSuccessBlock)successBlock
                     failureBlock:(MHAsiFailureBlock)failureBlock
                          showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:content forKey:@"q"];
    [params setValue:page_num forKey:@"page_num"];
    [params setValue:limit forKey:@"limit"];
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_search
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}


#pragma mark - 意见反馈
/**
 *  我收藏的律师
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 *  @param app_version      版本
 *  @param content          内容
 */
//意见反馈
+ (void)feedBackIssuesWithuid:(NSString *)uid
                    timestamp:(NSString *)timestamp
                         sign:(NSString *)sign
                  app_version:(NSString *)app_version
                      content:(NSString *)content
                 SuccessBlock:(MHAsiSuccessBlock)successBlock
                 failureBlock:(MHAsiFailureBlock)failureBlock
                      showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:app_version forKey:@"app_version"];
    [params setValue:content forKey:@"content"];
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_FeedBackIssues
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}

#pragma mark - 9、我的提问
/**
 *  我的提问
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */
+ (void)getMyQuestionInfoByuid:(NSString *)uid
                     timestamp:(NSString *)timestamp
                          sign:(NSString *)sign
                  SuccessBlock:(MHAsiSuccessBlock)successBlock
                  failureBlock:(MHAsiFailureBlock)failureBlock
                       showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    
    DEF_DEBUG(@"我的提问：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_MyQuestion
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}


#pragma mark - 15、用户提问
/**
 * 用户提问
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 *  @param content    (签名参数)图片内容
 *  @param is_public   (签名参数)是否公开
 */
+ (void)postUserQuestionToServerWithuid:(NSString *)uid
                              timestamp:(NSString *)timestamp
                                   sign:(NSString *)sign
                                content:(NSString *)content
                              is_public:(NSString *)is_public
                                  image:(NSMutableString *)imageArray
                           SuccessBlock:(MHAsiSuccessBlock)successBlock
                           failureBlock:(MHAsiFailureBlock)failureBlock
                                showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:content forKey:@"content"];
    [params setValue:is_public forKey:@"is_public"];
    [params setValue:imageArray forKey:@"image"];


    DEF_DEBUG(@"用户提问的参数：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_UserAskQuestion
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}


#pragma mark - 17、出个主意
/**
 *  出个主意
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 *  @param qid         问题id
 *  @param content     主意内容
 */
+ (void)giveAnIdeaToServerWithuid:(NSString *)uid
                        timestamp:(NSString *)timestamp
                             sign:(NSString *)sign
                              qid:(NSString *)qid
                          content:(NSString *)content
                     SuccessBlock:(MHAsiSuccessBlock)successBlock
                     failureBlock:(MHAsiFailureBlock)failureBlock
                          showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:qid forKey:@"question_id"];
    [params setValue:content forKey:@"content"];
    
    DEF_DEBUG(@"出个主意的参数：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_GiveIdeaToquestionPing
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}



#pragma mark - 获取广告轮播图
/**
 *  获取广告轮播图
 */
+ (void)getBannerBySuccessBlock:(MHAsiSuccessBlock)successBlock
                   failureBlock:(MHAsiFailureBlock)failureBlock
                        showHUD:(BOOL)showHUD
{
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_Get_Banner
                                     networkType:MHAsiNetWorkGET
                                          params:nil
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}

#pragma mark - 3、律师注册
/**
 * 检验验证码
 *
 *  @param mobile   手机号码
 *  @param recode   验证码
 *  @param password 密码
 *  @param name     名字
 *  @param id_number 身份证号
 *  @param lawyer_license 律师执业证号
 
 */
+ (void)lawyerRegisterWithMobile:(NSString *)mobile
                          recode:(NSString *)recode
                        password:(NSString *)password
                            name:(NSString *)name
                       id_number:(NSString *)id_number
                  lawyer_license:(NSString *)lawyer_license
                    SuccessBlock:(MHAsiSuccessBlock)successBlock
                    failureBlock:(MHAsiFailureBlock)failureBlock
                         showHUD:(BOOL)showHUD
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:mobile forKey:@"mobile"];
    [params setValue:recode forKey:@"recode"];
    //密码需要MD5加密
    NSString *md5PassWord = [password md5];
    [params setValue:md5PassWord forKey:@"password"];
    
    [params setValue:name forKey:@"name"];
    [params setValue:id_number forKey:@"id_number"];
    [params setValue:lawyer_license forKey:@"lawyer_license"];

    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_LawyerRegister
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}
#pragma mark - 审核三证照片
/**
 *  审核三证照片
 *
 *  @param audit_pic  照片
 */
+ (void)uploadLawyerPhotoWithuid:(NSString *)uid
                       timestamp:(NSString *)timestamp
                            sign:(NSString *)sign
                       audit_pic:(NSString *)audit_pic
                    SuccessBlock:(MHAsiSuccessBlock)successBlock
                    failureBlock:(MHAsiFailureBlock)failureBlock
                         showHUD:(BOOL)showHUD;
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:audit_pic forKey:@"audit_pic"];

    
    DEF_DEBUG(@"出个主意的参数：params:%@",params);

    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_LawyerAudit
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}




#pragma mark -- 二期 f2f相关

/**
 *  申请成为预约律师
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 律师id/省市/区/封面照/价格/标题/介绍
 lawyer_id/city/region/photo/price/title/intr
 */
+ (void)applyForBeingOrderLawyerWithuid:(NSString *)uid
                              timestamp:(NSString *)timestamp
                                   sign:(NSString *)sign
                              lawyer_id:(NSString *)lawyer_id
                               category:(NSString *)category
                                   city:(NSString *)city
                                 region:(NSString *)region
                                  photo:(NSString *)photo
                                  price:(NSString *)price
                                  title:(NSString *)title
                                   intr:(NSString *)intr
                           SuccessBlock:(MHAsiSuccessBlock)successBlock
                           failureBlock:(MHAsiFailureBlock)failureBlock
                                showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:lawyer_id forKey:@"lawyer_id"];
    [params setValue:category forKey:@"category"];
    [params setValue:city forKey:@"city"];
    [params setValue:region forKey:@"region"];
    [params setValue:photo forKey:@"photo"];
    [params setValue:price forKey:@"price"];
    [params setValue:title forKey:@"title"];
    [params setValue:intr forKey:@"intr"];
    
    DEF_DEBUG(@"申请成为预约律师的参数：params:%@",params);
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_applyForBeingOrderLawyer
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}

/**
 *  修改“预约律师
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 律师id/省市/区/封面照/价格/标题/介绍
 lawyer_id/city/region/photo/price/title/intr
 */

+ (void)changeOrderLawyerInfoWithuid:(NSString *)uid
                           timestamp:(NSString *)timestamp
                                sign:(NSString *)sign
                           lawyer_id:(NSString *)lawyer_id
                           product_id:(NSString *)product_id
                            category:(NSString *)category
                                city:(NSString *)city
                              region:(NSString *)region
                               photo:(NSString *)photo
                               price:(NSString *)price
                               title:(NSString *)title
                                intr:(NSString *)intr
                        SuccessBlock:(MHAsiSuccessBlock)successBlock
                        failureBlock:(MHAsiFailureBlock)failureBlock
                             showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:lawyer_id forKey:@"lawyer_id"];
    [params setValue:city forKey:@"city"];
    [params setValue:category forKey:@"category"];
    [params setValue:region forKey:@"region"];
    [params setValue:photo forKey:@"photo"];
    [params setValue:price forKey:@"price"];
    [params setValue:title forKey:@"title"];
    [params setValue:intr forKey:@"intr"];
    
    DEF_DEBUG(@"修预约律师的参数：params:%@",params);
    NSString *urlStr = [NSString stringWithFormat:@"%@/%@",DEF_API_applyForBeingOrderLawyer,product_id];
    
    [[MHAsiNetworkHandler sharedInstance] conURL:urlStr
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];

}

/**
 *  查看预约律师
 *
 *  @param uid        (签名参数)律师id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */

+ (void)lookOverOrderLawyerInfoWithuid:(NSString *)uid
                             timestamp:(NSString *)timestamp
                                  sign:(NSString *)sign
                          SuccessBlock:(MHAsiSuccessBlock)successBlock
                          failureBlock:(MHAsiFailureBlock)failureBlock
                               showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    DEF_DEBUG(@"查看预约律师的参数：params:%@",params);
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",DEF_API_applyForBeingOrderLawyer];
    
    [[MHAsiNetworkHandler sharedInstance] conURL:urlStr
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

/**
 * 我的订单
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 *  @param type       21.律师未完成的订单，22.律师已完成的订单
 */
+ (void)getMyOrderWithuid:(NSString *)uid
                timestamp:(NSString *)timestamp
                     sign:(NSString *)sign
                     type:(NSString *)type
             SuccessBlock:(MHAsiSuccessBlock)successBlock
             failureBlock:(MHAsiFailureBlock)failureBlock
                  showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:type forKey:@"type"];
    
    DEF_DEBUG(@"我订单的参数：params:%@",params);
    
    [[MHAsiNetworkHandler sharedInstance] conURL:DEF_API_Get_f2fMyOrder
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
    
}

/**
 * 修改预约订单
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 *  @param orderID     订单id
 优惠券id/优惠券金额/支付类型/支付金额/约见日期/订单状态
 coupon_id/coupon_amount/pay_type/pay_amount/meet_date/state(1已支付,2用户取消订单，3律师取消订单，4律师确定订单，5用户确认已完成约见，7申请平台介入)
 */
+ (void)changeOrderWithuid:(NSString *)uid
                 timestamp:(NSString *)timestamp
                      sign:(NSString *)sign
                   orderID:(NSString *)orderID
                 coupon_id:(NSString *)coupon_id
             coupon_amount:(NSString *)coupon_amount
                  pay_type:(NSString *)pay_type
                pay_amount:(NSString *)pay_amount
                 meet_date:(NSString *)meet_date
                     state:(NSString *)state
              SuccessBlock:(MHAsiSuccessBlock)successBlock
              failureBlock:(MHAsiFailureBlock)failureBlock
                   showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    [params setValue:coupon_id forKey:@"coupon_id"];
    [params setValue:coupon_amount forKey:@"coupon_amount"];
    [params setValue:pay_type forKey:@"pay_type"];
    [params setValue:pay_amount forKey:@"pay_amount"];
    [params setValue:meet_date forKey:@"meet_date"];
    [params setValue:state forKey:@"state"];
    
    DEF_DEBUG(@"修改预约订单的参数：params:%@",params);
    NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_Get_f2fOrder,orderID];
    [[MHAsiNetworkHandler sharedInstance] conURL:url
                                     networkType:MHAsiNetWorkPOST
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
}

/**
 * 显示订单详情
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 *  @param orderID     订单id
 */
+ (void)showOrderWithuid:(NSString *)uid
               timestamp:(NSString *)timestamp
                    sign:(NSString *)sign
                 orderID:(NSString *)orderID
            SuccessBlock:(MHAsiSuccessBlock)successBlock
            failureBlock:(MHAsiFailureBlock)failureBlock
                 showHUD:(BOOL)showHUD
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:uid forKey:@"uid"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:sign forKey:@"sign"];
    
    DEF_DEBUG(@"订单详情的参数：params:%@",params);
    NSString *url = [NSString stringWithFormat:@"%@/%@",DEF_API_Get_f2fOrder,orderID];
    [[MHAsiNetworkHandler sharedInstance] conURL:url
                                     networkType:MHAsiNetWorkGET
                                          params:params
                                        delegate:nil
                                         showHUD:showHUD
                                    successBlock:successBlock
                                    failureBlock:failureBlock];
    
}




@end
