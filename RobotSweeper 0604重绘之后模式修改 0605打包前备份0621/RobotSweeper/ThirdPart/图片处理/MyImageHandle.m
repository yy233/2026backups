//
//  MyImageHandle.m
//  腾云家务
//
//  Created by 艾飞 on 14/7/8.
//  Copyright (c) 2014年 齐 浩. All rights reserved.
//

#import "MyImageHandle.h"

@implementation MyImageHandle


#pragma mark - 图片处理
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

+ (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName type:(NSString *)type userGuid:(NSString *)userGuid
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    //    NSMutableString * childWorkName  = [NSMutableString stringWithString:[tempStr stringByAppendingString:[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"workName"]]];
    //    NSString * str_type = [NSString stringWithString:[@"/" stringByAppendingString:type]];
    
    NSString * tempStr = [NSString stringWithString:[@"/" stringByAppendingString:[userGuid stringByAppendingString:type]]];
    
    NSMutableString * mutableStr = [NSMutableString stringWithString:[documentsDirectory stringByAppendingString:tempStr]];
    NSString * tempString  = [[NSMutableString alloc] init];
    tempString = [mutableStr stringByAppendingString:imageName];
    // and then we write it out
    [imageData writeToFile:tempString atomically:NO];
    return tempString;
}
+ (NSString *)saveSmallImage:(UIImage *)tempImage WithName:(NSString *)imageName type:(NSString *)type userGuid:(NSString *)userGuid
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    // Now we get the full path to the file
    //    NSMutableString * childWorkName  = [NSMutableString stringWithString:[tempStr stringByAppendingString:[[self.arForTable objectAtIndex:indexPath.row] valueForKey:@"workName"]]];
    NSString * str = [NSString stringWithString:[@"/" stringByAppendingString:@"Small"]];
    //    NSString * str_type = [NSString stringWithString:[@"/" stringByAppendingString:type]];
    NSString * tempStr = [NSString stringWithString:[[str stringByAppendingString:userGuid] stringByAppendingString:type]];
    
    NSMutableString * mutableStr = [NSMutableString stringWithString:[documentsDirectory stringByAppendingString:tempStr]];
    NSString * tempString  = [[NSMutableString alloc] init];
    tempString = [mutableStr stringByAppendingString:imageName];
    // and then we write it out
    [imageData writeToFile:tempString atomically:NO];
    return tempString;
}
+ (NSString *)saveAssetImage:(UIImage *)tempImage withName:(NSString *)imageName Type:(NSString *)type userGuid:(NSString *)userGuid
{
    NSData* imageData = UIImagePNGRepresentation(tempImage);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    
    NSString * tempStr = [NSString stringWithString:[@"/" stringByAppendingString:[userGuid stringByAppendingString:type]]];
    
    NSMutableString * mutableStr = [NSMutableString stringWithString:[documentsDirectory stringByAppendingString:tempStr]];
    NSString * tempString  = [[NSMutableString alloc] init];
    tempString = [mutableStr stringByAppendingString:imageName];
    // and then we write it out
    [imageData writeToFile:tempString atomically:NO];
    return tempString;
}

+ (UIImage*)cutImageWithOriginalImage:(UIImage *)originalImage withRect:(CGRect)newRect
{
    CGRect cutRect = CGRectMake(newRect.origin.x, newRect.origin.y - 40, newRect.size.width, newRect.size.height);
    UIImage *image1 = [self fixOrientation:originalImage];
    CGImageRef cgimg = CGImageCreateWithImageInRect([image1 CGImage], cutRect);
    UIImage *image = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    return image;
    
    
    
//    
//    CGImageRef subImageRef = CGImageCreateWithImageInRect([img CGImage], newRect);
//    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
//    
//    UIGraphicsBeginImageContext(smallBounds.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, smallBounds, subImageRef);
//    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
//    UIGraphicsEndImageContext();
    
//    return image;
}


+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/**
 *  create by lmc
 *  从图片中按指定的位置大小截取图片的一部分
 *
 *  @param image UIImage image 原始的图片
 *  @param rect  CGRect rect 要截取的区域
 *
 *  @return UIImage
 */
+ (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x,
    y=rect.origin.y,
    w=rect.size.width,
    h=rect.size.height;
    CGRect dianRect = CGRectMake(x, y, w, h);
    
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}


@end
