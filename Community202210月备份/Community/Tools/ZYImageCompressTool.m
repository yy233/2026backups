//
//  ZYImageCompressTool.m
//  Community
//
//  Created by ZY on 2021/5/19.
//

#import "ZYImageCompressTool.h"

@implementation ZYImageCompressTool

+ (NSData *)imageCompress:(UIImage *)originalImage {
    
    NSData *data=UIImageJPEGRepresentation(originalImage, 1.0);
    if (data.length>1024 *1024) {
        if (data.length>10240*1024) {//10M以及以上
            data=UIImageJPEGRepresentation(originalImage, 0.1);//压缩之后1M~
        }else if (data.length>5120*1024){//5M~10M
            data=UIImageJPEGRepresentation(originalImage, 0.2);//压缩之后1M~2M
        }else if (data.length>2048*1024){//2M~5M
            data=UIImageJPEGRepresentation(originalImage, 0.5);//压缩之后1M~2.5M
        }else if (data.length>1048*1024){//1M~2M
            data=UIImageJPEGRepresentation(originalImage, 0.5);//压缩之后0.5M~1M
        }
        //~1M不压缩
    }
    
    return data;
}

+ (NSData *)image100KBCompress:(UIImage *)originalImage {
    NSData *data = UIImageJPEGRepresentation(originalImage, 1.0);
    if (data.length>1024*1024) {
        if (data.length>10240*1024) {//10M以及以上
            data=UIImageJPEGRepresentation(originalImage, 0.008);//压缩之后80KB~
        }else if (data.length>5120*1024){//5M~10M
            data=UIImageJPEGRepresentation(originalImage, 0.01);//压缩之后50KB~100KB
        }else if (data.length>2048*1024){//2M~5M
            data=UIImageJPEGRepresentation(originalImage, 0.02);//压缩之后40KB~100KB
        }else {//1M~2M
            data=UIImageJPEGRepresentation(originalImage, 0.03);//压缩之后30KB~60KB
        }
    }else {//1M以内
        data=UIImageJPEGRepresentation(originalImage, 0.05);//压缩之后100KB以内
    }
    
    return data;
}

//压缩到200k内
+ (NSData *)image200KBCompressWithImg:(UIImage *)originalImage {
    
    return  [self compressImageGetData:originalImage toByte:(190*1024)];
  
}
//压缩到某个大小
+ (NSData *)compressImageGetData:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}

+ (CGFloat )compressImageGetChangeFloat:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return compression;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return compression;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return compression;
}

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}


@end
