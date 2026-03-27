//
//  UIColor+Gradient.h
//  MorningCall
//
//  Created by pc on 2020/10/21.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 渐变方式

 - IHGradientChangeDirectionLevel:              水平渐变
 - IHGradientChangeDirectionVertical:           竖直渐变
 - IHGradientChangeDirectionUpwardDiagonalLine: 向下对角线渐变
 - IHGradientChangeDirectionDownDiagonalLine:   向上对角线渐变
 */
typedef NS_ENUM(NSInteger, IHGradientChangeDirection) {
    IHGradientChangeDirectionLevel,
    IHGradientChangeDirectionVertical,
    IHGradientChangeDirectionUpwardDiagonalLine,
    IHGradientChangeDirectionDownDiagonalLine,
};

@interface UIColor (Gradient)

/*
 
 size:渐变区域的尺寸
 
 direction:渐变方向
 
 startColor:开始颜色
 
 endColor:结束颜色
 
 */

+ (instancetype)bm_colorGradientChangeWithSize:(CGSize)size

                                     direction:(IHGradientChangeDirection)direction

                                    startColor:(UIColor*)startcolor

                                      endColor:(UIColor*)endColor;
+ (instancetype)y_colorGradientChangeWithSize:(CGSize)size

                                     direction:(IHGradientChangeDirection)direction

                                    startColor:(UIColor*)startcolor

                                      endColor:(UIColor*)endColor;


@end

NS_ASSUME_NONNULL_END
