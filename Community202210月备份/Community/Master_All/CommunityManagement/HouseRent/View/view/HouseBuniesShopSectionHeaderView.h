//
//  HouseBuniesShopSectionHeaderView.h
//  Community
//
//  Created by 余莹 on 2021/1/4.
//

#import <UIKit/UIKit.h>
#import "HouseRentSectionHeaderView.h"
NS_ASSUME_NONNULL_BEGIN
@protocol HouseBuniesShopSectionHeaderViewDeleagete <NSObject>
- (void)touchUpBuniesShopCityQuBtn;
- (void)touchUpBuniesShopMoneyBtn;
- (void)touchUpBuniesShopAreaSpaceBtn;
- (void)touchUpBuniesShopMoreBtn;
@end
@interface HouseBuniesShopSectionHeaderView : HouseRentSectionHeaderView
@property (nonatomic,strong) UIButton *areaSpaceBtn;
@property (nonatomic,weak) id<HouseBuniesShopSectionHeaderViewDeleagete> delegateBuniesShop;
 
@end

NS_ASSUME_NONNULL_END
