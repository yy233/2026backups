//
//  BezierPathTool.h
//  Community
//
//  Created by 余莹 on 2022/5/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface BezierPathTool : NSObject
+ (CAShapeLayer *)bezierPathToolWithThisViewBounds:(CGRect)bounds
                                    withCornerRadi:(CGSize)size
                               withRoundingCorners:(UIRectCorner)rectCorner;

+ (CAShapeLayer *)lineLayerWithThisViewBounds:(CGRect)bounds
                                    withLineW:(CGFloat)lineW
                                withLineColor:(UIColor*)lineColor;
//虚线圆角
+ (CAShapeLayer *)drawDotLineWithThisViewBounds:(CGRect)bounds
                                  withLineColor:(UIColor *)lineColor
                                  withFillColor:(UIColor *)fillColor
                                  withLineWidth:(CGFloat)lineWidth
                                    AndLineType:(NSString *)type
                               withCornerRadius:(CGFloat)radius
                            withRoundingCorners:(UIRectCorner)rectCorner;
@end

NS_ASSUME_NONNULL_END
