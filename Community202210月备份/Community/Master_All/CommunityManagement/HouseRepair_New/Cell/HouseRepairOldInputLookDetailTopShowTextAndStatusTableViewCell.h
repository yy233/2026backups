//
//  HouseRepairOldInputLookDetailTopShowTextAndStatusTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/4.
//

#import <UIKit/UIKit.h>
#import "MyRepairPageListUseModel.h"
NS_ASSUME_NONNULL_BEGIN

static NSString *HouseRepairOldInputLookDetailTopShowTextAndStatusTableViewCell_I = @"HouseRepairOldInputLookDetailTopShowTextAndStatusTableViewCell";
@interface HouseRepairOldInputLookDetailTopShowTextAndStatusTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *detailL;
@property (nonatomic,strong) UIButton *statusBtn;

- (void)fillDataIsShowStatusBool:(BOOL)isShowStatusInfo withListModel:(MyRepairPageListUseModel *)listModel;
@end

NS_ASSUME_NONNULL_END
