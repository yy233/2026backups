//
//  UIView+RounderCorner.m
//  casgpLayerBezierPathCoreGraphics圆角
//
//  Created by 余莹 on 2021/1/9.
//

#import "UIView+RounderCorner.h"

@implementation UIView (RounderCorner)

- (void)dlj_addRounderCornerWithRadius:(CGFloat)radius size:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(cxt, [UIColor redColor].CGColor);
    CGContextSetStrokeColorWithColor(cxt, [UIColor redColor].CGColor);
    
    CGContextMoveToPoint(cxt, size.width, size.height-radius);
    CGContextAddArcToPoint(cxt, size.width, size.height, size.width-radius, size.height, radius);//右下角
    CGContextAddArcToPoint(cxt, 0, size.height, 0, size.height-radius, radius);//左下角
    CGContextAddArcToPoint(cxt, 0, 0, radius, 0, radius);//左上角
    CGContextAddArcToPoint(cxt, size.width, 0, size.width, radius, radius);//右上角
    CGContextClosePath(cxt);
    CGContextDrawPath(cxt, kCGPathFillStroke);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [imageView setImage:image];
    [self insertSubview:imageView atIndex:0];
}/**
  这个方法返回的是 UIImage，也就是说我们利用 Core Graphics 自己画出了一个圆角矩形。除了一些必要的代码外，最核心的就是 CGContextAddArcToPoint 函数。它中间的四个参数表示曲线的起点和终点坐标，最后一个参数表示半径。调用了四次函数后，就可以画出圆角矩形。最后再从当前的绘图上下文中获取图片并返回。
  有了这个图片后，我们创建一个 UIImageView 并插入到视图层级的底部。
  使用时，你只需要这样写：
  [view dlj_addRounderCornerWithRadius:10 size:CGSizeMake(60, 30)];
  */

- (void)dlj_addRounderCornerWithRadius:(CGFloat)radius corners:(UIRectCorner) corners{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;

    self.layer.mask = maskLayer;
}

@end
