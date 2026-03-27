//
//  MyCarInfoData.h
//  Community
//
//  Created by 余莹 on 2021/8/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyCarInfoData : NSObject
+ (void)getMyCarListWithBlcok:(BaseListArrAndSuccessBoolBlock)block;
+ (void)addMyCarWithCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)editMyCarWithCarInfoDic:(NSMutableDictionary *)carInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block;
+ (void)deletMyCarWithId:(NSInteger)carId withBlock:(BaseDicAndSuccessBoolBlock)block;

@end

NS_ASSUME_NONNULL_END
