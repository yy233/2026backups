//
//  PopViewHouseChooseHouseLeaseTypes.h
//  Community
//
//  Created by 余莹 on 2021/2/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

 
@protocol PopViewHouseChooseHouseLeaseTypesDelegate <NSObject>
- (void)popViewChooseHouseLeaseTypeWithModel:(IssueHouseConstModel *)model;
@end

@interface PopViewHouseChooseHouseLeaseTypes : PopViewBuniessShopChooseShopPublishTypes
@property (nonatomic,weak) id <PopViewHouseChooseHouseLeaseTypesDelegate> leaseTypesPopViewDelegate;
@end
NS_ASSUME_NONNULL_END
