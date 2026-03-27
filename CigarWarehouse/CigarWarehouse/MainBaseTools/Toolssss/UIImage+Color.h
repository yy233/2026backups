//
//  UIImage+Color.h
//  MorningCall
//
//  Created by JIAQUAN ZHU on 2020/9/11.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, GradientType) {
    GradientTypeTopToBottom = 0,//从上到下
    GradientTypeLeftToRight = 1,//从左到右
    GradientTypeUpleftToLowright = 2,//左上到右下
    GradientTypeUprightToLowleft = 3,//右上到左下
};


@interface UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color;
- (UIImage *)imageWithColor:(UIColor *)color;
//@param colors 渐变颜色数组  @param gradientType 渐变样式  @param imgSize 图片大小  @return 颜色->图片
+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;
 

// 灰色图像
- (UIImage *)grayImage;

//生成二维码
+ (UIImage *)generateQRCodeWithString:(NSString *)string Size:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
