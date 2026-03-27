//
//  ZFBLoginManager.m
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#import "ZFBLoginManager.h"


@implementation ZFBLoginManager
singleton_implementation(shareManager)
 
- (void)ZfbLoginBtnIsTap {
    DLog("ZfbLoginBtnIsTap");
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:@"proprietor/user/auth/third/authInfo" withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                DLog(@"%@-----authInfo--",responsObject);
                NSDictionary *resDic = [[NSDictionary alloc]initWithDictionary:responsObject];
                NSString  *str = [[resDic allKeys]containsObject:@"data"] ? [NSString stringWithFormat:@"%@",resDic[@"data"]] : @"";
                  dispatch_async(dispatch_get_main_queue(), ^{
                    [self sendAuthRequestWithGetStr1:str];
                });
                Y_SVP_SHOW_ERR_MESSAGE
            }
         }else{
             Y_SVP_SHOW_ERR_DESCRIPTION
         }
    }];
}

- (BOOL)handleOpenURL:(NSURL *)url {
        [AFServiceCenter handleResponseURL:url withCompletion:^(AFServiceResponse *response) {
                if (AFResSuccess == response.responseCode) {
                    NSLog(@"ZFBLoginManager handleOpenURL%@", response.result);
                }
            }];
    return YES;
}
 
//- (void)sendAuthRequestWithGetStr:(NSString *)str{
// /**
//  旧版 固定str
//  */
//    NSString *url = [NSString stringWithFormat:@"https://authweb.alipay.com/auth?auth_type=PURE_OAUTH_SDK&app_id=%@&scope=auth_user&state=xxx",ZFB_APP_ID]; // state待
//
//    /**
//     1216 得到的str
//     */
//    NSString *urlUseGetStr = [@"https://authweb.alipay.com/auth?" stringByAppendingString:str];
//    NSDictionary  *params = @{kAFServiceOptionBizParams:
//                              @{@"url" :urlUseGetStr},
//                            kAFServiceOptionCallbackScheme:@"Community",};//2021002119679359 Community
//
//    NSLog(@"sendAuthRequestWithGetStr callService loginManager %@",params);
//    /**
//     ---authInfo--
//     ZFBLoginManager.m:62      sendAuthRequestWithGetStr callService {
//         AFBizParam =     {
//             url = "https://authweb.alipay.com/auth?app_name=mc&auth_type=AUTHACCOUNT&apiname=com.alipay.account.auth&biz_type=openservice&product_id=APP_FAST_LOGIN&scope=kuaijie&pid=2088041379474034&target_id=zhsjCommunity&app_id=2021002119679359&sign_type=RSA2&methodname=alipay.open.auth.sdk.code.get&sign=f5ZaV%2BY21usfDOZ743GubLbdoYmiulMTMQ2LtpjaZtVjW53JIKOXd5Tttic8c3dEdfii%2B1pUL6lzPr9bFHCPMXLDkK1qZbcQ5wL45a7O1k4jEextSvIDfUPwlZeeI5zglA1oeGPVqgYf0eTBpYIlVOd4wN18hLh7P7O2jbAqjNm7lazTg5eFGSnpAwUnMBMQrD7nYUB72FTJKyFaMmy8n22sSrBYFbdGAWEmTYyfDttqpoXVERgVNbF%2By87P5NFYUn517Qxo9Otwksj%2FPPfuWIUNkJKL6%2FHHbRdXM1a6WTandorM2U%2Fh2nNMJB6E0qA9rJPii5hZureeQHGtIoemdA%3D%3D";
//         };
//         AFCBScheme = Community;
//     }*/
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [AFServiceCenter callService:AFServiceAuth withParams:params andCompletion:^(AFServiceResponse *response) {
//             NSLog ( @"AFServiceCenter callService   ————————————————  %@" , response.result);///-----------
//
//            if (response.responseCode == AFResSuccess) {
//                /**
//                 po [response keyValues]
//                 {
//                     payloadDict =     {
//                         result =         {
//                             "app_id" = 2021002110645689;
//                             "auth_code" = 006369b6ecc54c9cace920583f87OC13;
//                             "result_code" = SUCCESS;
//                             scope = "auth_user";
//                             state = xxx;
//                         };
//                         session = "C2361D15-AAC0-464A-B73A-4715BEDDB262";
//                     };
//                     responseCode = 0;
//                     result =     {
//                         "app_id" = 2021002110645689;
//                         "auth_code" = 006369b6ecc54c9cace920583f87OC13;
//                         "result_code" = SUCCESS;
//                         scope = "auth_user";
//                         state = xxx;
//                     };
//                     session = "C2361D15-AAC0-464A-B73A-4715BEDDB262";
//                 }
//                 */
//
//                NSString  *authCode = response.result[ @"auth_code" ];
//                // 避免从其他app回到app接口调用 报错 -1005连接断开
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self useCodeToPop:authCode];
//                });
//
//
//            }else{
//                Y_SVP_SHOW_ERR_MES(@"三方登录失败!");
//            }
//        }];
//    });
//
//}

- (void)sendAuthRequestWithGetStr1:(NSString *)str{
    
    NSString *authInfoStr = str;
    NSString *appScheme = @"Community";
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSLog(@"sendAuthRequestWithGetStr1 authInfoStr = %@",authInfoStr);
    if (str.length > 0) {
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                         fromScheme:appScheme
                                           callback:^(NSDictionary *resultDic) {
            NSLog(@"sendAuthRequestWithGetStr1  login result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"sendAuthRequestWithGetStr1  login 授权结果 authCode = %@", authCode?:@"");
            if (authCode.length>0) {
                // 避免从其他app回到app接口调用 报错 -1005连接断开
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self useCodeToPop:authCode];
                });
            }
        }];
    }
}

#pragma mark ====================================== 后台接口
- (void)useCodeToPop:(NSString *)codeStr{
    NSString *zfbLoginUrl = @"proprietor/user/auth/third/login";
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(1) forKey:@"thirdPlatformType"];//"thirdPlatformType" : 1  是支付宝 固定传1
    [parms setValue:codeStr forKey:@"authCode"];

     WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueue:zfbLoginUrl withParams:parms finished:^(id responsObject, NSError *error) {
        ZFBLoginModel *zfbModel = [[ZFBLoginModel alloc]init];
       
        if (isNotNil(responsObject)) {
            if ([[responsObject objectForKey:@"code"] intValue]==0) {//注册过了登录 没注册过需要绑定
                NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                NSLog(@"_____zfb_%@",dataDic);
                //登录数据
                NSString     * expiredTimeStr = [[dataDic allKeys]containsObject:kLogin_ExpiredTime_Key] ? [NSString stringWithFormat:@"%@",dataDic[kLogin_ExpiredTime_Key]] : @"";
                NSString     * tokenStr =  [[dataDic allKeys]containsObject:@"token"] ? [NSString stringWithFormat:@"%@",dataDic[@"token"]] : @"";
                NSDictionary * userInfo   =   [[dataDic allKeys]containsObject:@"userInfo"] ? [[NSDictionary alloc]initWithDictionary:dataDic[@"userInfo"]] : @{};
                zfbModel.expiredTime = expiredTimeStr;
                zfbModel.token = tokenStr;
                zfbModel.userInfo = [UserModel mj_objectWithKeyValues:userInfo];
                NSInteger      isBindMobile = [[userInfo allKeys]containsObject:@"isBindMobile"] ? [userInfo[@"isBindMobile"] integerValue] : 0;

                if (isBindMobile == YES) {
                    weakSelf.userInfoBlock(zfbModel,Third_LoginOrRegist_Type_Login);
                }else{
                    //1213改
                    //记录过期时间和token  后台数据不再使用thirdPlatformId，但本绑定判断综合处需要用thirdPlatformId处理绑定类型 则自定数据
                    zfbModel.thirdPlatformId = @"zfbId";
                    weakSelf.userInfoBlock(zfbModel,Third_LoginOrRegist_Type_Regist);
                }
            }else{
                weakSelf.userInfoBlock(zfbModel,Third_LoginOrRegist_Type_Err);
                Y_SVP_SHOW_ERR_MESSAGE
            
            }
        }else{
            weakSelf.userInfoBlock(zfbModel,Third_LoginOrRegist_Type_Err);
            Y_SVP_SHOW_ERR_DESCRIPTION
          
        }
        
    }];
}
 
 
@end
