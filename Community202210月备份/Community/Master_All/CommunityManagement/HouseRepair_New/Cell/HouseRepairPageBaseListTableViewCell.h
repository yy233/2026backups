//
//  HouseRepairPageBaseListTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/3/4.
//

#import <UIKit/UIKit.h>

#import "HouseRePairHeader.h"
NS_ASSUME_NONNULL_BEGIN

static NSString *HouseRepairPageBaseListTableViewCell_I = @"HouseRepairPageBaseListTableViewCell";

@interface HouseRepairPageBaseListTableViewCell : BaseTableViewCell
- (void)fillDataWithModel:(MyRepairPageListUseModel *)model;
@end

NS_ASSUME_NONNULL_END
