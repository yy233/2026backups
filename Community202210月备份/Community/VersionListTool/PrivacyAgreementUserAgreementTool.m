//
//  PrivacyAgreementUserAgreementTool.m
//  Community
//
//  Created by 余莹 on 2022/4/27.
//隐私协议用户协议的数据

#import "PrivacyAgreementUserAgreementTool.h"

static NSString *AgreementGetDetailInfo_URL =       @"proprietor/privacyPolicy/policyDetail";
static NSString *AgreementAgreeOrNotAgree_URL =     @"proprietor/user/auth/privacy/info";
static NSString *AagreeAgreement_URL =             @"proprietor/user/auth/privacy/agree";


@implementation PrivacyAgreementUserAgreementTool


/**
 用户协议
 */
+ (void)getAgreementDetailOfUserPolicyTypeWithBlock:(BaseDicAndSuccessBoolBlock)block{
    [self getAgreementDetailWithType:Agreements_Type_User withBlock:block];
}


/**
 隐私协议的接口
 */
//查询协议
+ (void)getAgreementDetailOfPrivacyPolicyTypeWithBlock:(BaseDicAndSuccessBoolBlock)block{
    [self getAgreementDetailWithType:Agreements_Type_Privacy withBlock:block];
}
//查询同意记录
+ (void)getAgreementAgreeOrNotAgreeOfPrivacyPolicyTypeWithBlock:(BaseDicAndSuccessBoolBlock)block{
    [self getAgreementAgreeOrNotAgreeWithType:Agreements_Type_Privacy withBlock:block];
}
//协议同意的状态提交
+ (void)agreeOneAgreementOfPrivacyPolicyTypeWithParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block{
    [self agreeOneAgreementWithParms:parms withType:Agreements_Type_Privacy withBlock:block];
}





/**-------------------------------------------------------------------------
协议的 总接口
 */
//查询协议
+ (void)getAgreementDetailWithType:(Agreements_Type)type withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"";
    url = AgreementGetDetailInfo_URL;
    switch (type) {
        case Agreements_Type_Disclaimer:
            break;
        case Agreements_Type_User:
            break;
        case Agreements_Type_Privacy:
            break;
        default:
            break;
    }
    if (url.length <= 0) {
        return;
    }
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithCapacity:0];
    [parms setValue:@(type) forKey:@"type"];
    
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
}
//查询同意记录
+ (void)getAgreementAgreeOrNotAgreeWithType:(Agreements_Type)type withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"";
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithCapacity:0];
    switch (type) {
        case Agreements_Type_Disclaimer:
            break;
        case Agreements_Type_User:
            break;
        case Agreements_Type_Privacy:
        {
            url = AgreementAgreeOrNotAgree_URL;
            [parms setValue:@(type) forKey:@"type"];
        }
            break;
        default:
            break;
    }
    if (url.length <= 0) {
        return;
    }
    
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//协议同意的状态提交
+ (void)agreeOneAgreementWithParms:(NSMutableDictionary *)parms withType:(Agreements_Type)type  withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"";
    switch (type) {
        case Agreements_Type_Disclaimer:
            break;
        case Agreements_Type_User:
            break;
        case Agreements_Type_Privacy:
        {
            url = AagreeAgreement_URL;
        }
            break;
        default:
            break;
    }
    if (url.length <= 0) {
        return;
    }
    
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:parms finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}


/**------------------------------------------------------------------------- 新版接口
 */
//查询同意记录(多类型)
+ (void)getAgreementAgreeOrNotAgreeWithTypeArr:(NSMutableArray *)typeArr withBlock:(BaseDicAndSuccessBoolBlock)block{
//    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithCapacity:0];
//    [parms setValue:typeArr forKey:@"type"];//没用到类型arr 换成str
//    NSString *userURL = [NSString stringWithFormat:@"%@?type=%@",AgreementAgreeOrNotAgree_URL,@"1,2,3,4,5,6,7,8"];
        NSString *userURL = [NSString stringWithFormat:@"%@?type=%@",AgreementAgreeOrNotAgree_URL,kAllAgreementTypeStr];

    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:userURL withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

//协议同意的状态提交 body
+ (void)agreeAgreementOfNowGetAllTypeWithTypeList:(NSMutableArray *)typeList withBlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YrequestPostURLNoMainQueueWithBodyNotParms:AagreeAgreement_URL withBody:@{@"typeList":typeList} finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
                block(dic,YES);
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
@end
