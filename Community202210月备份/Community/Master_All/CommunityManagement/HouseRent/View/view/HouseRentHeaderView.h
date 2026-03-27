//
//  HouseRentViewHeaderView.h
//  Community
//
//  Created by 余莹 on 2020/12/29.
//。header 选择

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HouseRentHeaderViewChooseTypeDelegate <NSObject>
- (void)houseRentHeaderViewChooseTypeSubBtnTouchChooseType:(MainCellRecommendedServiceHourse_Rent_Type)type;
@end
@interface HouseRentHeaderView : UIView
@property (nonatomic,weak) id<HouseRentHeaderViewChooseTypeDelegate>delegate;
- (void)setNowBtnSelectedWithType:(MainCellRecommendedServiceHourse_Rent_Type)type;
- (void)changeTextColorWithBlack;
@end

NS_ASSUME_NONNULL_END
