//
//  ChatGroupMessageModel.h
//  Community
//
//  Created by 余莹 on 2021/4/27.
//

#import <Foundation/Foundation.h>
#import "ChatFriendMessageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatGroupMessageModel : ChatFriendMessageModel
@property (nonatomic,strong) NSString *to_group;
//系统消息__add
@property (nonatomic,strong) NSDictionary *group_member_add;
 
@end

NS_ASSUME_NONNULL_END
