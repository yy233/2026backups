//
//  SafetyCenterModel.m
//  Community
//
//  Created by 余莹 on 2021/6/4.
//

#import "SafetyCenterViewModel.h"
#define URL_SetLoginPassword             @"proprietor/user/auth/password"
#define URL_SetPayPassword               @"proprietor/user/auth/password/pay"
#define URL_SetNewPhoneNum               @"proprietor/user/auth/reset/mobile"

@implementation SafetyCenterViewModel
/**
 验证码请求接口
 */
+ (void)safetyCenterSendCodeActionWithCodeType:(CodeRequestType)codeRequestType withPhoneNumStr:(NSString *)phoneStr withDicBlock:(BaseDicAndSuccessBoolBlock)block{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phoneStr forKey:@"account"];
    [params setValue:@(codeRequestType) forKey:@"type"];//
    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_USER_SEND_CODE withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                //验证码发送成功
                block(Y_ResponsObject_dataDic,YES);
                Y_SVP_SHOW_SUCCESS_MESSAGE
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
+ (void)safetyCenterCheckCodeWithCodeNum:(NSString *)codeStr withPhoneNumStr:(NSString *)phoneStr withDicBlock:(BaseDicAndSuccessBoolBlock)block{
 
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:phoneStr forKey:@"account"];
    [params setValue:codeStr forKey:@"code"];
    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_USER_FORGET_PASSWORD_CODE_CHECK withParams:params finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataDic,YES);
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
/**
改变手机号 给手机号发送code的申请
 */
+ (void)changePhoneToSendCodeWithTheNewPhoneNumStr:(NSString*)nPhoneStr withDicBlock:(BaseDicAndSuccessBoolBlock)block{
    if (nPhoneStr.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"请输入手机号");
        return;
    }
    [self safetyCenterSendCodeActionWithCodeType:CodeRequestType_ChangePhoneNum withPhoneNumStr:nPhoneStr withDicBlock:block];//改手机号
//    [self safetyCenterSendCodeActionWithCodeType:CodeRequestType_Login withPhoneNumStr:nPhoneStr withDicBlock:block];//以前暂用

}
/**
改变手机号   登录的时候用的接口 
 */
+ (void)changePhoneToSendLastAuthTokenCheckWithPhoneStr:(NSString*)nPhoneStr withCodeStr:(NSString *)codeStr withDicBlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YrequestPutURLNoMainQueue:URL_SetNewPhoneNum withParams:@{@"account":nPhoneStr,@"code":codeStr}.mutableCopy finished:^(id responsObject, NSError *error) {
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


/**
改变手机号 给手机号发送authToken +token+ account  ,没登录的时候用的接口 登录状态改手机不用这个接口了
 */
+ (void)changePhoneToSendLastAuthTokenCheckWithPhoneStr:(NSString*)nPhoneStr withAuthTokenStr:(NSString *)authTokenStr withDicBlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YrequestHaveAuthTokenWithPutURLNoMainQueue:URL_SetNewPhoneNum withParams:@{@"account":nPhoneStr}.mutableCopy withAuthToken:authTokenStr finished:^(id responsObject, NSError *error) {
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

/**
改变付钱的秘密码  给手机号发送code的申请
 */
+ (void)changePayPasswordToSendCodeWithTheNewPhoneNumStr:(NSString*)nPhoneStr withDicBlock:(BaseDicAndSuccessBoolBlock)block{
    if (nPhoneStr.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"请输入手机号");
        return;
    }
    [self safetyCenterSendCodeActionWithCodeType:CodeRequestType_Login  withPhoneNumStr:nPhoneStr withDicBlock:block];//CodeRequestType_ChangePassword=当前暂无可用值 暂用2

}
/**
改变付钱的秘密码  设置付钱密
 */
+ (void)changePayPasswordToSendPasswordStr:(NSString *)payPassword  withDicBlock:(BaseDicAndSuccessBoolBlock)block{
    if (payPassword.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"请输入密码");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:payPassword forKey:@"payPassword"];
    [parms setValue:payPassword forKey:@"confirmPayPassword"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_SetPayPassword withParams:parms finished:^(id responsObject, NSError *error) {
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
/**
改变付钱的秘密码  设置付钱密(V2)
 */
+ (void)changePayPasswordV2ToSendPasswordStr:(NSString *)payPassword andVerifyCode:(NSString *)verifyCode  withDicBlock:(BaseDicAndSuccessBoolBlock)block{
    if (payPassword.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"请输入密码");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc] init];
    [parms setValue:verifyCode forKey:@"code"];
    [parms setValue:payPassword forKey:@"payPassword"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_SetPayPassword withParams:parms finished:^(id responsObject, NSError *error) {
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

/**
改变登录的秘密码
 */
+ (void)changeLoginPasswordToSendPasswordStr:(NSString *)loginPassword  withDicBlock:(BaseDicAndSuccessBoolBlock)block{
    if (loginPassword.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"请输入密码!");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:loginPassword forKey:@"password"];
    [parms setValue:loginPassword forKey:@"confirmPassword"];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:URL_SetLoginPassword withParams:parms finished:^(id responsObject, NSError *error) {
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
/**
改变登录的秘密码(v2)
 */
+ (void)changeLoginPasswordV2ToSendPasswordStr:(NSString *)loginPassword andVerifyCode:(NSString *)verifyCode  withDicBlock:(BaseDicAndSuccessBoolBlock)block{
    if (loginPassword.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"请输入密码!");
        return;
    }
    NSMutableDictionary *parms = [[NSMutableDictionary alloc] init];
    [parms setValue:verifyCode forKey:@"code"];
    [parms setValue:loginPassword forKey:@"password"];
    [[ToolOfNetWork sharedTools] YrequestPostURLNotMainQueue:URL_SetLoginPassword withParams:parms finished:^(id responsObject, NSError *error) {
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
