//
//  ZYParkingMonthCardModel.h
//  Community
//
//  Created by ZY on 2022/5/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYParkingMonthCardModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 社区id
@property (nonatomic, copy) NSString *communityId;

// 用户id
@property (nonatomic, copy) NSString *userId;

// 车位id
@property (nonatomic, copy) NSString *carPositionId;

// 车牌号
@property (nonatomic, copy) NSString *carNumber;

// 订单号
@property (nonatomic, copy) NSString *systemNumber;

// 第三方订单号
@property (nonatomic, copy) NSString *orderNumber;

// 总金额
@property (nonatomic, copy) NSString *sumMoney;

// 支付金额
@property (nonatomic, copy) NSString *payMoney;

// 优惠金额
@property (nonatomic, copy) NSString *preferentialMoney;

// 1:包月车位订单 2:购买车位订单
@property (nonatomic, assign) NSInteger carOrderType;

// 支付状态(0：未支付  1：已支付)
@property (nonatomic, assign) NSInteger payStatus;

// 支付方式 1微信 2支付宝 3现金
@property (nonatomic, assign) NSInteger payType;

// 购买车位抬头
@property (nonatomic, copy) NSString *billHead;

// 支付时间
@property (nonatomic, copy) NSString *payTime;

// 停车场名称
@property (nonatomic, copy) NSString *siteClassificationName;

// 产权车位号
@property (nonatomic, copy) NSString *carPositionNumber;

// 车位编号
@property (nonatomic, copy) NSString *carPositionSerialNumber;

// 0地面 1地下 (0我的车辆，1我的车位)
@property (nonatomic, assign) NSInteger groundUpAndDown;

// 地面地下名称
@property (nonatomic, copy) NSString *groundUpAndDownName;

// 面价
@property (nonatomic, copy) NSString *area;

// 楼栋全名
@property (nonatomic, copy) NSString *belongHouse;

// 业主身份 1业主 2租客 3其他
@property (nonatomic, assign) NSInteger userIdentity;

// 包月模板收费标准名称
@property (nonatomic, copy) NSString *chargeName;

// 开始时间
@property (nonatomic, copy) NSString *startTime;

// 结束时间
@property (nonatomic, copy) NSString *stopTime;

// 备注
@property (nonatomic, copy) NSString *notes;

@end

NS_ASSUME_NONNULL_END
