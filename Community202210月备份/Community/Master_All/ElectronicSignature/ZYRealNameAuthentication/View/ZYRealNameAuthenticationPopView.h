//
//  ZYRealNameAuthenticationPopView.h
//  Community
//
//  Created by ZY on 2022/4/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYRealNameAuthenticationPopViewDelegate <NSObject>

- (void)noRealNameButtonEvent;

- (void)realNameButtonEvent;

@end

@interface ZYRealNameAuthenticationPopView : UIView

@property (nonatomic, weak) id<ZYRealNameAuthenticationPopViewDelegate> delegate;

- (void)showRealNameAuthenticationPopView;

@end

NS_ASSUME_NONNULL_END
