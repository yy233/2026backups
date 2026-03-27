//
//  MoneyWalletYuEMingXiListVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import <UIKit/UIKit.h>
#import "YuEMingXiHeaderView.h"
#import "ZYBalanceDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MoneyWalletYuEMingXiListVcTableViewCell : BaseTableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *timeL;
@property (nonatomic,strong) UILabel *mongyL;
@property (nonatomic, strong) ZYBalanceDetailDataRecordsModel *model;
//- (void)fillCellData:(NSDictionary *)dic withType:(YuEMingXi_Type)type;
@end

NS_ASSUME_NONNULL_END
