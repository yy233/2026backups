//
//  HouseRepairListVCHeaderView.h
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HouseRepairListVCHeaderViewDelegate <NSObject>
- (void)chooseHouseRepairListType:(HouseRepair_List_DealType)type;
@end
@interface HouseRepairListVCHeaderView : UIView
@property (nonatomic,weak) id <HouseRepairListVCHeaderViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
