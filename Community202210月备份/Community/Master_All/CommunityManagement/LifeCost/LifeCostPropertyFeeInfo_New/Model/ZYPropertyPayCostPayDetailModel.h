//
//  ZYPropertyPayCostPayDetailModel.h
//  Community
//
//  Created by ZY on 2022/5/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYPropertyPayCostPayDetailModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 缴费单位（社区名称）
@property (nonatomic, copy) NSString *communityName;

// 缴费用户（房屋地址）
@property (nonatomic, copy) NSString *address;

// 缴费项目
@property (nonatomic, copy) NSString *feeRuleName;

// 账单开始时间
@property (nonatomic, copy) NSString *beginTime;

// 账单结束时间
@property (nonatomic, copy) NSString *overTime;

// 面积
@property (nonatomic, copy) NSString *buildArea;

// 单价
@property (nonatomic, copy) NSString *monetaryUnit;

// 账单总金额
@property (nonatomic, copy) NSString *propertyFee;

// 滞纳金
@property (nonatomic, copy) NSString *penalSum;

// 优惠
@property (nonatomic, copy) NSString *coupon;

// 合计
@property (nonatomic, copy) NSString *totalMoney;

// 0待定 1支付宝 2微信 3银行卡 4余额
@property (nonatomic, assign) NSInteger payMethod;

// 付款时间
@property (nonatomic, copy) NSString *payTime;

// 三方单号
@property (nonatomic, copy) NSString *tripartiteOrder;

// 住户数
@property (nonatomic, copy) NSString *houseMemberCount;

// 电梯单价
@property (nonatomic, copy) NSString *elevatorUnit;

// 车位号
@property (nonatomic, copy) NSString *carPosition;

// 1.物业管理费、2.车辆管理费、3.电梯使用费
@property (nonatomic, assign) NSInteger pageType;

// 楼层叠加费用
@property (nonatomic, copy) NSString *additionMoney;

@end

NS_ASSUME_NONNULL_END
