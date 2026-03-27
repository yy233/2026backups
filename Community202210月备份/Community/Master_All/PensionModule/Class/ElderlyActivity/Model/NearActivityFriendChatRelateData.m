//
//  NearActivityFriendChatRelateData.m
//  Community
//
//  Created by 余莹 on 2021/12/13.
//

#import "NearActivityFriendChatRelateData.h"
#import "ChatManagerData.h"

@implementation NearActivityFriendChatRelateData

+ (void)nearActivityAddFriendWithFriendId:(NSString *)fid{
     [ChatManagerData addFriendWithFriendImIdStr:fid withVerifyMessage:@"" withFriendRemark:@""];

}

@end
