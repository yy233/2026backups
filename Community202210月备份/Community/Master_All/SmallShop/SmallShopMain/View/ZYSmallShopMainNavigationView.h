//
//  ZYSmallShopMainNavigationView.h
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopMainNavigationViewDelegate <NSObject>

- (void)backButtonEvent;

@end

@interface ZYSmallShopMainNavigationView : UIView

@property (nonatomic, weak) id<ZYSmallShopMainNavigationViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
