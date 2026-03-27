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

+ (UIImage*)changeImageSizeWithImg:(UIImage *)oldImage scaleToSize:(CGSize)newSize
{
    
//    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [[UIScreen mainScreen]scale] );
    
    [oldImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

@end
