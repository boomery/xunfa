//
//  MHAsiNetworkUrl.h
//  MHProject
//
//  Created by Andy on 15/4/23.
//  Copyright (c) 2015年 Andy. All rights reserved.
//

#ifndef MHProject_MHAsiNetworkUrl_h
#define MHProject_MHAsiNetworkUrl_h


/**
 *  API HOST
 */

//正式线上使用
//#define API_HOST @"http://139.196.60.16/v1"

//内部使用
#define API_HOST @"http://121.41.72.233/v1"
//#define API_HOST @"http://dev_iapi.findsolution.cn/v1"


// 接口路径全拼
#define PATH(_path) [NSString stringWithFormat:_path, API_HOST]
/**
 *  请在此定义请求URL
 */
#define DEF_API_URL  PATH(@"%@/api")


//#pragma mark -- 公共方法，获取时间戳和城市信息

#define DEF_API_timestamp PATH(@"%@/comm/timestamp")    //获取服务器的时间戳
#define DEF_API_getCity PATH(@"%@/comm/city")           //获取城市
#define DEF_API_Apns_device PATH(@"%@/apns/device")    //推送


//#pragma mark -- 登录、注册、忘记密码

#define DEF_API_login PATH(@"%@/lawyer/login")           //登录接口
#define DEF_API_login_out PATH(@"%@/lawyer/logout")       //注销接口
#define DEF_API_forgetRecode PATH(@"%@/user/password_forget") //忘记密码
#define DEF_API_recode PATH(@"%@/comm/recode")           //获取验证码
#define DEF_API_checkRecode PATH(@"%@/comm/recode/check")//检验验证码
#define DEF_API_register_agreement PATH(@"%@/lawyer/register_agreement")//注册协议
#define DEF_API_about_us PATH(@"%@/comm/about_us")  //关于询法
#define DEF_API_modifyPassword PATH(@"%@/user/password_modify")    //修改密码
#define DEF_API_LawyerRegister PATH(@"%@/lawyer/register")  //律师注册
#define DEF_API_LawyerAudit PATH(@"%@/lawyer/audit")  //三证照片提交审核

//#pragma mark -- 问题相关（抢答问题、抢答、问题列表）

#define DEF_API_questionsList PATH(@"%@/questions")        //问题列表
#define DEF_API_RaceQuestionsList PATH(@"%@/question/race")//待抢答的问题列表
#define DEF_API_AnswerRaceQuestion PATH(@"%@/answer")      //回答抢答的问题

//#pragma mark -- 个人资料（查看修改）、消息通知、我的抢答、我的主意、我的收藏、积点明细

#define DEF_API_Lawyer PATH(@"%@/lawyer/")                         //律师信息相关
#define DEF_API_UserUploadImage PATH(@"%@/image/upload")           //上传头像
#define DEF_API_GetMyPoint PATH(@"%@/my/point")                    //我的积分
#define DEF_API_GetMyDot PATH(@"%@/lawyer/dot")                 //我的积点
#define DEF_API_MyDotMoneyAccount PATH(@"%@/lawyer/account")   //提现账户设置
#define DEF_API_dot_to_moneyApply PATH(@"%@/lawyer/dot_to_money")//提现申请
#define DEF_API_getMyRaceQuestionAnswer PATH(@"%@/my/answer")      //我的抢答
#define DEF_API_getMyMessage PATH(@"%@/my/message")                //我的消息
#define DEF_API_updateMessage PATH(@"%@/message")                //更改消息状态
#define DEF_API_MyIdea PATH(@"%@/my/ping")                         //我的主意
#define DEF_API_MyFavoriteQuestion PATH(@"%@/my/favorite/question") //我收藏的问题
#define DEF_API_AddFavoriteQuestion PATH(@"%@/my/favorite/question")//添加收藏的问题
#define DEF_API_MyFavoriteLawer PATH(@"%@/my/favorite/lawyer")      //我收藏的律师
#define DEF_API_AddFavoriteLawer PATH(@"%@/my/favorite/lawyer")     //添加收藏律师
#define DEF_API_DeleteMyFavorite PATH(@"%@/my/favorite/del")//删除收藏的律师或者问题
#define DEF_API_LawerPing PATH(@"%@/lawyer/ping")      //获取律师的评价信息

//#pragma mark -- 分类相关
#define DEF_API_getCategoryId PATH(@"%@/question/category")  //分类Id
#define DEF_API_search PATH(@"%@/search")//搜索内容;
#define DEF_API_FeedBackIssues PATH(@"%@/issue")//反馈问题
#define DEF_API_MyQuestion PATH(@"%@/my/question") //我的提问
#define DEF_API_UserAskQuestion PATH(@"%@/question") //用户提问
#define DEF_API_questionsDetail PATH(@"%@/question/answer")//问题详情
#define DEF_API_Question_AllDetail PATH(@"%@/question")//问题全部详情
#define DEF_API_GiveIdeaToquestionPing PATH(@"%@/question/ping")//出个主意
#define DEF_API_QuestionPlus PATH(@"%@/question/plus")//获取某一回答的追问
#define DEF_API_QuestionPlusSendMessage PATH(@"%@/question/plus")// 继续问
#define DEF_API_AnswerPlusSendMessage PATH(@"%@/answer/plus")// 回答追问
#define DEF_API_tip_offQuestion PATH(@"%@/tip_off")//举报
#define DEF_API_pointPraise PATH(@"%@/like")//点赞
#define DEF_API_Get_Banner PATH(@"%@/comm/banner")//广告轮播图


//#pragma mark -- 二期 f2f相关
#define DEF_API_applyForBeingOrderLawyer PATH(@"%@/f2f/product")//申请成为预约律师
#define DEF_API_Get_f2fMyOrder   PATH(@"%@/f2f/my/order")//我的订单
#define DEF_API_Get_f2fOrder   PATH(@"%@/f2f/order")//(修改)订单









#endif
