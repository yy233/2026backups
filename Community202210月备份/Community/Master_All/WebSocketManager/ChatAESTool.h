//
//  ChatAESTool.h
//  Community
//
//  Created by 余莹 on 2021/4/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatAESTool : NSObject
/**
 *第一个接口 用自己的数据 获取服务器的key,加密用本地key 本地iv,解密用rsa.===存储获取的服务器keyiv
 *后来的接口 iv都用（服务器拿到的活动iv, 3位）与时间戳拼接
 *加密用 服务器的key + 当前time+iv
 *解密用 本地的key + data所在同级别的time +iv
 **/


/**
 * AES加密
 */
//
+ (NSString *)chatTypeEncryptAESLocallyStoredKeyAndIvWithConnectStr :(NSString *)content; //第一个接口 用自己的数据 获取服务器的key,加密用本地key 本地iv,
+ (NSString *)chatTypeEncryptAESUseServiceKeyIvAndLocalTimeStr:(NSString *)timeStr withStr :(NSString *)content;//加密用 服务器的key + 当前time+iv
/**
 * AES解密
 */
+ (NSString *)chatTypeDecryptAESUseLocalStroedKeyIvWithContentStr:(NSString *)content;//本地key 本地iv, 
+ (NSString *)chatTypeDecryptAesUseLoacalKeyAndServiceSaveIvAndTimeStr:(NSString *)timeStr withStr:(NSString *)content;//解密用 本地的key + data所在同级别的time +iv
+ (NSString *)testAesDecryptWithKey:(NSString *)key withIv:(NSString *)iv with:(NSString *)content;
// MD5签名
+ (NSString *)chatMD5ForString:(NSString *)string;


@end

NS_ASSUME_NONNULL_END
