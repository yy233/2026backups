//
//  ZYContractSignUploadModel.h
//  Community
//
//  Created by ZY on 2021/5/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYContractSignUploadModel : NSObject

// 签署密码
@property (nonatomic, copy) NSString *auth;

// 验证方式 取值—> pass_auth:密码、sms_auth:手机短信、mall_auth:电子邮件 face_auth:人脸识别
@property (nonatomic, copy) NSString *authType;

// 合同管理id
@property (nonatomic, copy) NSString *conId;

// 发起方设备详细信息
@property (nonatomic, copy) NSString *deviceInfo;

// 发起方IP地址
@property (nonatomic, copy) NSString *ipAddr;

// 发起方位置
@property (nonatomic, copy) NSString *positionInfo;

// 描述
@property (nonatomic, copy) NSString *remark;

// 签署人印章
@property (nonatomic, copy) NSString *sealId;

// 短信验证码
@property (nonatomic, copy) NSString *smsCode;

// 签署人uid
@property (nonatomic, copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END
