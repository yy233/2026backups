//
//  DirectionBtn.m
//  RobotSweeper
//
//  Created by Joey on 2018/9/17.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "DirectionBtn.h"

@implementation DirectionBtn


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

-(instancetype)initWithFrame:(CGRect)frame
                      radius:(CGFloat)radius
                      centerP:(CGPoint)centerP
                         begA:(CGFloat)begA
                         endA:(CGFloat)endA{
    self=[super initWithFrame:frame];
    if (self) {
        self.radius = radius;
        self.centerP = centerP;
        self.begA = begA;
        self.endA = endA;
        
        [self setNeedsDisplay];
    }
    
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * blackColor = [UIColor orangeColor];
    
    CGContextSetFillColorWithColor(context, blackColor.CGColor);
//    CGContextMoveToPoint(context, 220, 220);
//    CGContextAddArc(context, 220, 220, 150, 180 * M_PI/180, 360 * M_PI/180, 0);
    CGContextMoveToPoint(context, self.centerP.x, self.centerP.y);
    CGContextAddArc(context, self.centerP.x, self.centerP.y, self.radius,self.begA * M_PI/180, self.endA* M_PI/180, 1);//0为顺时针，1为逆时针。
   
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
     self.selfPath = context;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    //三角形试试
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.centerP.x, self.centerP.y);//开始dia
//    begA:-20 endA:-160 begA:-160 endA:90] right begA:90 endA:-20];
    if (self.begA == -20) {//top
        CGPathAddLineToPoint(path, NULL, 0, 0.5*self.radius);//左
        CGPathAddLineToPoint(path, NULL, 2*self.radius, 0.5*self.radius);//右
    }else if(self.begA==-160){//left
        CGPathAddLineToPoint(path, NULL, 0, 0.5*self.radius);//左
        CGPathAddLineToPoint(path, NULL, self.radius, 2*self.radius);//下
    }else if(self.begA==90){//right
        CGPathAddLineToPoint(path, NULL, 2*self.radius, 0.5*self.radius);//右
        CGPathAddLineToPoint(path, NULL, self.radius, 2*self.radius);//下
    }else{
        
    }
  
    CGPathCloseSubpath(path);
    
    
    BOOL b = CGPathContainsPoint(path, NULL, point, YES);
    if (b) {
        return YES;
    }else
        return NO;
 
//    BOOL b = CGPathContainsPoint(_selfPath, NULL, point, YES);
    NSLog(@"CGPathContainsPoint  = %@",b);
    return b;
}

/**
 首先温习下初中的知识:
 1弧度＝180°/π （≈57.3°）
 度＝弧度×180°/π
 360°＝ 360×π/180 ＝2π 弧度
 
 然后:
 x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
 
 再:
 
 CGContextAddArc(context, self.center.x, self.center.y, sectionRadius, 0, 2 * M_PI, 0);
 1
 意思是:在当前画布上,以 self.center.x, self.center.y 为圆心,顺时针画一个360度的圆.
 */

@end
