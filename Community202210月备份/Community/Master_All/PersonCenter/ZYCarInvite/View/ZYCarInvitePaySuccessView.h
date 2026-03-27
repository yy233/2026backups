//
//  ZYCarInvitePaySuccessView.h
//  Community
//
//  Created by ZY on 2022/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCarInvitePaySuccessViewDelegate <NSObject>

- (void)okButtonEvent;

@end

@interface ZYCarInvitePaySuccessView : UIView

@property (nonatomic, weak) id<ZYCarInvitePaySuccessViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
