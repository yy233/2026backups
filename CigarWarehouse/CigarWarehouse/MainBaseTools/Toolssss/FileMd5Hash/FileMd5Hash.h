//
//  FileMd5Hash.h
//  Community
//
//  Created by 余莹 on 2021/10/25.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>
NS_ASSUME_NONNULL_BEGIN

@interface FileMd5Hash : NSObject

+ (NSString *)computeHashForString:(NSString *)string;
+ (NSString *)computeHashForData:(NSData *)inputData;
+ (NSString *)computeHashForFile:(NSURL *)fileURL;
@end

NS_ASSUME_NONNULL_END
