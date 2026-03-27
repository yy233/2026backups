//
//  Tool.m
//  地图画图区域试写
//
//  Created by Joey on 2018/11/20.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import "ToolOfQuYuV.h"

@implementation ToolOfQuYuV
+ (CGRect )rectanglePointAndWHwithBegP:(CGPoint)bP
                                         endP:(CGPoint)eP{
    //两点成矩形 得到rect
    CGFloat rW = 0;
    CGFloat rH = 0;
    CGPoint rOneP = CGPointMake(0, 0);
    CGFloat onePx = 0;
    CGFloat onePy = 0;
    CGRect rRect = CGRectMake(0, 0, 0, 0);
    
    //小为第一点
    if (bP.x>eP.x) {
        onePx = eP.x;
        rW = bP.x-eP.x;
    }else{
        onePx = bP.x;
        rW = -(bP.x-eP.x);
    }
    
    if (bP.y>eP.y){
        onePy = eP.y;
        rH = bP.y-eP.y;
    }else{
        onePy = bP.y;
        rH = -(bP.y-eP.y);
    }
    rOneP = CGPointMake(onePx, onePy);
    rRect = CGRectMake(onePx, onePy, rW, rH);
    return rRect;
    
}
@end
