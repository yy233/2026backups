//
//  TrajectoryViewData.h
//  RobotSweeper
//
//  Created by 余莹 on 2019/4/16.
//  Copyright © 2019 余莹. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *kTrajectNoticeStr = @"kTrajectViewInfoUPNoticeStr";

@interface TrajectoryViewData : NSObject
 
//+ (void)getDataSourceArrOfXmppTrajectArr:(NSMutableArray *)arrOfxmppTrajectInfo;//xmpp数据换成显示使用的数据l；

//轨迹数据变化 和 当前缩放倍数变化（倍数关系是要计算出新职）
+ (void)changeTrajectoryPointArrWithXmppinfoStr:(NSString*)xmppstr
                                       mapScale:(CGFloat)mapScaleFloat;

//地图图片imgf的fram大小变化 和 当前缩放倍数变化（倍数关系是要计算出新职）
//+ (void)changeTrajectoryViewFramWithMapImgViewFram:(CGRect *)mapImgfram
//                                          mapScale:(CGFloat)mapScaleFloat;

@end

NS_ASSUME_NONNULL_END
