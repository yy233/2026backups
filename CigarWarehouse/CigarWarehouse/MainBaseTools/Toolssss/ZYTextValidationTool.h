//
//  ZYTextValidationTool.h
//  Community
//
//  Created by ZY on 2021/5/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYTextValidationTool : NSObject

//检测  邮箱是否正确
+ (BOOL)validateEmail:(NSString *)candidate;

//检测  用户名
+ (BOOL)validateName:(NSString *)candidate;

//密码
+ (BOOL)validatePassword:(NSString *)candidate;

//预注册密码
+ (BOOL)validatePrePassword:(NSString *)candidate;

//手机号
+ (BOOL)validatePhone:(NSString *)candidate;

//邮编
+ (BOOL)validatePostCode:(NSString *)candidate;

//图片格式
+ (BOOL)validatePictureType:(NSString *)candidate;

//中文
+ (BOOL)validateChinese:(NSString *)candidate;

//字母和数字
+ (BOOL)validateCharNum:(NSString *)candidate;

//社保卡号
+ (BOOL)validateSocialCard:(NSString *)candidate;

//身份证号
+ (BOOL)validateIDCard:(NSString *)candidate;

@end

NS_ASSUME_NONNULL_END
