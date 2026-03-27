//
//  LifeCostMyCostTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/8.
//

#import <UIKit/UIKit.h>
#import "LifeCostMainVcTopGroupSubAccountEntityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LifeCostMyCostTableViewCell : UITableViewCell

- (void)fillDataWithModel:(LifeCostMainVcTopGroupSubAccountEntityModel *)model;
@end
NS_ASSUME_NONNULL_END
