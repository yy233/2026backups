//
//  AESUtil.h
//  Community
//
//  Created by ZY on 2021/4/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AESUtil : NSObject

/**
 * AES加密
 */
+ (NSString *)encryptAESWithStr :(NSString *)content;

/**
 * AES解密
 */
+ (NSString *)decryptDataWithStr:(NSString *)content;

@end

NS_ASSUME_NONNULL_END
