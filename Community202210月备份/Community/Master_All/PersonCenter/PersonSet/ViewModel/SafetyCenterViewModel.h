//
//  SafetyCenterModel.h
//  Community
//
//  Created by 余莹 on 2021/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SafetyCenterViewModel : NSObject
//________________________________
/**
 验证码实否正确的接口
 */
+ (void)safetyCenterCheckCodeWithCodeNum:(NSString *)codeStr withPhoneNumStr:(NSString *)phoneStr withDicBlock:(BaseDicAndSuccessBoolBlock)block;
 
//________________________________
/**
改变手机号 给手机号发送code的申请
 */
+ (void)changePhoneToSendCodeWithTheNewPhoneNumStr:(NSString*)nPhoneStr withDicBlock:(BaseDicAndSuccessBoolBlock)block;
/**
改变手机号   登录的时候用的接口
 */
+ (void)changePhoneToSendLastAuthTokenCheckWithPhoneStr:(NSString*)nPhoneStr withCodeStr:(NSString *)codeStr withDicBlock:(BaseDicAndSuccessBoolBlock)block;
/**
改变手机号 给手机号发送authToken +token+ account 非登录的接口
 */
+ (void)changePhoneToSendLastAuthTokenCheckWithPhoneStr:(NSString*)nPhoneStr withAuthTokenStr:(NSString *)authTokenStr withDicBlock:(BaseDicAndSuccessBoolBlock)block;
//________________________________
/**
改变付钱的秘密码  给手机号发送code的申请
 */
+ (void)changePayPasswordToSendCodeWithTheNewPhoneNumStr:(NSString*)nPhoneStr withDicBlock:(BaseDicAndSuccessBoolBlock)block;
/**
改变付钱的秘密码  设置付钱密
 */
+ (void)changePayPasswordToSendPasswordStr:(NSString *)payPassword  withDicBlock:(BaseDicAndSuccessBoolBlock)block;
/**
改变付钱的秘密码  设置付钱密(V2)
 */
+ (void)changePayPasswordV2ToSendPasswordStr:(NSString *)payPassword andVerifyCode:(NSString *)verifyCode  withDicBlock:(BaseDicAndSuccessBoolBlock)block;


//________________________________
/**
改变登录的密码
 */
+ (void)changeLoginPasswordToSendPasswordStr:(NSString *)payPassword  withDicBlock:(BaseDicAndSuccessBoolBlock)block;

/**
改变登录的秘密码(v2)
 */
+ (void)changeLoginPasswordV2ToSendPasswordStr:(NSString *)loginPassword andVerifyCode:(NSString *)verifyCode  withDicBlock:(BaseDicAndSuccessBoolBlock)block;
 
@end

NS_ASSUME_NONNULL_END
