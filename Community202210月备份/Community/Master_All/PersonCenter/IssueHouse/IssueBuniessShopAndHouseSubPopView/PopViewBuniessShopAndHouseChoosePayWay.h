//
//  PopViewBuniessShopChoosePayWay.h
//  Community
//
//  Created by 余莹 on 2021/1/21.
//  押付方式

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PopViewBuniessShopAndHouseChoosePayWayDelegate <NSObject>
- (void)popViewChoosePayWayModel:(PopViewBuniessShopAndHouseChoosePayWayModel *)model;
@end

@interface PopViewBuniessShopAndHouseChoosePayWay : BasePopView
@property (nonatomic,weak) id <PopViewBuniessShopAndHouseChoosePayWayDelegate> payWayDelegate;
@end

NS_ASSUME_NONNULL_END
