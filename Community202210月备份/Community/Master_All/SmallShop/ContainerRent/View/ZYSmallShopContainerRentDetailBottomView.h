//
//  ZYSmallShopContainerRentDetailBottomView.h
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopContainerRentDetailBottomViewDelegate <NSObject>

- (void)chatButtonEvent;

- (void)rentButtonEvent;

@end

@interface ZYSmallShopContainerRentDetailBottomView : UIView

@property (nonatomic, weak) id<ZYSmallShopContainerRentDetailBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
