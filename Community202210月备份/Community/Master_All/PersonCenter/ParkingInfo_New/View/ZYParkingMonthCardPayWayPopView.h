//
//  ZYParkingMonthCardPayWayPopView.h
//  Community
//
//  Created by ZY on 2022/5/7.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopPayWayModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYParkingMonthCardPayWayPopViewDelegate <NSObject>

- (void)okButtonEvent;

- (void)weixinViewEvent;

- (void)zhifubaoVieEvent;

@end

@interface ZYParkingMonthCardPayWayPopView : UIView

@property (nonatomic, assign) ZYSmallShop_Pay_Way_Type type;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, weak) id<ZYParkingMonthCardPayWayPopViewDelegate> delegete;

- (void)showParkingMonthCardPayWayPopView;

- (void)hiddenParkingMonthCardPayWayPopView;

@end

NS_ASSUME_NONNULL_END
