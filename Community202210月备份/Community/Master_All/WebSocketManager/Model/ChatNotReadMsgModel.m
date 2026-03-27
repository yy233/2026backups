//
//  ChatNotReadMsgModel.m
//  Community
//
//  Created by 余莹 on 2021/4/28.
//

#import "ChatNotReadMsgModel.h"

@implementation ChatNotReadMsgModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"contact" : [ChatFriendModel class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}
@end
