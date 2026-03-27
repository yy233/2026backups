//
//  ZYRealNameAuthenticationTool.m
//  Community
//
//  Created by ZY on 2021/5/10.
//

#import "ZYRealNameAuthenticationTool.h"

@implementation ZYRealNameAuthenticationTool

//+ (void)realNameqQeryAuthentication {
//
//    [[ZYElectronicSignatureToolOfNetWork sharedTools] realNameRequestGetURL:kIsRealNameAuthenticationUrl withParams:@{}.mutableCopy finished:^(id  _Nonnull responsObject, NSError * _Nonnull error){
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        if (isNotNil(responsObject)) {
//            if (Y_IS_Success) {
//
//                [userDefaults setValue:@"1" forKey:@"isRealNameElectronicSignature"];
//            }else {
//                [userDefaults setValue:@"0" forKey:@"isRealNameElectronicSignature"];
//
//                Y_SVP_SHOW_ERR_MESSAGE
//            }
//        }else {
//
//            Y_SVP_SHOW_ERR_DESCRIPTION
//        }
//        [userDefaults synchronize];
//    }];
//}

+ (void)realNameqQeryAuthentication {
    //20220415 签章这版不上 使用用户信息内的实名状态
    if (kMYAPP_Now_IS_HIDDEN_MORE_INDEX != 0) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ( [ShareUserInfo sharedUserInfo].userInfo.isRealAuth ) {
            [userDefaults setValue:@"1" forKey:@"isRealNameElectronicSignature"];
        }else {
            [userDefaults setValue:@"0" forKey:@"isRealNameElectronicSignature"];
        }
        [userDefaults synchronize];
        return;
    }else{
        //签章使用时 用底下接口数据
    }
 
    
    NSDictionary *params = @{@"uuid" : [ShareUserInfo sharedUserInfo].userInfo.uid};
    NSString *jsonStr = [params yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kIsRealNameAuthenticationUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                NSLog(@"jsonStr = %@", jsonStr);
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]
                                                                       options:NSJSONReadingMutableContainers
                                                                         error:nil];
                BOOL status = [dict[@"status"] boolValue];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                if (status) {
                    [userDefaults setValue:@"1" forKey:@"isRealNameElectronicSignature"];
                }else {
                    [userDefaults setValue:@"0" forKey:@"isRealNameElectronicSignature"];
                }
                [userDefaults synchronize];
            }else {
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:@"0" forKey:@"isRealNameElectronicSignature"];
                [userDefaults synchronize];
//                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            
//            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

@end
