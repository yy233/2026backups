//
//  ZYPropertyPayCostPayVc.h
//  Community
//
//  Created by ZY on 2022/5/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYPropertyPayCostPayVc : ZYBaseViewController

// 1.物业管理费、2.车辆管理费、3.电梯使用费
@property (nonatomic, assign) NSInteger pageType;

// 物业账单id
@property (nonatomic, copy) NSString *ID;

// 支付状态 0未缴费 1已缴费
@property (nonatomic, assign) NSInteger orderStatus;

@end

NS_ASSUME_NONNULL_END
