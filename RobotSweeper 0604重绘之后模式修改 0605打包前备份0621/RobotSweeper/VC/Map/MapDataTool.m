//
//  MapDataTool.m
//  RobotSweeper
//
//  Created by Joey on 2019/1/11.
//  Copyright © 2019年 余莹. All rights reserved.
//

#import "MapDataTool.h"

@implementation MapDataTool

//ImgVcenter点与ImgV原点会随着地图大小变化而改变 所以虚拟墙的center点改成imgV的原点
+(CGPoint)mapImgOriginPointAndCenterPointRelativeCoordinates{
     
    //mapimg原点的相对于屏幕的坐标 原点x=x-中心点x 原点y=y-中心点y，加上1/2得到相对于屏幕的，最后+xm+ym
    //中心x =x-原点
    CGPoint returnPoint = CGPointMake(0, 0);
    
    
    CGFloat wImg = [DataManager shareDataManager].mapRightEnd - [DataManager shareDataManager].mapLeftEnd;
    CGFloat hImg = [DataManager shareDataManager].mapTopEnd - [DataManager shareDataManager].mapBottomEnd;
    CGFloat xC = [DataManager shareDataManager].mapRightEnd - wImg*0.5;
    CGFloat yC = [DataManager shareDataManager].mapTopEnd - hImg*0.5;
    
    
    
    returnPoint = CGPointMake(xC,yC);
//    NSLog(@"mapImgOriginPointAndCenterPointRelativeCoordinates x=%f y=%f ",xC,yC);
   
    return returnPoint;
}

//地图图片数据 宽高
+(CGSize)mapImgWidthAndHeight{
    CGSize sizeOfWAndH = CGSizeMake(0, 0);
    
    CGFloat widthOfImg = DataManager.shareDataManager.mapRightEnd-DataManager.shareDataManager.mapLeftEnd;
    CGFloat heightOfImg = DataManager.shareDataManager.mapTopEnd-DataManager.shareDataManager.mapBottomEnd;
    sizeOfWAndH = CGSizeMake(widthOfImg, heightOfImg);
    return sizeOfWAndH;
}

#pragma mark -- 0124 mapimg rect倍数变化
+(UIImage *)getNewScaleImg:(UIImage *)mapSourceImg scale:(CGFloat)mapScale{

    CGSize size = CGSizeMake(mapSourceImg.size.width*mapScale,mapSourceImg.size.height*mapScale );
    NSLog(@"mapSourceImg%@ mapScale=%f new.w=%f new.h=%f",mapSourceImg,mapScale ,size.width,size.height);
    
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    // 绘制改变大小的图片
    [mapSourceImg drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
    
}

+ (NSArray*)getMapWAndH{
    
    CGFloat wImg = [DataManager shareDataManager].mapRightEnd - [DataManager shareDataManager].mapLeftEnd;
    CGFloat hImg = [DataManager shareDataManager].mapTopEnd - [DataManager shareDataManager].mapBottomEnd;
    NSString *strOfW = [NSString stringWithFormat:@"%0.0f",wImg];
    NSString *strOfH = [NSString stringWithFormat:@"%0.0f",hImg];

    NSArray *rArr = @[strOfW,strOfH];
    return rArr;
    
}
@end
