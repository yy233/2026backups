//
//  RotueViewZhuanSaoDataDeal.h
//  RobotSweeper
//
//  Created by 余莹 on 2019/3/5.
//  Copyright © 2019 余莹. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RotueViewZhuanSaoDataDeal : NSObject
//@property (nonatomic,strong) NSString *strOfAreaAllowOfBeginGesSaVe;//beginGes时存下的协议str



+(NSString *)newZhuanSaoShow;//使用 pox 坐标 得到专扫区的初坐标（左上右下点）

+(int)thisOneIsStatuRequesWithAreaAllowStr:(NSString *)strOfAreaAllow
                              pointOfWallV:(CGPoint)pointOfWallV
                           pointOfWallSubV:(CGPoint)pointOfWallSubV
                               pointOfOneP:(CGPoint)pOne
                               pointOfTwoP:(CGPoint)pTwo
                              saveMapScale:(CGFloat)mapScale;



+(NSString *)getRouteViewZhuanSaoStrWithAreaAllowStr:(NSString *)strOfAreaAllow
                                         intOfStatus:(int)intOfStatus
                                         pointOfOneP:(CGPoint)pOne
                                         pointOfTwoP:(CGPoint)pTwo
                                        saveMapScale:(CGFloat)mapScale;

@end

NS_ASSUME_NONNULL_END
