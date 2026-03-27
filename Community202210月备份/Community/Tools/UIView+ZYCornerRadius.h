//
//  UIView+ZYCornerRadius.h
//  ZYVC
//
//  Created by ZY on 2021/7/24.
//

#import <UIKit/UIKit.h>

typedef struct {
     CGFloat topLeft;
     CGFloat topRight;
     CGFloat bottomLeft;
     CGFloat bottomRight;
} ZYCornerRadii;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ZYCornerRadius)

ZYCornerRadii ZYCornerRadiiMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight);

// 切所有圆角
- (void)cornerRadiusWithRadius:(CGFloat)radius;

// 切指定圆角
- (void)cornerRadiusWithRadius:(CGFloat)radius corners:(UIRectCorner)corners;

// 切指定位置圆角
- (void)cornerRadiusWithBounds:(CGRect)bounds radius:(CGFloat)radius corners:(UIRectCorner)corners;

// 切任意圆角
- (void)cornerRadiusWithCornerRadii:(ZYCornerRadii)cornerRadii;

@end

NS_ASSUME_NONNULL_END
