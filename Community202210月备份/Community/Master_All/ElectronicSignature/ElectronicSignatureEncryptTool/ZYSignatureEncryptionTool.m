//
//  ZYSignatureEncryptionTool.m
//  Community
//
//  Created by ZY on 2021/4/8.
//

#import "ZYSignatureEncryptionTool.h"
#import "AESUtil.h"
#import <CommonCrypto/CommonCrypto.h>

static NSString * const secret = @"巴拉啦小魔仙";

@implementation ZYSignatureEncryptionTool

+ (NSDictionary *)encryptSignatureEncryptionWithJsonStr:(NSString *)content {
    
    // AES加密后字符串
    NSString *AESStr = [AESUtil encryptAESWithStr:content];
    // 拼接待签名字符串
    NSInteger millisecond = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *willMD5Str = [NSString stringWithFormat:@"code=0&data=%@&fail=false&message=ok&secret=%@&success=true&time=%ld", AESStr, secret, millisecond];
//    DLog(@"MD5签名前 = %@", willMD5Str);
    // 签名后字符串
    NSString *MD5Str = [self MD5ForString:willMD5Str];
//    DLog(@"MD5签名后 = %@", MD5Str);
    // 构造body数据
    bool bool_true = true;
    bool bool_false = false;
    NSDictionary *bodyDict = @{@"code" : @(0), @"data" : AESStr, @"fail" : @(bool_false), @"message" : @"ok", @"sign" : MD5Str, @"success" : @(bool_true), @"time" : @(millisecond)};
    
    return bodyDict;
}

// MD5签名
+ (NSString *)MD5ForString:(NSString *)string {
    const char *input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

+ (NSString *)decryptionSignatureEncryptionWithBase64Str:(NSString *)content {
    
    if (![content isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    return [AESUtil decryptDataWithStr:content];
}

@end
