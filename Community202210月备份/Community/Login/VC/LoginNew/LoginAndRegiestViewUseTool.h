//
//  LoginAndRegiestViewUseTool.h
//  Community
//
//  Created by 余莹 on 2022/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//展示类型
typedef enum : NSUInteger {
    LoginAndRegiestVC_Show_Type_PasswordLogin,
    LoginAndRegiestVC_Show_Type_CodeLogin,
} LoginAndRegiestVC_Show_Type;


//协议用到的
static NSString *NomalText = @"已阅读并同意以下协议：";
static NSString *UserPolicyTitleText = @"《未来物服用户协议》、";
static NSString *PrivacyPolicyTitleText = @"《隐私协议》";
static NSString *UserPolicyKey = @"App_UserPolicy://";
static NSString *PrivacyPolicyKey = @"App_PrivacyPolicy://";
//
typedef void(^GotoPrivacyAgreementVcBlock)(PrivacyAgreementVCLate *vc);

@interface LoginAndRegiestViewUseTool : NSObject

@end

NS_ASSUME_NONNULL_END
