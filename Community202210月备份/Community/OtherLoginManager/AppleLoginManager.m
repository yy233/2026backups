//
//  AppleLoginManager.m
//  Community
//
//  Created by 余莹 on 2021/5/31.
//

#import "AppleLoginManager.h"
#import <AuthenticationServices/AuthenticationServices.h>

@interface AppleLoginManager () <ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@end

@implementation AppleLoginManager
singleton_implementation(shareManager);


- (void)appleLoginBtnIsTap{
    ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc] init];
    // 通过 provider 创建一个 request
    ASAuthorizationAppleIDRequest *appleIDRequest = [appleIDProvider createRequest];
    // 要获取的内容
    appleIDRequest.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    // 系统提供的 Controller，必须使用，需要传入 requests 数组
    ASAuthorizationController *authController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[appleIDRequest/*, passwordRequest*/]];
    // 设置代理，接收登录成功/失败的回调
    authController.delegate = self;
    // 页面跳转相关的，通过一个代理方法传入一个 window
    authController.presentationContextProvider = self;
    
    [authController performRequests];
    
}
#pragma mark ===
///代理主要用于展示在哪里
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller API_AVAILABLE(ios(13.0)){
    
    return [Tool toolGetKeyWindow];
}


- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization API_AVAILABLE(ios(13.0)){
    if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]){
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSString *user = appleIDCredential.user;
        // 使用过授权的，可能获取不到以下三个参数
        NSString *familyName = appleIDCredential.fullName.familyName;
        NSString *givenName = appleIDCredential.fullName.givenName;
        NSString *email = appleIDCredential.email;
        NSLog(@"苹果登录 个人信息部分(使用过授权的，可能获取不到) \n %@ \n %@ \n %@ \n %@",user,familyName,givenName,email);
        NSData *identityToken = appleIDCredential.identityToken;// token
//        NSData *authorizationCode = appleIDCredential.authorizationCode;// 用户唯一标识
        
        // 服务器验证需要使用的参数
        NSString *identityTokenStr = [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding];
//        NSString *authorizationCodeStr = [[NSString alloc] initWithData:authorizationCode encoding:NSUTF8StringEncoding];
//        NSLog(@"苹果登录 服务器验证需要使用的参数 \n %@ \n %@", identityTokenStr, authorizationCodeStr);
        //在这里处理向后台注册或登录事件，具体看项目后台的支持
        
        DLog(@"");
        // 避免从其他app回到app接口调用 报错 -1005连接断开
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self useCodeToPop:identityTokenStr];
        });
        
    }else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]){
        
        //// Sign in using an existing iCloud Keychain credential.  // 这个获取的是iCloud记录的账号密码，需要输入框支持iOS 12 记录账号密码的新特性，如果不支持，可以忽略
//        ASPasswordCredential *pass = authorization.credential;
//        NSString *username = pass.user;
//        NSString *passw = pass.password;
        
    }else{
        NSLog(@"授权信息不符");
        Y_SVP_SHOW_ERR_MES(@"授权信息均不符");
    }
}
/// - Tag: did_complete_error
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    NSString * errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
//            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
            
    }
    DLog(@"AppleLoginManager \n %@",errorMsg);
    Y_SVP_SHOW_ERR_MES(errorMsg);
}
#pragma mark ===

 
- (void)performExistingAccountSetupFlows {
    // Prepare requests for both Apple ID and password providers.
    NSArray<ASAuthorizationRequest *> *requests = @[[[ASAuthorizationAppleIDProvider new] createRequest],
                                                    [[ASAuthorizationPasswordProvider new] createRequest]];
    
    // Create an authorization controller with the given requests.
    ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
    authorizationController.delegate = self;
    authorizationController.presentationContextProvider = self;
    [authorizationController performRequests];
}
#pragma mark ====================================== 后台接口 /注册过了登录 没注册apple暂不能要绑定 走token和未数据
- (void)useCodeToPop:(NSString *)tokenStr{
    NSString *appleLoginUrl = [NSString stringWithFormat:@"proprietor/Ios/loginNotMobile?identityToken=%@",tokenStr];
    WEAKSELF
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:appleLoginUrl withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        NSLog(@"\n apple   === %@ %@",responsObject,error);
    
        AppleLoginModel *appleModel = [[AppleLoginModel alloc]init];
        if (isNotNil(responsObject)) {
            if ([[responsObject objectForKey:@"code"] intValue]==0) {
                NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSString     * expiredTimeStr = [[dataDic allKeys]containsObject:kLogin_ExpiredTime_Key] ? [NSString stringWithFormat:@"%@",dataDic[kLogin_ExpiredTime_Key]] : @"";
                NSString     * tokenStr =       [[dataDic allKeys]containsObject:@"token"] ? [NSString stringWithFormat:@"%@",dataDic[@"token"]] : @"";
                NSDictionary * userInfo   =     [[dataDic allKeys]containsObject:@"userInfo"] ? [[NSDictionary alloc]initWithDictionary:dataDic[@"userInfo"]] : @{};
                appleModel.expiredTime = expiredTimeStr;
                appleModel.token = tokenStr;
                appleModel.userInfo = [UserModel mj_objectWithKeyValues:userInfo];
                NSInteger     isBindMobile =     [[userInfo allKeys]containsObject:@"isBindMobile"] ? [userInfo[@"isBindMobile"] integerValue] : 0;

                if (isBindMobile == YES) {
                    appleModel.userInfo = [UserModel mj_objectWithKeyValues:userInfo];
                    //登录数据
                    weakSelf.userInfoBlock(appleModel,Third_LoginOrRegist_Type_Login);
                }else{
                    //未绑定手机情况的数据
                    appleModel.thirdPlatformId = @"appleThirdPlatformId"; //占位
                    weakSelf.userInfoBlock(appleModel,Third_LoginOrRegist_Type_Regist);
                }
            }else{
                weakSelf.userInfoBlock(appleModel,Third_LoginOrRegist_Type_Err);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            weakSelf.userInfoBlock(appleModel,Third_LoginOrRegist_Type_Err);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
    
}
 
 
@end
