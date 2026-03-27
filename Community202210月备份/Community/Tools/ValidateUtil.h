//
//  ValidateUtil.h
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ValidateUtil : NSObject
/**
 限制手机号输入格式
 */
 
+ (BOOL)isMatchPhoneNumberFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string;
/**
 限制字符和数字等
 */
+ (BOOL)isMatchPasswordFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string;

/**
 /^(([a-zA-Z]+[0-9]+)|([0-9]+[a-zA-Z]+)|([a-z]+[@#%])|([0-9]+[@#%]))([a-zA-Z0-9@#%]*)$/
 密码要求 以字母(大小写)或数字开头，至少包含字母、数字、特殊字符(上式举例“@#%”)中的两种字符
 */
+(BOOL)isMachPasswordJudgeBeforeSendingAgainWithString:(NSString *)string;
#pragma mark == 数字 字母  最大长度
+(BOOL)isMachPasswordWithTextField:(UITextField *)textF anMaxNumInt:(NSInteger)maxInt String:(NSString *)string;

/**
 限制数字6位
 */
+ (BOOL)isMatchCodeFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string;


/**
 限制数字18位
 */
+ (BOOL)isMatchIdCardNumberFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string;

/**
 车牌号
*/
#pragma mark === 车牌
+ (BOOL)isMatchCarCodeNumberWithAllString:(NSString *)string;
//+ (BOOL)isMatchCarCodeNumberFormat:(UITextField *)textField range:(NSRange)range string:(NSString *)string;

//+ (BOOL)isMobileNumber:(NSString *)phone;
 /**
  验证邮箱格式
 */
//+ ( BOOL )validateEmail:( NSString *)email;
/**
  验证身份证号格式
 */
//+ ( BOOL )validateIdentityCard: ( NSString *)identityCard;
/**
  验证银行卡格式
 */

//+ (BOOL)validateBankCardNumber:(NSString *)cardNumber;


/**金额*/
- (BOOL)priceFormat:(NSString *)price;

@end

NS_ASSUME_NONNULL_END
