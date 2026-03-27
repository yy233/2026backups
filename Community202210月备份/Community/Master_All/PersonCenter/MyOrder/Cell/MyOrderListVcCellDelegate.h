//
//  MyOrderListVcCellDelegate.h
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import <Foundation/Foundation.h>
#import "MyOrderModel.h"
NS_ASSUME_NONNULL_BEGIN


@protocol MyOrderListVcCellDelegate <NSObject>
//- (void)touchPayBtn;//立即支付
//- (void)touchEvaluationBtn;//评价
//- (void)touchOnceAgainBtn;//再来一单
- (void)touchPayBtnWithOrderModel:(MyOrderModel *)model;//立即支付
- (void)touchEvaluationBtnWithOrderModel:(MyOrderModel *)model;//评价
- (void)touchOnceAgainBtnWithOrderModel:(MyOrderModel *)model;//再来一单
- (void)touchRefundScheduleBtnWithOrderModel:(MyOrderModel *)model;//退款进度
@end

NS_ASSUME_NONNULL_END
