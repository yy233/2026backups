//
//  HealthSleepTotalWeakTypeNomalTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import <UIKit/UIKit.h>
#import "HealthBaseTotalDataContTouchTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface HealthSleepTotalWeakTypeNomalTableViewCell : HealthBaseTotalDataContTouchTableViewCell
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *detailL;

@end
@interface HealthSleepTotalOnlyTextTableViewCell : UITableViewCell
@property (nonatomic,strong) UITextView *contentTextView;
@end

NS_ASSUME_NONNULL_END
