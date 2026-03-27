//
//  PackingPayHistoryVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/5/9.
//

#import "BaseTableViewCell.h"
#import "PackingPayHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

static NSString *PackingPayHistoryVcTableViewCell_I = @"PackingPayHistoryVcTableViewCell";

@interface PackingPayHistoryVcTableViewCell : BaseTableViewCell

- (void)fillModel:(PackingPayHistoryModel *)model; 

@end

NS_ASSUME_NONNULL_END
