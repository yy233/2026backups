//
//  MoneyOfThridBangDingAddDeletViewModel.m
//  Community
//
//  Created by 余莹 on 2021/10/18.
//

#import "MoneyOfThridBangDingInfoAddDeletData.h"
#define URL_getThridAuthorizationBangDingInfo @"proprietor/user/auth/thirdPlarformInfo"

 
//zfb
#define URL_ZFB_BangDing_New  @"proprietor/user/auth/bindingAlipay"
#define URL_ZFB_JieBang_New   @"proprietor/user/auth/unbindingAlipay"
//ios
#define URL_IOS_JieBang_New   @"proprietor/Ios/unbind"

@implementation MoneyOfThridBangDingInfoAddDeletData
//1216更换解绑绑定的接口 相关界面从钱包模块换到app个人中心设置页的三方绑定子页

//查询三方平台绑定信息
+ (void)getThridAuthorizationBangDingInfoWithBlock:(BaseListArrAndSuccessBoolBlock)block{
    NSString *url =  URL_getThridAuthorizationBangDingInfo;
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                block(Y_ResponsObject_dataArr,YES);
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark === wx
//授权code
+ (void)weixinBangDingWithCodeStr:(NSString *)codeStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = [NSString stringWithFormat:@"proprietor/user/auth/bindingWechat?code=%@",codeStr];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
//    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:@{@"code":codeStr}.mutableCopy finished:^(id responsObject, NSError *error) {
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
//验证码code
+ (void)weixinJieBangWithAccountStr:(NSString *)accountStr andNomalCodeStr:(NSString *)codeStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = @"proprietor/user/auth/relieveBindingWechat";
    
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:@{@"account":accountStr,@"code":codeStr}.mutableCopy finished:^(id responsObject, NSError *error) {
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

#pragma mark == zfb
+ (void)zhifubaoBangDingWithCodeStr:(NSString *)codeStr withBlock:(BaseDicAndSuccessBoolBlock)block{
//    NSMutableDictionary *parms = [[NSMutableDictionary alloc]initWithCapacity:0];
//    [parms setValue:codeStr forKey:@"code"];
    NSString *url = [NSString stringWithFormat:@"%@?code=%@",URL_ZFB_BangDing_New,codeStr];
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:@{}.mutableCopy  finished:^(id responsObject, NSError *error) {
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
+ (void)zhifubaoJieBangWithAccountStr:(NSString *)accountStr andNomalCodeStr:(NSString *)codeStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSString *url = URL_ZFB_JieBang_New;
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:@{@"account":accountStr,@"code":codeStr}.mutableCopy finished:^(id responsObject, NSError *error) {
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

#pragma mark == ios
+ (void)iosJieBangWithNotUseAccountStr:(NSString *)accountStr andNomalCodeStr:(NSString *)codeStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    NSString *url = [URL_IOS_JieBang_New stringByAppendingFormat:@"?code=%@", codeStr];

    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
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
 //支付宝  旧的 弃用
 + (void)zhifubaoBangDingWithAccountStr:(NSString *)accountStr realNameStr:(NSString *)nameStr withBlock:(BaseDicAndSuccessBoolBlock)block{
    // NSString *url = @"proprietor/user/account/zhifubao/account/binding";
     NSString *url =
     [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:url withParams:@{@"account":accountStr,@"realname":nameStr}.mutableCopy finished:^(id responsObject, NSError *error) {
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
 + (void)zhifubaoJieBangWithBlock:(BaseDicAndSuccessBoolBlock)block{
     //NSString *url = @"proprietor/user/account/zhifubao/account/unbundling";
     [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
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

 */

@end
