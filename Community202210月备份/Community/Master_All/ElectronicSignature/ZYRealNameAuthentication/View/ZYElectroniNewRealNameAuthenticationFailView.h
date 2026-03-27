//
//  ZYElectroniNewRealNameAuthenticationFailView.h
//  Community
//
//  Created by ZY on 2022/4/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYElectroniNewRealNameAuthenticationFailViewDelegate <NSObject>

- (void)againButtonEvent;

@end

@interface ZYElectroniNewRealNameAuthenticationFailView : UIView

@property (nonatomic, weak) id<ZYElectroniNewRealNameAuthenticationFailViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
