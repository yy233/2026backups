//
//  BillingDetailVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/6/8.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *BillingDetailVcTableViewCell_I = @"BillingDetailVcTableViewCell";

@interface BillingDetailVcTableViewCell : BaseTableViewCell

@property (nonatomic,strong) UILabel *titleL;

@property (nonatomic,strong) UILabel *detailL; 

@end

NS_ASSUME_NONNULL_END
