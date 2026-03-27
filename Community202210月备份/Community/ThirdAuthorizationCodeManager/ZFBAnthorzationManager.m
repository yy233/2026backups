//
//  ZFBAnthorzationManager.m
//  Community
//
//  Created by 余莹 on 2021/12/15.
//

#import "ZFBAnthorzationManager.h"

@interface ZFBAnthorzationManager ()
@property (nonatomic,strong) ZFBAnthorzationWithGetCodeStrBlock zfbAnthorzationBlock;
@end

@implementation ZFBAnthorzationManager
singleton_implementation(shareManager)

- (void)getZFBAnthorzationCodeWithBLock:(ZFBAnthorzationWithGetCodeStrBlock)block{
    self.zfbAnthorzationBlock = block;
    [self ZfbAuthorzationBtnIsTap];
}
#pragma mark ==

- (void)ZfbAuthorzationBtnIsTap {
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:@"proprietor/user/auth/third/authInfo" withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                DLog(@"%@-----authInfo--",responsObject);
                NSDictionary *resDic = [[NSDictionary alloc]initWithDictionary:responsObject];
                NSString  *str = [[resDic allKeys]containsObject:@"data"] ? [NSString stringWithFormat:@"%@",resDic[@"data"]] : @"";
//                NSArray *arrWithStr = [NSArray c]
                //
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
                    NSLog(@"ZFBAnthorzationManager handleOpenURL%@", response.result);
                }
            }];
    return YES;
}
 
- (void)sendAuthRequestWithGetStr1:(NSString *)str{
    
    NSString *authInfoStr = str;
    NSString *appScheme = @"Community";
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSLog(@"sendAuthRequestWithGetStr1 authInfoStr = %@",authInfoStr);
    if (str.length > 0) {
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                         fromScheme:appScheme
                                           callback:^(NSDictionary *resultDic) {
            NSLog(@"sendAuthRequestWithGetStr1 anthorzation result  = %@",resultDic);
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
            NSLog(@"sendAuthRequestWithGetStr1 授权结果 authCode = %@", authCode?:@"");
            if (authCode.length>0) {
                [self useCodeToPop:authCode];
            }
        }];
    }
}

#pragma mark ====================================== 后台接口
- (void)useCodeToPop:(NSString *)codeStr{
    DLog(@"sendAuthRequestWithGetStr1 得到code")
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isNotNil(self.zfbAnthorzationBlock)) {
            self.zfbAnthorzationBlock(codeStr, YES);
        }else{
            self.zfbAnthorzationBlock(@"", NO);
        }
    });
}
@end
