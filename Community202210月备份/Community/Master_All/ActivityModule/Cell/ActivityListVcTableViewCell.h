//
//  ActivityListVcTableViewCell.h
//  Community
//
//  Created by 余莹 on 2022/6/6.
//

#import <UIKit/UIKit.h>
#import "ActivityListUseModel.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *ActivityListVcTableViewCell_I = @"ActivityListVcTableViewCell";

@interface ActivityListVcTableViewCell : BaseTableViewCell
- (void)fillDataModel:(ActivityListUseModel *)model;
@end

NS_ASSUME_NONNULL_END
