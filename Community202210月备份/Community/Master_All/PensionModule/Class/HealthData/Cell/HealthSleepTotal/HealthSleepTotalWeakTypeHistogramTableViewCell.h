//
//  HealthSleepTotalWeakTypeHistogramTableViewCell.h
//  Community
//
//  Created by 余莹 on 2021/11/18.
//

#import <UIKit/UIKit.h>
#import "BaseHealthHeader.h"

NS_ASSUME_NONNULL_BEGIN
 

@protocol HealthSleepTotalWeakTypeHistogramTableViewCellDelegate <NSObject>

- (void)timeChangeWithLastWeak;
- (void)timeChangeWithNextWeak;
@end

@interface HealthSleepTotalWeakTypeHistogramTableViewCell : HealthBaseTotalDataContTouchTableViewCell
- (void)fillDataOneWeak:(HealthGetSleepOneWeakModel *)oneWeakModel;
@property (nonatomic,weak) id <HealthSleepTotalWeakTypeHistogramTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
