//
//  BillingListVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/6/8.
//

#import "BaseTableViewCell.h"
#import "BillingListSubOneInfoDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *BillingListVcTableViewCell_I = @"BillingListVcTableViewCell";


@interface BillingListVcTableViewCell : BaseTableViewCell

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *typeL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UILabel *barkmoneyL;

- (void)fillModel:(BillingListSubOneInfoDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
