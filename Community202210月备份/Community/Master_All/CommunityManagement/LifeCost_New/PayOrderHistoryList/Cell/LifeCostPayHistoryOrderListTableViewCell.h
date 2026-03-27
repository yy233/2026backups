//
//  LifeCostPayHistoryOrderListTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import <UIKit/UIKit.h>
#import "LifeCostPayHistoryOrderSubOrderEntityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPayHistoryOrderListTableViewCell : BaseTableViewCell
- (void)fillDataWithModel:(LifeCostPayHistoryOrderSubOrderEntityModel *)model;
@end

@interface LifeCostPayHistoryOrderListOnlyShowMonthInfTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *monthTitleL;
@end

NS_ASSUME_NONNULL_END
