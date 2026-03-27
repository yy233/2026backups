//
//  ZYBlockchainOrderEvidenceModel.h
//  Community
//
//  Created by ZY on 2021/10/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYBlockchainOrderEvidenceModel : NSObject <YYModel>

// 交易名称
@property (nonatomic, copy) NSString *transactionName;

// 支付方
@property (nonatomic, copy) NSString *payElectronicIdentity;

// 支付方式
@property (nonatomic, copy) NSString *payType;

// 交易币种
@property (nonatomic, copy) NSString *currency;

// 交易金额
@property (nonatomic, copy) NSString *totalAmount;

// 收款方
@property (nonatomic, copy) NSString *payeeElectronicIdentity;

// 支付时间戳
@property (nonatomic, copy) NSString *timestamp;

// 订单编号
@property (nonatomic, copy) NSString *orderNum;

// 区块链哈希
@property (nonatomic, copy) NSString *hashStr;

// 交易详情
@property (nonatomic, copy) NSString *detailedList;

// 备注
@property (nonatomic, copy) NSString *remarks;

@end

NS_ASSUME_NONNULL_END
