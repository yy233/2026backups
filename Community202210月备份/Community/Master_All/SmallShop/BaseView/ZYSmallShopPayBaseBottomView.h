//
//  ZYSmallShopPayBaseBottomView.h
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopPayBaseViewDelegate <NSObject>

- (void)payButtonEvent;

@end

@interface ZYSmallShopPayBaseBottomView : UIView

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *payButton;

@property (nonatomic, weak) id<ZYSmallShopPayBaseViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
