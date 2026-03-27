//
//  WebSocketGroupChatVc.h
//  Community
//
//  Created by 余莹 on 2021/4/25.
//

#import <UIKit/UIKit.h>
#import "WebSocketChatWithFriendVc.h"
NS_ASSUME_NONNULL_BEGIN

@interface WebSocketGroupChatVc : WebSocketChatWithFriendVc
@property (nonatomic,strong) NSString *groupId;
@end

NS_ASSUME_NONNULL_END
