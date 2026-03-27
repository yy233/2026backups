//
//  MapInfoColorCaseHelperAndOtherTool.h
//  RobotSweeper
//
//  Created by 余莹 on 2019/4/26.
//  Copyright © 2019 余莹. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MapInfoColorCaseHelperAndOtherTool : NSObject

//地图开辟颜色空间
+ (void)useDataPMallocWithData:(NSData *)data
               charPointMalloc:(unsigned char*)mallocPoint;//colors: 转换后的RGB数据


//地图转化成img
+ (UIImage *)getImgWithRect:(CGRect)rect
              charPointRgba:(unsigned char*)rgba;//colors: 转换后Img


//开辟颜色空间 用于区域数据转img和arr
+ (NSMutableArray*)twoUseDataPMallocWithData:(NSData *)data
                             charPointMalloc:(unsigned char*)mallocPoint
                            arrOfChangeColor:(NSMutableArray*)arrOfChangeColor
                                           w:(int)w;//增加宽度



#pragma mark - 冒泡升序排序 最大的放最后一个位置
+ (NSMutableArray *)bubbleAscendingOrderSortWithArray:(NSMutableArray *)ascendingArr;

//用已知画布大小画图
+ (UIImage *)combineTwoImgWithX:(int)mapImgX
                              y:(int)mapImgY
                              w:(int)w
                              h:(int)h
                       NewImage:(UIImage*)newImage
                        newPosx:(int)newPosx
                        newPosy:(int)newPosy
                           newW:(int)newW
                           newH:(int)newH
                    beforeImage:(UIImage*)beforeImage
                     beforePosx:(int)beforePosx
                     beforePosy:(int)beforePosy
                        beforeW:(int)beforeW
                        beforeH:(int)beforeH;

@end

NS_ASSUME_NONNULL_END
