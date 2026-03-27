//
//  MapDataTool.h
//  RobotSweeper
//
//  Created by Joey on 2019/1/11.
//  Copyright © 2019年 余莹. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapDataTool : NSObject
//地图图片数据原点 <-> 地图的imgView中心点 的差值 已原点为00->得到地图中心点的坐标  (倍数关系不影响坐标)
+(CGPoint)mapImgOriginPointAndCenterPointRelativeCoordinates;

//地图图片数据 宽高
+(CGSize)mapImgWidthAndHeight;

#pragma mark -- 0124 mapimg rect倍数变化
+(UIImage *)getNewScaleImg:(UIImage *)mapSourceImg scale:(CGFloat)mapScale;

//得到当前地图的宽高值
+ (NSArray*)getMapWAndH;
@end
