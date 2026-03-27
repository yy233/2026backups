//
//  MyCarInfoOrParkingOrPayHistoryData.h
//  Community
//
//  Created by 余莹 on 2022/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCarInfoOrParkingOrPayHistoryData : NSObject
//车辆
+ (void)myCarInfoListWithParms:(NSMutableDictionary *)parms withBlock:(BaseListArrAndSuccessBoolBlock)block;
//新增车辆
+ (void)myCarAddOneCartWithParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block;
//删除车辆
+ (void)myCarDeletOneCartWithParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block;


//车位
+ (void)myCarPakingSpotInfoListWithParms:(NSMutableDictionary *)parms withBlock:(BaseListArrAndSuccessBoolBlock)block;
//添加车辆为主绑定车辆
+ (void)myCarPakingSpotAddSubCarPlateInfoWithBody:(NSMutableDictionary *)body withBlock:(BaseDicAndSuccessBoolBlock)block;

//缴费历史列表
+ (void)myCarSpotPayHistoryListWithParms:(NSMutableDictionary *)parms withBlock:(BaseListArrAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
