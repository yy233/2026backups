//
//  WechatLoginManager.m
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import "WechatLoginManager.h"

@interface WechatLoginManager() <WXApiDelegate,WXApiLogDelegate>
@end

@implementation WechatLoginManager

singleton_implementation(shareManager)

- (void)wxLoginBtnIsTap {
    [self sendAuthRequest];
}

- (void)registerApp {
    [WXApi registerApp:WX_APP_ID universalLink:WX_UNIVERSAL_LINK];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)sendAuthRequest {
    if (![WXApi isWXAppInstalled]) {
        Y_SVP_SHOW_ERR_MES(@"您没有安装微信客户端，请安装后再试")
        return;
    }
//    if (WX_REFRESH_TOKEN_UserDefaults_Get) {
//        //存在token 不用获取授权 直接获取用户信息
//        [self useTokenGetUserInfo];
//        return;
//    }
    
    [WXApi registerApp:WX_APP_ID universalLink:WX_UNIVERSAL_LINK];
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.state = @"wx_oauth_authorization_state"; // 用于保持请求和回调的状态，授权请求或原样带回 可设置为简单的随机数加 session 进行校验
    req.scope = @"snsapi_userinfo"; // 授权作用域：获取用户个人信息
    
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *rootViewController = appdelegate.window.rootViewController;
    [WXApi sendAuthReq:req viewController:rootViewController delegate:self completion:^(BOOL success) {
        if (success) {
            //已经跳转到微信
        }else{
            Y_SVP_SHOW_ERR_MES(@"微信登录失败");
        }
    }];
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq*)req {
    
}

/**
 成功拿到授权的回调   wxCodeStr
 */
- (void)onResp:(BaseResp*)resp {
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *sendAuth = (SendAuthResp *)resp;
        if ([sendAuth.state isEqualToString:@"wx_oauth_authorization_state"]) {
            /**
             ERR_OK = 0(用户同意) ERR_AUTH_DENIED = -4（用户拒绝授权） ERR_USER_CANCEL = -2（用户取消）
             */
            if (sendAuth.errCode == 0) {
                NSString *wxCodeStr = sendAuth.code;
                NSLog(@"wxCodeStr = %@", wxCodeStr);
                NSLog(@"成功拿到授权的回调%@",wxCodeStr);
                // 避免从其他app回到app接口调用 报错 -1005连接断开
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self useCodeToPop:wxCodeStr];
                });
            } else {
                Y_SVP_SHOW_ERR_MES(@"获取授权失败")
            }
        }
    }
}
#pragma mark ====================================== 后台接口
- (void)useCodeToPop:(NSString *)codeStr{
    NSString *wxLoginUrl = [NSString stringWithFormat:@"proprietor/WeChat/login?code=%@",codeStr];
    WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:wxLoginUrl withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        WeChatLoginUserModel *wxModel = [[WeChatLoginUserModel alloc]init];
        if (isNotNil(responsObject)) {
            if ([[responsObject objectForKey:@"code"] intValue]==0) {//注册过了登录 没注册过需要绑定
                NSMutableDictionary *wxDic = [NSMutableDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSLog(@"_____wx_%@",wxDic);
                
                NSString     * expiredTimeStr = [[wxDic allKeys]containsObject:kLogin_ExpiredTime_Key] ? [NSString stringWithFormat:@"%@",wxDic[kLogin_ExpiredTime_Key]] : @"";
                NSString     * tokenStr =  [[wxDic allKeys]containsObject:@"token"] ? [NSString stringWithFormat:@"%@",wxDic[@"token"]] : @"";
                NSDictionary * userInfo   =   [[wxDic allKeys]containsObject:@"userInfo"] ? [[NSDictionary alloc]initWithDictionary:wxDic[@"userInfo"]] : @{};
                wxModel.expiredTime = expiredTimeStr;
                wxModel.token = tokenStr;
                wxModel.userInfo = [UserModel mj_objectWithKeyValues:userInfo];
                
                NSInteger    isBindMobile = [[userInfo allKeys]containsObject:@"isBindMobile"] ? [userInfo[@"isBindMobile"] integerValue] : 0;

                if (isBindMobile==YES) { //登录数据
                    weakSelf.userInfoblock(wxModel,Third_LoginOrRegist_Type_Login);
                }else{
                    //1213改
                    // 注册用绑定数据
                    //记录过期时间和token  后台数据不再使用thirdPlatformId，但本绑定判断综合处需要用thirdPlatformId处理绑定类型 则自定数据
                    wxModel.thirdPlatformId = @"weChatId";
                    weakSelf.userInfoblock(wxModel,Third_LoginOrRegist_Type_Regist);
                }
            }else{
                weakSelf.userInfoblock(wxModel,Third_LoginOrRegist_Type_Err);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            weakSelf.userInfoblock(wxModel,Third_LoginOrRegist_Type_Err);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
 

@end
