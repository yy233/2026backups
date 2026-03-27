//
//  ZYParkingTemporaryDetailModel.h
//  Community
//
//  Created by ZY on 2021/10/27.
//

#import <Foundation/Foundation.h>

@class ZYParkingTemporaryDetailDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYParkingTemporaryDetailModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYParkingTemporaryDetailDataModel *data;

@end


@interface ZYParkingTemporaryDetailDataModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 进场时间
@property (nonatomic, copy) NSString *beginTime;

// 出场时间
@property (nonatomic, copy) NSString *overTime;

// 金额
@property (nonatomic, copy) NSString *money;

// 车牌号
@property (nonatomic, copy) NSString *carPlate;

// 车辆类型
@property (nonatomic, copy) NSString *carTypeText;

// 小区名称
@property (nonatomic, copy) NSString *carPositionText;

// 停留分钟
@property (nonatomic, copy) NSString *minute;

// 收费标准xxx/小时
@property (nonatomic, copy) NSString *expenseRule;

// 多少小时后按天算
@property (nonatomic, copy) NSString *retentionHour;

// 缴费后允许停留留时间
@property (nonatomic, copy) NSString *retentionMinute;

@end

NS_ASSUME_NONNULL_END
