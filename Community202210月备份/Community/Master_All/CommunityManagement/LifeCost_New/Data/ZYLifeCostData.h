//
//  ZYLifeCostData.h
//  Community
//
//  Created by ZY on 2022/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBoolBlock)(id responsObject, BOOL success);

@interface ZYLifeCostData : NSObject

#pragma mark - 户号管理
// 户号列表
+ (void)lifeCostHouseholdListWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block;

// 添加分组
+ (void)lifeCostAddGroupWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block;

// 修改分组
+ (void)lifeCostUpdateGroupWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block;

// 删除分组
+ (void)lifeCostDeleteGroupWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block;

// 绑定户号
+ (void)lifeCostAddHouseholdWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block;

// 修改户号
+ (void)lifeCostModifyHouseholdWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block;

// 删除户号
+ (void)lifeCostDeleteHouseholdWithParams:(NSDictionary *)params dictBlock:(SuccessBoolBlock)block;

@end

NS_ASSUME_NONNULL_END
