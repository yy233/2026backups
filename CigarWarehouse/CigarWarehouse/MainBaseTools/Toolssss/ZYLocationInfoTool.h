//
//  ZYLocationInfoTool.h
//  ZYVC
//
//  Created by ZY on 2021/5/23.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZYLocatonInfoBlock)(NSString *locationStr);

@interface ZYLocationInfoTool : NSObject

// 根据经纬度获取位置信息
+ (void)getLocatonInfoWithLat:(CLLocationDegrees)lat AndLon:(CLLocationDegrees)lon LocatonInfoBlock:(ZYLocatonInfoBlock)block;

@end

NS_ASSUME_NONNULL_END
