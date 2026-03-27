//
//  ZYSmallShopGoodsDetailBottomView.h
//  Community
//
//  Created by ZY on 2022/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopGoodsDetailBottomViewDelegate <NSObject>

- (void)chatButtonEvent;

- (void)buyButtonEvent;

@optional
- (void)shoppingCartButtonEvent;

@end

@interface ZYSmallShopGoodsDetailBottomView : UIView

@property (weak, nonatomic) IBOutlet UIButton *shoppingCartButton;

@property (nonatomic, weak) id<ZYSmallShopGoodsDetailBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
