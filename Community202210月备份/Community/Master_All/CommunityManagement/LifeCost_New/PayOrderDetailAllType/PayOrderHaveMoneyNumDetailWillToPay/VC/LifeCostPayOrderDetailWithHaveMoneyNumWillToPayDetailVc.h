//
//  LifeCostPayOrderDetailWithHaveMoneyNumWillToPayDetailVc.h
//  Community
//
//  Created by 余莹 on 2022/1/7.
// 账单出来 有带金额 可直接支付 的 详情页

#import <UIKit/UIKit.h>

#import "LifeCostWillPayBaseDetailVC.h"
#import "LifeWillToPayOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPayOrderDetailWithHaveMoneyNumWillToPayDetailVc : LifeCostWillPayBaseDetailVC
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,strong) LifeWillToPayOrderDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
