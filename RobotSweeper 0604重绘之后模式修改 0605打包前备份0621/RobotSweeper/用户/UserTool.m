//
//  User.m
//  RobotSweeper
//
//  Created by yy on 2018/3/2.
//  Copyright © 2018年 yy. All rights reserved.
//

#import "UserTool.h"

@implementation UserTool
static UserTool *_instance;
//第2步: 分配内存空间时都会调用这个方法. 保证分配内存alloc时都相同.
+(id)allocWithZone:(struct _NSZone *)zone  {
    //调用dispatch_once保证在多线程中也只被实例化一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
//第3步: 保证init初始化时都相同
+(instancetype)sharedUserTool  {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[UserTool alloc] init];
    });
    return _instance;
}

//第4步: 保证copy时都相同
-(id)copyWithZone:(NSZone *)zone{
    
    
    return _instance;
}

//mrc 要加的
#if (!__has_feature(objc_arc))
//可以看出实现部分与ARC一致，下面是MRC中需要覆盖的方法
#pragma mark - MRC中需要覆盖的方法
//不需要计数器+1
- (id)retain {
    
    return self;
}

//不需要. 堆区的对象才需要
- (id)autorelease {
    return self;
}
//不需要
- (oneway void)release {
}

//不需要计数器个数. 直接返回最大无符号整数
- (NSUInteger)retainCount {
    return UINT_MAX;  //参照常量区字符串的retainCount
}

#endif






- (void)addFriendToFriendArrWithFriendName:(NSString *)friendName
                              friendStatus:(NSString *)status{
   
    if (!_friendsArr) {
        _friendsArr = [NSMutableArray array];
    }
    
    BOOL haveItem = NO;
    for (int i = 0; i < _friendsArr.count; i++) {
        NSDictionary *dicFriend = _friendsArr[i];
        NSString *nameStr = [dicFriend objectForKey:kFriendNameKey];
        if ([nameStr isEqualToString:friendName]) {
            haveItem = YES;
        }
    }
    if (!haveItem) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:friendName,kFriendNameKey,status,kFriendStatusObj, nil];
        [_friendsArr addObject:dic];
    }
    //去重
    NSMutableArray *deletDuplicateFinishArr = [NSMutableArray array];
    for (NSDictionary *item in deletDuplicateFinishArr) {
        if (![deletDuplicateFinishArr containsObject:item]) {
            [deletDuplicateFinishArr addObject:item];
        }
        _friendsArr = [NSMutableArray arrayWithArray:deletDuplicateFinishArr];
        
    }
//    NSLog(@"add_friendsArr end=%@",_friendsArr);
    
  
}

- (void)changeFriendsStatusWithFriendName:(NSString *)friendName
                             friendStatus:(NSString *)status{

    
    for (int i = 0; i < _friendsArr.count; i++) {
        
        NSDictionary *dicFriend = _friendsArr[i];
        NSString *nameStr = [dicFriend objectForKey:kFriendNameKey];
        if ([nameStr isEqualToString:friendName]) {
            [_friendsArr removeObjectAtIndex:i];
            
        }
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:friendName,kFriendNameKey,status,kFriendStatusObj, nil];
    [_friendsArr addObject:dic];
     NSLog(@"change_friendsArr=%@",_friendsArr);
    
}


@end

