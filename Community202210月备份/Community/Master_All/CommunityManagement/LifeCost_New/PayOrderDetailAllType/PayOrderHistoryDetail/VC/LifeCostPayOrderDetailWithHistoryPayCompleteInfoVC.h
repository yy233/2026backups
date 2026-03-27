//
//  PayOrderDetailWIthHistoryPayCompleteInfo.h
//  Community
//
//  Created by 余莹 on 2022/1/7.
// 历史 已支付 详情

#import <UIKit/UIKit.h>
#import "LifeCostPayHistoryOrderSubOrderEntityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPayOrderDetailWithHistoryPayCompleteInfoVC : BaseViewController
@property (nonatomic,strong) LifeCostPayHistoryOrderSubOrderEntityModel *oneOrderModel;
@end

NS_ASSUME_NONNULL_END
