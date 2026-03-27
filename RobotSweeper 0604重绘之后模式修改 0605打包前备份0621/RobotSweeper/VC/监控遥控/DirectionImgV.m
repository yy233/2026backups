//
//  DirectionImgV.m
//  RobotSweeper
//
//  Created by Joey on 2018/9/17.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "DirectionImgV.h"

@implementation DirectionImgV
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
    
    UIColor * blackColor = [UIColor greenColor];
    
    CGContextSetFillColorWithColor(context, blackColor.CGColor);
    //    CGContextMoveToPoint(context, 220, 220);
    //    CGContextAddArc(context, 220, 220, 150, 180 * M_PI/180, 360 * M_PI/180, 0);
    CGContextMoveToPoint(context, self.centerP.x, self.centerP.y);
    CGContextAddArc(context, self.centerP.x, self.centerP.y, self.radius,self.begA * M_PI/180, self.endA* M_PI/180, 1);//0为顺时针，1为逆时针。
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

@end
