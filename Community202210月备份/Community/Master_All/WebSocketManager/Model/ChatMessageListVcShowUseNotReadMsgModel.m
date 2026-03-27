//
//  ChatMessageListVcShowUseNotReadMsgModel.m
//  Community
//
//  Created by 余莹 on 2022/3/26.
//

#import "ChatMessageListVcShowUseNotReadMsgModel.h"

@implementation ChatMessageListVcShowUseNotReadMsgModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"contact" : [ChatFriendModel class]};
}
@end
