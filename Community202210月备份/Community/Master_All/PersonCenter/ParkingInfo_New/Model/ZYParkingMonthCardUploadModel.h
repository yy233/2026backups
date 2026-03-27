//
//  ZYParkingMonthCardUploadModel.h
//  Community
//
//  Created by ZY on 2022/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYParkingMonthCardUploadModel : NSObject

// ---需要提交数据---
// 社区id
@property (nonatomic, copy) NSString *communityId;

// 房屋id
@property (nonatomic, copy) NSString *houseId;

// 0地面 1地下
@property (nonatomic, assign) NSInteger groundUpAndDown;

// 车位id
@property (nonatomic, copy) NSString *carPositionId;

// 车牌
@property (nonatomic, copy) NSString *carNumber;

// 月数
@property (nonatomic, assign) NSInteger monthNumber;

// 开始时间
@property (nonatomic, copy) NSString *startTime;

// ---展示数据---
// 房屋全称
@property (nonatomic, copy) NSString *belongHouse;

// 车场分类名称
@property (nonatomic, copy) NSString *siteClassificationName;

// 停车位置名
@property (nonatomic, copy) NSString *carAddressName;

// 车位号（可以进行购买  产权车位）
@property (nonatomic, copy) NSString *carPositionNumber;

// 起始日期
@property (nonatomic, copy) NSString *startDate;

// 截止日期
@property (nonatomic, copy) NSString *endDate;

// 月租卡价格
@property (nonatomic, copy) NSString *monthCardPrice;

@end

NS_ASSUME_NONNULL_END
