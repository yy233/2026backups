//
//  BaseOneBoxTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import <UIKit/UIKit.h>
#import "SmallShopOrderDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

static NSString *BaseOneBoxTableViewCell_I = @"BaseOneBoxTableViewCell";

@interface BaseOneBoxTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UILabel *oldMoneyL;
@property (nonatomic,strong) UILabel *boxMonthTitleL;
- (void)fillOrderDetailModel:(SmallShopOrderDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
