//
//  ZYSmallShopBaseRoundBottomViewDelegate.h
//  EShops
//
//  Created by ZY on 2022/2/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopBaseRoundBottomViewDelegate <NSObject>

- (void)okButtonEvent;

@end

@interface ZYSmallShopBaseRoundBottomView : UIView

@property (nonatomic, copy) NSString *btnText;

@property (nonatomic, weak) id<ZYSmallShopBaseRoundBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
