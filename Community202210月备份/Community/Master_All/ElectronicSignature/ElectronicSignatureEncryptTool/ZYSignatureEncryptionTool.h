//
//  ZYSignatureEncryptionTool.h
//  Community
//
//  Created by ZY on 2021/4/8.
//  签章加密

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYSignatureEncryptionTool : NSObject

// 签章加密
+ (NSDictionary *)encryptSignatureEncryptionWithJsonStr:(NSString *)content;

// 签章解密
+ (NSString *)decryptionSignatureEncryptionWithBase64Str:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
