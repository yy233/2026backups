//
//  ChatAESTool.m
//  Community
//
//  Created by 余莹 on 2021/4/20.
//

#import "ChatAESTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>


#define kMobile              @"mobile"
//#define kMobile              [JGSaveIdShare sharedUserInfo].registrationID


//#define OPEN_ID              @"dd7186834b30422984643cb446ba0055"
//#define AES_KEY              @"dabd408a37ae486ea42dee52c6bd83bf"
//#define AES_IV               @"cvm472mmvb7ei5z6"
//0903更改key iv
#define OPEN_ID              @"open_7dcad41c19c24e7da0a61ab465c58bc0"
#define  AES_KEY          @"I|e7=N&?MUP?AnSwa0XNfXn^NewMsK:z"
#define  AES_IV           @"363}&ODSGrEuC9p6"

 
//____________
 
/**
 *第一个接口 用自己的数据 获取服务器的key,加密用本地key 本地iv,解密用rsa.===存储获取的服务器keyiv
 *后来的接口 iv都用（服务器拿到的活动iv, 3位）与时间戳拼接
 *加密用 服务器的key + 当前time+iv
 *解密用 本地的key + data所在同级别的time +iv
 **/


 
//____________
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"
 
// 秘钥长度256
size_t const kAESKeySize32UseEncry = kCCKeySizeAES256;
size_t const kAESKeySize16UseEncry = kCCKeySizeAES128;
// 秘钥长度128
size_t const kAESKeySize32UseDecry = kCCKeySizeAES256;
size_t const kAESKeySize16UseDecry = kCCKeySizeAES128;
 
@implementation ChatAESTool

#pragma mark === 加密
/**
 *交换服务器的aes keyiv
 */
+ (NSString *)chatTypeEncryptAESLocallyStoredKeyAndIvWithConnectStr :(NSString *)content{
    //本地32位数的key
    return [self encrypt256AesWithAesKey:AES_KEY withAesIv:AES_IV withStr:content];
}
/**
 *   交换客户端的aes keyiv
 */
+ (NSString *)chatTypeEncryptAESUseServiceKeyIvAndLocalTimeStr:(NSString *)timeStr withStr :(NSString *)content{
    NSString *key = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].service_Aes_Key;
    NSString *iv =  [NSString stringWithFormat:@"%@%@",timeStr,[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].service_Aes_Iv];
    if (key.length>16) {
        return [self encrypt256AesWithAesKey:key withAesIv:iv withStr:content];
    }else{
        return [self encrypt128AesWithAesKey:key withAesIv:iv withStr:content];
    }
  
}
 
#pragma mark === 解密
/**
 *   交换服务器的aes keyiv
 */
+ (NSString *)chatTypeDecryptAESUseLocalStroedKeyIvWithContentStr:(NSString *)content{
    //本地32位key
    return [self decrypt256AesWithAesKey:AES_KEY withAesIv:AES_IV withStr:content];
    
}
/**
 *   交换客户端的aes keyiv
 */
+ (NSString *)chatTypeDecryptAesUseLoacalKeyAndServiceSaveIvAndTimeStr:(NSString *)timeStr withStr:(NSString *)content{
//    NSString *key = [ShareSaveAesAndRsa sharedUserInfo].service_Aes_Key;
    NSString *key = AES_KEY;
    NSString *iv = [NSString stringWithFormat:@"%@%@",timeStr,[ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].service_Aes_Iv];
    if (key.length>16) {
        return [self decrypt256AesWithAesKey:key withAesIv:iv withStr:content];
    }else{
        return [self decrypt128AesWithAesKey:key withAesIv:iv withStr:content];
    }
   
}
+ (NSString *)testAesDecryptWithKey:(NSString *)key withIv:(NSString *)iv with:(NSString *)content{
    if (key.length>16) {
        return [self decrypt256AesWithAesKey:key withAesIv:iv withStr:content];
    }else{
        return [self decrypt128AesWithAesKey:key withAesIv:iv withStr:content];
    }
}
#pragma  mark ===  总
/**
* AES加密
*/
+ (NSString *)encrypt256AesWithAesKey:(NSString *)aesKey withAesIv:(NSString *)aesIv withStr:(NSString *)content{
   NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
   NSUInteger dataLength = contentData.length;
   
   // 为结束符'\0' +1
   char keyPtr[kAESKeySize32UseEncry + 1];
   memset(keyPtr, 0, sizeof(keyPtr));
   [aesKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
   
   // 密文长度 <= 明文长度 + BlockSize
   size_t encryptSize = dataLength + kCCBlockSizeAES128;
   void *encryptedBytes = malloc(encryptSize);
   size_t actualOutSize = 0;
   
   NSData *initVector = [aesIv dataUsingEncoding:NSUTF8StringEncoding];
   
   CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                         kCCAlgorithmAES,
                                         kCCOptionPKCS7Padding,
                                         keyPtr,
                                         kAESKeySize32UseEncry,
                                         initVector.bytes,
                                         contentData.bytes,
                                         dataLength,
                                         encryptedBytes,
                                         encryptSize,
                                         &actualOutSize);
   
   if (cryptStatus == kCCSuccess) {
       // 对加密后的数据进行 base64 编码
       NSData *data = [NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize];
       return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
   }
   free(encryptedBytes);
   return nil;
}
/**
* AES加密。128
*/
+ (NSString *)encrypt128AesWithAesKey:(NSString *)aesKey withAesIv:(NSString *)aesIv withStr:(NSString *)content{
   NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
   NSUInteger dataLength = contentData.length;
   
   // 为结束符'\0' +1
   char keyPtr[kAESKeySize16UseEncry + 1];
   memset(keyPtr, 0, sizeof(keyPtr));
   [aesKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
   
   // 密文长度 <= 明文长度 + BlockSize
   size_t encryptSize = dataLength + kCCBlockSizeAES128;
   void *encryptedBytes = malloc(encryptSize);
   size_t actualOutSize = 0;
   
   NSData *initVector = [aesIv dataUsingEncoding:NSUTF8StringEncoding];
   
   CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                         kCCAlgorithmAES,
                                         kCCOptionPKCS7Padding,
                                         keyPtr,
                                         kAESKeySize16UseEncry,
                                         initVector.bytes,
                                         contentData.bytes,
                                         dataLength,
                                         encryptedBytes,
                                         encryptSize,
                                         &actualOutSize);
   
   if (cryptStatus == kCCSuccess) {
       // 对加密后的数据进行 base64 编码
       NSData *data = [NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize];
       return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
   }
   free(encryptedBytes);
   return nil;
}
/**
 * AES解密
 */
+ (NSString *)decrypt256AesWithAesKey:(NSString *)aesKey withAesIv:(NSString *)aesIv withStr:(NSString *)content{

    // 将base64编码str转成data数据
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:0];
    NSUInteger dataLength = contentData.length;

    // 为结束符'\0' +1
    char keyPtr[kAESKeySize32UseDecry + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [aesKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    // 密文长度 <= 明文长度 + BlockSize
    size_t decryptSize = dataLength + kCCBlockSizeAES128;
    void *decryptBytes = malloc(decryptSize);
    size_t actualOutSize = 0;
    
    NSData *initVector = [aesIv dataUsingEncoding:NSUTF8StringEncoding];

    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES|kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kAESKeySize32UseDecry,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          decryptBytes,
                                          decryptSize,
                                          &actualOutSize);

    if (cryptStatus == kCCSuccess) {

        NSData *resultData = [NSData dataWithBytesNoCopy:decryptBytes length:actualOutSize];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(decryptBytes);
    return nil;
}
+ (NSString *)decrypt128AesWithAesKey:(NSString *)aesKey withAesIv:(NSString *)aesIv withStr:(NSString *)content{

    // 将base64编码str转成data数据
    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:0];
    NSUInteger dataLength = contentData.length;

    // 为结束符'\0' +1
    char keyPtr[kAESKeySize16UseDecry + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [aesKey getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    // 密文长度 <= 明文长度 + BlockSize
    size_t decryptSize = dataLength + kCCBlockSizeAES128;
    void *decryptBytes = malloc(decryptSize);
    size_t actualOutSize = 0;
    
    NSData *initVector = [aesIv dataUsingEncoding:NSUTF8StringEncoding];

    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES|kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kAESKeySize16UseDecry,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          decryptBytes,
                                          decryptSize,
                                          &actualOutSize);

    if (cryptStatus == kCCSuccess) {

        NSData *resultData = [NSData dataWithBytesNoCopy:decryptBytes length:actualOutSize];
        return [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    }
    free(decryptBytes);
    return nil;
}
 
  
#pragma mark === md5
// MD5签名
+ (NSString *)chatMD5ForString:(NSString *)string {
    const char *input = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

 

@end
