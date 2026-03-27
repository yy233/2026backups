//
//  Tool.h
//  地图画图区域试写
//
//  Created by Joey on 2018/11/20.
//  Copyright © 2018年 余莹. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ToolOfQuYuV : NSObject

//两点成矩形的数据转换
+ (CGRect )rectanglePointAndWHwithBegP:(CGPoint)bP
                                         endP:(CGPoint)ep;
@end
