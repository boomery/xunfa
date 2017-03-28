//
//  MHAsiNetworkAPI.h
//  MHProject
//
//  Created by Andy on 15/4/23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHAsiNetworkDefine.h"

@interface MHAsiNetworkAPI : NSObject

#pragma mark --
#pragma mark -- 一、公共方法，获取时间戳和城市信息
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
                         showHUD:(BOOL)showHUD;

#pragma mark - 获取城市区域
/**
 *  获取城市区域
 */
+ (void)getCityBySuccessBlock:(MHAsiSuccessBlock)successBlock
                 failureBlock:(MHAsiFailureBlock)failureBlock
                      showHUD:(BOOL)showHUD;


#pragma mark - 获取时间戳
/**
 *  时间戳
 */
+ (void)getTimestampBySuccessBlock:(MHAsiSuccessBlock)successBlock
                   failureBlock:(MHAsiFailureBlock)failureBlock
                        showHUD:(BOOL)showHUD;


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
                           showHUD:(BOOL)showHUD;

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
                           showHUD:(BOOL)showHUD;



#pragma mark --
#pragma mark -- 二、登录、注册、忘记密码

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
                showHUD:(BOOL)showHUD;

#pragma mark - 2、获取验证码
/**
 *  验证码
 *
 *  @param mobile   手机号码
 */

+ (void)getRecodeWithMobile:(NSString *)mobile
               SuccessBlock:(MHAsiSuccessBlock)successBlock
               failureBlock:(MHAsiFailureBlock)failureBlock
                    showHUD:(BOOL)showHUD;


#pragma mark - 2、忘记密码
/**
 *  验证码
 *
 *  @param mobile   手机号码
 */
+ (void)getForgetRecodeWithMobile:(NSString *)mobile
               SuccessBlock:(MHAsiSuccessBlock)successBlock
               failureBlock:(MHAsiFailureBlock)failureBlock
                    showHUD:(BOOL)showHUD;


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
                      showHUD:(BOOL)showHUD;

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
                         showHUD:(BOOL)showHUD;
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


#pragma mark - 4、注册协议
/**
 * 注册协议
 */
+ (void)registerAgreementWithSuccessBlock:(MHAsiSuccessBlock)successBlock
                             failureBlock:(MHAsiFailureBlock)failureBlock
                                  showHUD:(BOOL)showHUD;

#pragma mark - 关于询法
/**
 * 关于询法
 */
+ (void)getAboutUsInfoWithSuccessBlock:(MHAsiSuccessBlock)successBlock
                          failureBlock:(MHAsiFailureBlock)failureBlock
                               showHUD:(BOOL)showHUD;


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
                         showHUD:(BOOL)showHUD;
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
                showHUD:(BOOL)showHUD;


#pragma mark --
#pragma mark -- 三、问题相关（抢答问题、抢答、问题列表）

#pragma mark -- 1、获取问题列表
/**
 *   获取问题列表
 *
 *  @param uid   用户的user_id
 */

+ (void)getQuestionListWithUserID:(NSString *)user_ID
                     SuccessBlock:(MHAsiSuccessBlock)successBlock
                     failureBlock:(MHAsiFailureBlock)failureBlock
                          showHUD:(BOOL)showHUD;

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
                           showHUD:(BOOL)showHUD;


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
                        showHUD:(BOOL)showHUD;


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
                        showHUD:(BOOL)showHUD;


#pragma mark -- 5、问题详情
/**
 *  问题详情
 *
 *  @param uid   用户的question_id
 */
+ (void)getQuestionDetailQuestion_id:(NSString *)question_id
                        SuccessBlock:(MHAsiSuccessBlock)successBlock
                        failureBlock:(MHAsiFailureBlock)failureBlock
                             showHUD:(BOOL)showHUD;

#pragma mark - 获取问题全部详情
+ (void)getQuestionAllDetailWithUid:(NSString *)uid
                          timestamp:(NSString *)timestamp
                               sign:(NSString *)sign
                        Question_id:(NSString *)question_id
                       SuccessBlock:(MHAsiSuccessBlock)successBlock
                       failureBlock:(MHAsiFailureBlock)failureBlock
                            showHUD:(BOOL)showHUD;
#pragma mark - 获取某一回答的追问
+ (void)getQuestionPlusAnswer_id:(NSString *)answer_id
                             uid:(NSString *)uid
                    SuccessBlock:(MHAsiSuccessBlock)successBlock
                    failureBlock:(MHAsiFailureBlock)failureBlock
                         showHUD:(BOOL)showHUD;

#pragma mark - 继续追问
+ (void)getQuestionPlusSendMessageByuid:(NSString *)uid
                              timestamp:(NSString *)timestamp
                                   sign:(NSString *)sign
                              answer_id:(NSString *)answer_id
                                content:(NSString *)content
                           SuccessBlock:(MHAsiSuccessBlock)successBlock
                           failureBlock:(MHAsiFailureBlock)failureBlock
                                showHUD:(BOOL)showHUD;
#pragma mark - 回答追问

+ (void)getAnswerPlusSendMessageByuid:(NSString *)uid
                            timestamp:(NSString *)timestamp
                                 sign:(NSString *)sign
                            answer_id:(NSString *)answer_id
                              content:(NSString *)content
                         SuccessBlock:(MHAsiSuccessBlock)successBlock
                         failureBlock:(MHAsiFailureBlock)failureBlock
                              showHUD:(BOOL)showHUD;

#pragma mark - 、举报
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
                              showHUD:(BOOL)showHUD;

#pragma mark - 点赞
+ (void)pointPraiseQuestionToServerWithuid:(NSString *)uid
                                 timestamp:(NSString *)timestamp
                                      sign:(NSString *)sign
                                       qid:(NSString *)qid
                                       act:(NSString *)act
                              SuccessBlock:(MHAsiSuccessBlock)successBlock
                              failureBlock:(MHAsiFailureBlock)failureBlock
                                   showHUD:(BOOL)showHUD;
#pragma mark --
#pragma mark -- 四、个人资料（查看修改）、消息通知、我的抢答、我的主意、我的收藏、积点明细

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
                   showHUD:(BOOL)showHUD;


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
                     showHUD:(BOOL)showHUD;
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
                                 showHUD:(BOOL)showHUD;
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
                                    showHUD:(BOOL)showHUD;

#pragma mark - 4、我的积分
/**
 * 上传图片
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
                  showHUD:(BOOL)showHUD;

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
                showHUD:(BOOL)showHUD;



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
                         showHUD:(BOOL)showHUD;

#pragma mark - 提现账户设置
/**
 *  提现账户设置
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
                         showHUD:(BOOL)showHUD;

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
                         showHUD:(BOOL)showHUD;



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
                  showHUD:(BOOL)showHUD;

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
                         showHUD:(BOOL)showHUD;

#pragma mark - 6、2 更改消息读取状态
/**
 * 我的消息
 *
 *  @param uid        (签名参数)用户id
 *  @param timestamp  (签名参数)时间戳
 *  @param sign       (签名参数)签名
 */
+ (void)updateMyMessageWithuid:(NSString *)uid
                  timestamp:(NSString *)timestamp
                       sign:(NSString *)sign
                  messageID:(NSString *)messageID
               SuccessBlock:(MHAsiSuccessBlock)successBlock
               failureBlock:(MHAsiFailureBlock)failureBlock
                    showHUD:(BOOL)showHUD;
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
                   showHUD:(BOOL)showHUD;

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
                               showHUD:(BOOL)showHUD;

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
                               showHUD:(BOOL)showHUD;

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
                             showHUD:(BOOL)showHUD;
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
                                  showHUD:(BOOL)showHUD;

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
                          showHUD:(BOOL)showHUD;

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
                     showHUD:(BOOL)showHUD;

#pragma mark -- 分类相关
#pragma mark - 获取分类ID
+ (void)getCategoryIdSuccessBlock:(MHAsiSuccessBlock)successBlock
                     failureBlock:(MHAsiFailureBlock)failureBlock
                          showHUD:(BOOL)showHUD;

#pragma mark - 根据类别id获取的问题列表
+ (void)getQuestionListWithUserID:(NSString *)user_ID
                         page_num:(NSString *)pagNumber
                            limit:(NSString *)limit
                      category_id:(NSString *)category_id
                     SuccessBlock:(MHAsiSuccessBlock)successBlock
                     failureBlock:(MHAsiFailureBlock)failureBlock
                          showHUD:(BOOL)showHUD;
#pragma mark - 搜索
/**
 *  搜索
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
                          showHUD:(BOOL)showHUD;





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
                      showHUD:(BOOL)showHUD;



































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
                   showHUD:(BOOL)showHUD;



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
                                showHUD:(BOOL)showHUD;


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
                          showHUD:(BOOL)showHUD;
#pragma mark - 获取广告轮播图
/**
 *  获取广告轮播图
 */
+ (void)getBannerBySuccessBlock:(MHAsiSuccessBlock)successBlock
                   failureBlock:(MHAsiFailureBlock)failureBlock
                        showHUD:(BOOL)showHUD;




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
                          showHUD:(BOOL)showHUD;

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
                                showHUD:(BOOL)showHUD;

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
                             showHUD:(BOOL)showHUD;



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
                  showHUD:(BOOL)showHUD;


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
                   showHUD:(BOOL)showHUD;

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
                 showHUD:(BOOL)showHUD;




@end
