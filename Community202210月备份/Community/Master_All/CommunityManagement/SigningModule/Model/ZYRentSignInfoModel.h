//
//  ZYRentSignInfoModel.h
//  Community
//
//  Created by ZY on 2021/9/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYRentSignInfoModel : NSObject

// 签约id
@property (nonatomic, copy) NSString* contractId;

// 房屋id
@property (nonatomic, copy) NSString *assetId;

// 资产类型 1:商铺 2:房屋
@property (nonatomic, assign) NSInteger assetType;

// 是否需要支付
@property (nonatomic, assign) BOOL isOnlinePayment;

// 签约截止日期
@property (nonatomic, copy) NSString *signingDeadline;

// 租客uid
@property (nonatomic, copy) NSString *tenantUid;

// 租客姓名
@property (nonatomic, copy) NSString *tenantName;

@end

NS_ASSUME_NONNULL_END
