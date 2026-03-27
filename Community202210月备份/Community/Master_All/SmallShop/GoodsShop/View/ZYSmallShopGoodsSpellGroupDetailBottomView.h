//
//  ZYSmallShopGoodsSpellGroupDetailBottomView.h
//  Community
//
//  Created by ZY on 2022/3/4.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopGoodsSpellGroupDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopGoodsSpellGroupDetailBottomViewDelegate <NSObject>

- (void)chatButtonEvent;

- (void)spellGroupButtonEvent;

@end

@interface ZYSmallShopGoodsSpellGroupDetailBottomView : UIView

@property (nonatomic, strong) ZYSmallShopGoodsSpellGroupDetailModel *model;

@property (nonatomic, weak) id<ZYSmallShopGoodsSpellGroupDetailBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
