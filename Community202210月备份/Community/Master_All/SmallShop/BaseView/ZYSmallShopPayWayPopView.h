//
//  ZYSmallShopPayWayPopView.h
//  Community
//
//  Created by ZY on 2022/3/18.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopPayWayModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopPayWayPopViewDelegate <NSObject>

- (void)okButtonEvent;

- (void)weixinViewEvent;

- (void)zhifubaoVieEvent;

@end

@interface ZYSmallShopPayWayPopView : UIView

@property (nonatomic, assign) ZYSmallShop_Pay_Way_Type type;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (nonatomic, weak) id<ZYSmallShopPayWayPopViewDelegate> delegete;

- (void)showSmallShopPayWayPopView;

- (void)hiddenSmallShopPayWayPopView;

@end

NS_ASSUME_NONNULL_END
