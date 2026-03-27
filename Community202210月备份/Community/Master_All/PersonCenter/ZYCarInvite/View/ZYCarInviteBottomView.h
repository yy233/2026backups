//
//  ZYCarInviteBottomView.h
//  Community
//
//  Created by ZY on 2022/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZYCarInviteBottomViewDelegete <NSObject>

- (void)inviteButtonEvent;

@end

@interface ZYCarInviteBottomView : UIView

@property (nonatomic, weak) id<ZYCarInviteBottomViewDelegete> delegate;

@end

NS_ASSUME_NONNULL_END
