//
//  TSRegularExpressionUtil.h
//  OpenAllTheWay
//
//  Created by andy on 14-12-10.
//  Copyright (c) 2014年 andy. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TSRegularExpressionUtil : NSObject

//邮箱
+ (BOOL) validateEmail:(NSString *)email;
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;
//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo;
//车型
+ (BOOL) validateCarType:(NSString *)CarType;
//用户名
+ (BOOL) validateUserName:(NSString *)name;
//密码
+ (BOOL) validatePassword:(NSString *)passWord;
+ (BOOL) iszimuWithNumbervalidatePassword:(NSString *)passWord;

//昵称
+ (BOOL) validateNickname:(NSString *)nickname;
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//银行卡
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber;
//银行卡后四位
+ (BOOL) validateBankCardLastNumber: (NSString *)bankCardNumber;
//CVN
+ (BOOL) validateCVNCode: (NSString *)cvnCode;
//month
+ (BOOL) validateMonth: (NSString *)month;
//month
+ (BOOL) validateYear: (NSString *)year;
//verifyCode
+ (BOOL) validateVerifyCode: (NSString *)verifyCode;


//注册密码
+ (BOOL) validateRegisterPassword:(NSString *)passWord;
//判断所有的电话号码
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (BOOL)checkInputMobile:(NSString *)_moblie;




@end
