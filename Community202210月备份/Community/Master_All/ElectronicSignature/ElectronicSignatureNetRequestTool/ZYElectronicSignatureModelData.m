//
//  ZYElectronicSignatureModelData.m
//  Community
//
//  Created by ZY on 2021/10/21.
//

#import "ZYElectronicSignatureModelData.h"

@implementation ZYElectronicSignatureModelData

+ (void)isSignPasswordCompletion:(ZYCompletionBlock)completionBlock {
    NSDictionary *parms = @{@"uuid" : [ShareUserInfo sharedUserInfo].userInfo.uid};
    NSString *jsonStr = [parms yy_modelToJSONString];
    // 加密
    NSDictionary *bodyDict = [ZYSignatureEncryptionTool encryptSignatureEncryptionWithJsonStr:jsonStr];
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestPostURLNoMainQueueWithBodyNotParms:kContractIsSignPasswordUrl withBody:bodyDict finished:^(id  _Nonnull responsObject, NSError * _Nonnull error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 对data数据解密
                NSString *jsonStr = [ZYSignatureEncryptionTool decryptionSignatureEncryptionWithBase64Str:responsObject[@"data"]];
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                completionBlock(dict, YES);
            }else {
                completionBlock(nil, NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            completionBlock(nil, NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

@end
