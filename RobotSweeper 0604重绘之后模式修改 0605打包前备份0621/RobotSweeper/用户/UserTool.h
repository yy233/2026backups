//
//  User.h
//  RobotSweeper
//
//  Created by yy on 2018/3/2.
//  Copyright © 2018年 yy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserTool : NSObject
@property (nonatomic,strong) NSString * userName;

@property (nonatomic,strong) NSMutableArray *friendsArr;//存的是好友在线状态

@property (nonatomic,strong) NSMutableArray *listOfRobotsArr;//存的是列表拿到的数据


+(instancetype)sharedUserTool;

//存在则不添加  不存在则unavailable是固定的元素
- (void)addFriendToFriendArrWithFriendName:(NSString *)friendName
                              friendStatus:(NSString *)status;
//存在则修改unavailable与available  不存在则添加
- (void)changeFriendsStatusWithFriendName:(NSString *)friendName
                             friendStatus:(NSString *)status;

@end
