//
//  ZYRentSigningPayModel.h
//  Community
//
//  Created by ZY on 2021/9/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYRentSigningPayModel : NSObject

// 租期
@property (nonatomic, assign) NSInteger leaseTerm;

// 支付总金额
@property (nonatomic, strong) NSNumber *totalPayment;

// 押金
@property (nonatomic, strong) NSNumber *deposit;

// 月租金
@property (nonatomic, strong) NSNumber *monthlyRent;

// 房屋租金
@property (nonatomic, strong) NSNumber *roomRent;

// 支付方式
@property (nonatomic, copy) NSString *paymentType;

// 合同开始时间
@property (nonatomic, copy) NSString *startDate;

// 合同结束时间
@property (nonatomic, copy) NSString *endDate;

@end

NS_ASSUME_NONNULL_END
