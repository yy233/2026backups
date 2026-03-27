//
//  PrivacyAgreementUserAgreementTool.h
//  Community
//
//  Created by 余莹 on 2022/4/27.
//隐私协议 用户协议 

#import <Foundation/Foundation.h>
#import "AllAgreementUseModel.h"
#import "BaseViewModel.h"
 
NS_ASSUME_NONNULL_BEGIN

static NSString *kAllAgreementTypeStr = @"1,2,3,8";

/**
 类型;免责条款:1 ;用户协议:2 ;隐私政策3 ;入驻协议:4;   二手协议:5;   租赁协议:6;    缴费协议:7
 type  Disclaimer :1; User agreement :2; Privacy Policy 3; Settlement Agreement :4; Second-hand agreement :5; Lease Agreement :6; Payment Agreement :7
 
 ("免责条款", 1)
 ("用户协议", 2)
 ("隐私政策", 3)
 ("入驻协议", 4)
 ("二手协议", 5)
 ("租赁协议", 6)
 ("关于我们", 8)
 ("缴费协议", 7)
 */
typedef enum : NSUInteger {
    Agreements_Type_Disclaimer = 1,
    Agreements_Type_User,
    Agreements_Type_Privacy,
    Agreements_Type_Settlement,
    Agreements_Type_Secondhand,
    Agreements_Type_Lease,
    Agreements_Type_Payment,
    Agreements_Type_AboutUs,
}  Agreements_Type;

@interface PrivacyAgreementUserAgreementTool : NSObject


/**
 用户协议
 */
+ (void)getAgreementDetailOfUserPolicyTypeWithBlock:(BaseDicAndSuccessBoolBlock)block;

/**
 隐私协议的接口
 */
//查询协议
+ (void)getAgreementDetailOfPrivacyPolicyTypeWithBlock:(BaseDicAndSuccessBoolBlock)block;
//查询同意记录
+ (void)getAgreementAgreeOrNotAgreeOfPrivacyPolicyTypeWithBlock:(BaseDicAndSuccessBoolBlock)block;
//协议同意的状态提交
+ (void)agreeOneAgreementOfPrivacyPolicyTypeWithParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block;





/**-------------------------------------------------------------------------
协议的 总接口
 */
//查询协议
+ (void)getAgreementDetailWithType:(Agreements_Type)type withBlock:(BaseDicAndSuccessBoolBlock)block;
//查询同意记录
+ (void)getAgreementAgreeOrNotAgreeWithType:(Agreements_Type)type withBlock:(BaseDicAndSuccessBoolBlock)block;
//协议同意的状态提交
+ (void)agreeOneAgreementWithParms:(NSMutableDictionary *)parms  withType:(Agreements_Type)type withBlock:(BaseDicAndSuccessBoolBlock)block;


/**------------------------------------------------------------------------- 新版接口
 */
//查询同意记录(多类型)
+ (void)getAgreementAgreeOrNotAgreeWithTypeArr:(NSMutableArray *)typeArr withBlock:(BaseDicAndSuccessBoolBlock)block;
//协议同意的状态提交
+ (void)agreeAgreementOfNowGetAllTypeWithTypeList:(NSMutableArray *)typeList withBlock:(BaseDicAndSuccessBoolBlock)block;

@end

NS_ASSUME_NONNULL_END
