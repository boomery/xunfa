//
//  BMNetWorkURLs.h
//  BlueMobiProject
//
//  Created by 朱 亮亮 on 14-5-12.
//  Copyright (c) 2014年 朱 亮亮. All rights reserved.
//

#ifndef BlueMobiProject_BMNetWorkURLs_h
#define BlueMobiProject_BMNetWorkURLs_h

//Code=-1001 "The request timed out."
//Code=-1009 "The Internet connection appears to be offline."
//Code=-1004 "Could not connect to the server."

/**
 *  超时错误序号 －1001
 */
#define API_COULD_NOT_CONNECT_ERROR -1001

/**
 *  API的HOST
 */
//#define API_HOST @"http://www.sendm.cn/index.php?app=api&"

#define API_HOST @"http://10.58.132.16:8080/huafa"

/**
 *  Socket的HOST
 */
#define SOCKET_HOST @"58.83.147.106"

/**
 *  Socket的PORT
 */
#define SOCKET_PORT 10000

/// Class
#define PublicitfcClass @"Publicitfc"
#define UseritfcClass @"Useritfc"
#define WeiboitfcClass @"Weiboitfc"


/// 请在此定义请求URL


// 01. 登录接口
#define LOGIN                      [NSString stringWithFormat:@"%@/app/member/login.do", API_HOST]

// 02.注册
#define REGIST                     [NSString stringWithFormat:@"%@/app/member/regist.do", API_HOST]

// 03.获取验证码
#define AUTHCODE                   [NSString stringWithFormat:@"%@/app/common/getAuthCode.do", API_HOST]

// 04.根据分类组ID取得分类组的所有分类信息
#define CLASSFILIST                   [NSString stringWithFormat:@"%@/app/common/codeList.do", API_HOST]

// 05.取得根据城市ID取得区县一览信息
#define COUNTYLIST                   [NSString stringWithFormat:@"%@/app/common/areaList.do", API_HOST]


// 06.取得城市一览信息
#define CLTYLIST                  [NSString stringWithFormat:@"%@/app/common/normalCityList.do", API_HOST]

// 07.取得城市一览分组后信息
#define COMMONCITYLIST                   [NSString stringWithFormat:@"%@/app/common/cityList.do", API_HOST]

// 08.取得省份一览信息
#define PROVINCELIST                   [NSString stringWithFormat:@"%@/app/common/provinceList.do", API_HOST]

// 09.用户完善个人资料
#define MEMBERPERFECT                   [NSString stringWithFormat:@"%@/app/member/perfect.do", API_HOST]


// 10.取得登录用户信息
#define GETUSERINFO                   [NSString stringWithFormat:@"%@/app/member/getUserInfo.do", API_HOST]

// 11.用户绑定物业
#define BINDINGPROPERTY                   [NSString stringWithFormat:@"%@/app/member/bindingProperty.do", API_HOST]


//==========================================================

#pragma mark- 首页



// 12.获取公告列表
#define BULLETINLIST                   [NSString stringWithFormat:@"%@/app/bulletin/searchList.do", API_HOST]

// 13.获取公告详情
#define BULLETINDETAILS                   [NSString stringWithFormat:@"%@/app/bulletin/details.do", API_HOST]

// 17.保存用户的保修信息
#define REPAIRSAVE                   [NSString stringWithFormat:@"%@/app/repair/save.do", API_HOST]

// 19.查看用户的保修历史
#define REPAIRLIST                   [NSString stringWithFormat:@"%@/app/repair/searchList.do", API_HOST]

//保修记录打分
#define SETREPAIRGRADE               [NSString stringWithFormat:@"%@/app/repair/grade.do", API_HOST]
// 20.获取保修详情
#define REPAIRDETAILS                   [NSString stringWithFormat:@"%@/app/repair/details.do", API_HOST]



// 21.保存用户的投诉建议信息
#define COMPLAINSAVE                   [NSString stringWithFormat:@"%@/app/complaintsSugg/save.do", API_HOST]


// 22.查看用户的投诉建议历史
#define COMPLAINLIST                   [NSString stringWithFormat:@"%@/app/complaintsSugg/searchList.do", API_HOST]


// 23.查看投诉建议详情
#define COMPLAINDETAIL                   [NSString stringWithFormat:@"%@/app/complaintsSugg/details.do", API_HOST]



//==========================================================




#pragma mark-我的
// 26.收藏场馆、老师或者课程  根据类型区分是评价场馆、老师、课程。
#define COLLECTION                   [NSString stringWithFormat:@"%@/app/collection/collection.do", API_HOST]

// 27.查询收藏场馆、老师或者课程
#define SEARCHCOLLECTION                   [NSString stringWithFormat:@"%@/app/collection/searchCollection.do", API_HOST]

// 50.取得关于我们信息
#define ABOUTUSDETAIL                   [NSString stringWithFormat:@"%@/app/aboutUs/aboutUsDetail.do", API_HOST]

// 51.提交意见反馈
#define FEEDBACK                   [NSString stringWithFormat:@"%@/app/feedBack/feedBack.do", API_HOST]



#endif

