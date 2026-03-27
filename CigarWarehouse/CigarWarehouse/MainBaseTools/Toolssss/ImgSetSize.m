//
//  ImgSetSize.m
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import "ImgSetSize.h"

@implementation ImgSetSize

+ (UIImage*)setimageSize:(UIImage *)inImage
                   width:(CGFloat)width
                    height:(CGFloat)height {
    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;
    CGImageRef imageRef = inImage.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
    destW,
    destH,
    CGImageGetBitsPerComponent(imageRef),
    4*destW,
    CGImageGetColorSpace(imageRef), kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    return result;
}

@end
