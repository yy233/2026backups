//
//  ZYSmallShopMainTopHeaderView.h
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopMainTopHeaderViewDelegate <NSObject>

- (void)messageButtonEvent;

- (void)personButtonEvent;

@end

@interface ZYSmallShopMainTopHeaderView : UIView

@property (nonatomic, weak) id<ZYSmallShopMainTopHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
