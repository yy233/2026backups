//
//  ParkingCarData.h
//  Community
//
//  Created by 余莹 on 2021/8/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ParkingCar_Type_Temporary,//临时
    ParkingCar_Type_Monthly,  //月缴
} ParkingCar_Type;

@interface ParkingCarData : NSObject
/**
 //临时缴费 暂时不使用
 + (void)lingShiGetMyCarListWithBlcok:(BaseListArrAndSuccessBoolBlock)block;
 + (void)lingShiAddCarWithParkCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block;

 + (void)parkingAddCarWithParkCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block;
 */

//绑定月租车辆
+ (void)parkingBindingMonthCarWithParkCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block;

//月租车辆续约
+ (void)parkingRenewMonthCarWithParkCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block;
//删除月租车辆
+ (void)parkingDeletMonthCarWithParkCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block;
//____________________
//月租缴费车辆查询
+ (void)parkingMonthlyTypeCarListWithBlock:(BaseListArrAndSuccessBoolBlock)block;


//缴费记录
+ (void)payParkingHistoryListWithType:(ParkingCar_Type)type withListBlock:(BaseListArrAndSuccessBoolBlock)block;
+ (void)payMonthsOneOrderInfoWithIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block;  //一个月租缴费记录详情

//查询车位
+ (void)parkingGetPositionInfoWithCommunityInfoDic:(NSMutableDictionary *)communityInfoDic withBlock:(BaseListArrAndSuccessBoolBlock)block;

//输入月份获取应缴金额
+ (void)parkineGetMoneyWithNowInfoDic:(NSMutableDictionary *)communityInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
