//
//  ZYSmallShopMainTitleHeaderView.h
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopMainTitleHeaderViewDelegate <NSObject>

- (void)moreButtonEvent;

@end

@interface ZYSmallShopMainTitleHeaderView : UIView

@property (nonatomic, weak) id<ZYSmallShopMainTitleHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
