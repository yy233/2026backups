//
//  ZYContactPeopleFunctionView.h
//  Community
//
//  Created by ZY on 2021/4/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYContactPeopleFunctionView : UIView

// 加好友
@property (weak, nonatomic) IBOutlet UIView *addFriendsView;

// 群聊
@property (weak, nonatomic) IBOutlet UIView *groupChatView;

// 扫一扫
@property (weak, nonatomic) IBOutlet UIView *scanView;

// 收付款
@property (weak, nonatomic) IBOutlet UIView *receivingView;

@end

NS_ASSUME_NONNULL_END
