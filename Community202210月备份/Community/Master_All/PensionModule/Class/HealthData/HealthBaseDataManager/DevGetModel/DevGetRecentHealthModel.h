//
//  DevGetRecentHealthModel.h
//  Community
//
//  Created by 余莹 on 2021/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DevGetRecentHealthModel : NSObject
@property (nonatomic,strong) NSString *refreshDataTime;
//心率
@property (nonatomic,assign) NSInteger silentHeart;
@property (nonatomic,assign) NSInteger silentHeartHealthStatus;
//睡眠
@property (nonatomic,assign) NSInteger sleepTime;//睡眠时间（返回分钟数）
@property (nonatomic,assign) NSInteger sleepHealthStatus;
//体温_额头
@property (nonatomic,assign) NSInteger tmpForehead;
@property (nonatomic,assign) NSInteger tmpForeheadHealthStatus;
//体温_手腕
@property (nonatomic,assign) double tmpHandler;
@property (nonatomic,assign) NSInteger tmpHandlerHealthStatus;
//
@property (nonatomic,assign) NSInteger userTotalHealthStatus;

/**
 ]1：绿色，2：黄色，3：红色）
 refreshDataTime = "2021-11-15 18:16:30";
 silentHeart = "<null>";
 silentHeartHealthStatus = "<null>";
 sleepHealthStatus = 3;
 sleepTime = 0;
 tmpForehead = 0;
 tmpForeheadHealthStatus = 3;
 tmpHandler = "35.1";
 tmpHandlerHealthStatus = 2;
 */
@end

NS_ASSUME_NONNULL_END
