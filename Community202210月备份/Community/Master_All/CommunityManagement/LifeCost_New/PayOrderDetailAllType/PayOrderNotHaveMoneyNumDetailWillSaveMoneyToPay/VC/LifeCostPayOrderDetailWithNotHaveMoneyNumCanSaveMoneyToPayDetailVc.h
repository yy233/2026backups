//
//  LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc.h
//  Community
//
//  Created by 余莹 on 2022/1/7.
// 没有账单出来 未带金额 可直接支付 的 预存相关 详情页


#import <UIKit/UIKit.h>

#import "LifeCostWillPayBaseDetailVC.h"
#import "LifeCostMainVcTopGroupSubAccountEntityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc : LifeCostWillPayBaseDetailVC
@property (nonatomic,strong) LifeCostMainVcTopGroupSubAccountEntityModel *mianVcGroupListSubOrderModel;//主页点击过来的数据
//新增缴费走公司列表点击过来的数据；
@end

NS_ASSUME_NONNULL_END
