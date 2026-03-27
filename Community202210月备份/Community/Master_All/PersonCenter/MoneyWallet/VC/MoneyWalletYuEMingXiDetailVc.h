//
//  MoneyWalletYuEMingXiDetailVc.h
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import <UIKit/UIKit.h>
#import "YuEMingXiHeaderView.h"
#import "ZYBalanceDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoneyWalletYuEMingXiDetailVc : BaseTableViewController_DW //NotNoticeWithUI
@property (nonatomic,assign) YuEMingXi_Type type;

@property (nonatomic, strong) ZYBalanceDetailDataRecordsModel *detailModel;

@end

NS_ASSUME_NONNULL_END
