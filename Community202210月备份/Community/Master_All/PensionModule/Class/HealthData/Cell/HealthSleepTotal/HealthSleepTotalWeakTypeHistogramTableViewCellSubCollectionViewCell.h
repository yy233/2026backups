//
//  HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import <UIKit/UIKit.h>
#import "BaseHealthHeader.h"
NS_ASSUME_NONNULL_BEGIN

@interface HealthSleepTotalWeakTypeHistogramTableViewCellSubCollectionViewCell : UICollectionViewCell
- (void)fillDataWithOneDayModel:(HealthGetSleepOneDayModel *)oneDayModel;
- (void)setSubViewColorIsTouchTypeBool:(BOOL)isTouchBool;
@end

NS_ASSUME_NONNULL_END
