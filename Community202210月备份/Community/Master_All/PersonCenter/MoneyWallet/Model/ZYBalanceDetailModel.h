//
//  ZYBalanceDetailModel.h
//  Community
//
//  Created by ZY on 2021/10/15.
//

#import <Foundation/Foundation.h>

@class ZYBalanceDetailDataModel, ZYBalanceDetailDataRecordsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYBalanceDetailModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYBalanceDetailDataModel *data;

@end


@interface ZYBalanceDetailDataModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) NSInteger current;

@property (nonatomic, strong) NSArray<ZYBalanceDetailDataRecordsModel *> *records;

@end


@interface ZYBalanceDetailDataRecordsModel : NSObject <YYModel>

// 用户ID
@property (nonatomic, copy) NSString *uid;

// 商品id
@property (nonatomic, copy) NSString *goodsId;

// 流水号
@property (nonatomic, copy) NSString *idStr;

// 交易来源1.充值提现2.商城购物3.水电缴费4.物业管理5.房屋租金6.红包7.红包退回
@property (nonatomic, assign) NSInteger tradeFrom;

// 交易来源展示用字符串1.充值提现2.商城购物3.水电缴费4.物业管理5.房屋租金6.红包7.红包退回
@property (nonatomic, copy) NSString *tradeFromStr;

// 交易类型1.收入2.支出
@property (nonatomic, assign) NSInteger tradeType;

// 交易类型展示用字符串1.支出 2.收入
@property (nonatomic, copy) NSString *tradeTypeStr;

// 交易金额
@property (nonatomic, strong) NSNumber *tradeAmount;

// 交易金额字符串
@property (nonatomic, copy) NSString *tradeAmountStr;

// 交易后余额
@property (nonatomic, strong) NSNumber *balance;

// 交易后余额字符串
@property (nonatomic, copy) NSString *balanceStr;

// 创建时间
@property (nonatomic, copy) NSString *createTime;

// 备注
@property (nonatomic, copy) NSString *comment;

@end

NS_ASSUME_NONNULL_END
