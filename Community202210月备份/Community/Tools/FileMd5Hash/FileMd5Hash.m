//
//  FileMd5Hash.m
//  Community
//
//  Created by 余莹 on 2021/10/25.
//

#import "FileMd5Hash.h"

@implementation FileMd5Hash
//SHA加密
/**

+ (NSString *)computeHashForFile:(NSURL *)fileURL {
    NSString *fileContentsHash;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]) {
        NSData *fileContents = [NSData dataWithContentsOfURL:fileURL];
        fileContentsHash = [self computeHashForData:fileContents];
    }
    return fileContentsHash;
}

+ (NSString *)computeHashForData:(NSData *)inputData {
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    CC_SHA256(inputData.bytes, (CC_LONG)inputData.length, digest);
    NSMutableString* inputHash = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [inputHash appendFormat:@"%02x", digest[i]];
    }
    return inputHash;
}
 */
//MD5计算

+ (NSString *)computeHashForFile:(NSURL *)fileURL {
    NSString *fileContentsHash;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]) {
        NSData *fileContents = [NSData dataWithContentsOfURL:fileURL];
        fileContentsHash = [self computeHashForData:fileContents];
    }
    return fileContentsHash;
}

+ (NSString *)computeHashForData:(NSData *)inputData {
    uint8_t digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(inputData.bytes, (CC_LONG)inputData.length, digest);
    NSMutableString *inputHash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [inputHash appendFormat:@"%02x", digest[i]];
    }
    return inputHash;
}

//字符串Hash值计算:
+ (NSString *)computeHashForString:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", digest[i]];
    }
    return hash;
}
@end
