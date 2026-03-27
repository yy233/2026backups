//
//  ZYImageCompressTool.h
//  Community
//
//  Created by ZY on 2021/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYImageCompressTool : NSObject

// 图片压缩
+ (NSData *)imageCompress:(UIImage *)originalImage;

// 图片100KB以内压缩
+ (NSData *)image100KBCompress:(UIImage *)originalImage;

@end

NS_ASSUME_NONNULL_END
