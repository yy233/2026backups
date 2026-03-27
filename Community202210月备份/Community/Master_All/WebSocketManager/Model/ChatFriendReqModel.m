//
//  ChatFriendReqModel.m
//  Community
//
//  Created by 余莹 on 2021/4/27.
// 好友请求用的model

#import "ChatFriendReqModel.h"

@implementation ChatFriendReqModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"remark":[ChatFriendReqModelSubRemarkModel class]}; 
}
@end
