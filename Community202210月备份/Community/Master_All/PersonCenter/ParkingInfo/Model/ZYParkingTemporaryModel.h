//
//  ZYParkingTemporaryModel.h
//  Community
//
//  Created by ZY on 2021/10/27.
//

#import <Foundation/Foundation.h>

@class ZYParkingTemporaryDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYParkingTemporaryModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSArray<ZYParkingTemporaryDataModel *> *data;

@end


@interface ZYParkingTemporaryDataModel : NSObject <YYModel>

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

@end

NS_ASSUME_NONNULL_END
