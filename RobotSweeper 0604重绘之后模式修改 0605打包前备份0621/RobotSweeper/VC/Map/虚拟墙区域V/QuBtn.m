//
//  QuBtn.m
//  地图画图区域试写
//
//  Created by Joey on 2019/1/29.
//  Copyright © 2019年 余莹. All rights reserved.
//

#import "QuBtn.h"

@implementation QuBtn

 //斜栅格
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
  //斜线
    [self drawLine:rect];
    
}
- (void)drawLine:(CGRect)rect{
    
    
    //  1.在此方法中系统已经创建一个与view相关联的上下文(layer上下文), 只要获取上下文就行;(获取和创建上下文都是UIGraphics开头)
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    //2.绘制路径(一条路径可以描述多条线)
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //    2.1 设置起点
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y)];
    //2.2 添加一根线到终点
    [path addLineToPoint:CGPointMake(rect.origin.x+(rect.size.width), rect.origin.y+(rect.size.height*0.2))];
    
//    //画第二条线
   [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y+(rect.size.height*0.2))];
    //2.2 添加一根线到终点, 直接写addLine不写moveTo则代表在上一根线的终点继续画
    [path addLineToPoint:CGPointMake(rect.origin.x+(rect.size.width), rect.origin.y+(rect.size.height*0.4))];
//
//    //画第3条线
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y+(rect.size.height*0.4))];
    //2.2 添加一根线到终点, 直接写addLine不写moveTo则代表在上一根线的终点继续画
    [path addLineToPoint:CGPointMake(rect.origin.x+(rect.size.width), rect.origin.y+(rect.size.height*0.6))];
//
//    //画第4条线
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y+(rect.size.height*0.6))];
    //2.2 添加一根线到终点, 直接写addLine不写moveTo则代表在上一根线的终点继续画
    [path addLineToPoint:CGPointMake(rect.origin.x+(rect.size.width), rect.origin.y+(rect.size.height*0.8))];
//
//    //画第5条线
    [path moveToPoint:CGPointMake(rect.origin.x, rect.origin.y+(rect.size.height*0.8))];
    //2.2 添加一根线到终点, 直接写addLine不写moveTo则代表在上一根线的终点继续画
    [path addLineToPoint:CGPointMake(rect.origin.x+(rect.size.width), rect.origin.y+(rect.size.height))];
    
    //设置线的粗细
    CGContextSetLineWidth(ctx, 1);
    
    //设置两根线的连接样式, 第二个参数是枚举
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    //设置两根线各组尾部的样式, 第二个参数是枚举
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    //    setStroke还是setFill看最终设定的渲染方式
    if (self.tag/100>3) {
         [[UIColor redColor] setStroke];
    }else{
         [[UIColor blueColor] setStroke];
    }
  
    
    //3.把绘制的内容添加到上下文中
    //UIBezierPath是UIKit框架  第二个参数, CGPathRef是coreGraphic框架
    CGContextAddPath(ctx, path.CGPath);
    
    //4.把上下文渲染到view的layer上(stroke或fill的方式)
    CGContextStrokePath(ctx);
    NSLog(@"QuBtnDrawRect");
}
@end
