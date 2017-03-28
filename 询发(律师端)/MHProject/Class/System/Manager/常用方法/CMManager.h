//
//  CMManager.h
//  BMProject
//
//  Created by DuBin on 15/4/19.
//  Copyright (c) 2015年 DuBin. All rights reserved.
//

/**
 *  常用方法管理器
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SingletonTemplate.h"   // 单例模板


@interface CMManager : NSObject

singleton_for_header(CMManager)



#pragma mark - 判断字符串是否为空
/**
 *  判断字符串是否为空
 *
 *  @param string 要判断的字符串
 *
 *  @return 返回YES为空，NO为不空
 */
- (BOOL)isBlankString:(NSString *)string;

#pragma mark - 判断身份证号是否正确
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

#pragma mark - 判断是否为真实手机号码
/**
 *  判断是否为真实手机号码
 *
 *  @param mobile 手机号
 *
 *  @return 返回YES为真实手机号码，NO为否
 */
- (BOOL)checkInputMobile:(NSString *)_text;


#pragma mark - 判断email格式是否正确
/**
 *  判断email格式是否正确
 *
 *  @param emailString 邮箱
 *
 *  @return 返回YES为Email格式正确，NO为否
 */
- (BOOL)isAvailableEmail:(NSString *)emailString;


#pragma mark - 姓名验证
/**
 *  姓名验证
 *
 *  @param name 姓名
 *
 *  @return 返回YES为姓名规格正确，NO为否
 */
- (BOOL)isValidateName:(NSString *)name;


#pragma mark - 时间戳转时间格式
/**
 *  时间戳转时间格式
 *
 *  @param timestamp    传入时间戳
 *  @param format       格式,如"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 普通时间
 */
- (NSString *)changeTimestampToCommonTime:(long)time format:(NSString *)format;


#pragma mark - 时间格式转时间戳
/**
 *  时间格式转时间戳
 *
 *  @param time   普通时间
 *  @param format 格式,如"yyyy-MM-dd HH:mm:ss"
 *
 *  @return 时间戳
 */
- (long)changeCommonTimeToTimestamp:(NSString *)time format:(NSString *)format;


#pragma mark - 获取当前使用语言
/**
 *  获取当前使用语言
 *
 *  @return 当前使用语言
 */
- (NSString *)currentLanguage;


#pragma mark - 打印出项目工程里自定义字体名
/**
 *  打印出项目工程里自定义字体名
 */
- (void)printCustomFontName;


#pragma mark - 获取当前的时间戳
-(NSString *)getCurrentTimestap;

#pragma mark - 生成签名
-(NSString *)getSignByURL:(NSString *)url timestamp:(NSString *)timestamp token:(NSString *)token;



@end
