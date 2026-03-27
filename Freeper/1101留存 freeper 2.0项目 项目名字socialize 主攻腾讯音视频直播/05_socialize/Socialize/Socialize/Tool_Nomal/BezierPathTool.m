//
//  BezierPathTool.m
//  Community
//
//  Created by 余莹 on 2022/5/7.
//

#import "BezierPathTool.h"

#pragma mark ==
 
@implementation BezierPathTool

 

//圆角
+ (CAShapeLayer *)bezierPathToolWithThisViewBounds:(CGRect)bounds
                                    withCornerRadi:(CGSize)size
                               withRoundingCorners:(UIRectCorner)rectCorner{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:rectCorner cornerRadii:size];//圆角大小
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    return maskLayer;
    
}
//虚线
+ (CAShapeLayer *)lineLayerWithThisViewBounds:(CGRect)bounds
                                    withLineW:(CGFloat)lineW
                                withLineColor:(UIColor*)lineColor{
    //虚线框
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = lineColor.CGColor ;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRect:bounds].CGPath;
    border.frame = bounds;
    border.lineWidth = lineW;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @2];//虚线每段长度和间隔
    return border;

}
//虚线圆角
+ (CAShapeLayer *)drawDotLineWithThisViewBounds:(CGRect)bounds
                                  withLineColor:(UIColor *)lineColor
                                  withFillColor:(UIColor *)fillColor
                                  withLineWidth:(CGFloat)lineWidth
                                    AndLineType:(NSString *)type
                               withCornerRadius:(CGFloat)radius
                            withRoundingCorners:(UIRectCorner)rectCorner{

    
    //圆角大小
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(radius, radius)];
    //其他
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = lineColor.CGColor;
    shapeLayer.fillColor = fillColor.CGColor;
    shapeLayer.path = maskPath.CGPath;
    shapeLayer.frame = bounds;
    shapeLayer.lineWidth = lineWidth;
    if (type) {
        shapeLayer.lineCap = type;

    }else{
        shapeLayer.lineCap = @"square";
    }
    //虚线每段长度和间隔
    shapeLayer.lineDashPattern = @[@(2), @(2)];

    return shapeLayer;

}

@end
