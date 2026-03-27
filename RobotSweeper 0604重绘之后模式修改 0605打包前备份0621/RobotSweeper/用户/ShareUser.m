//
//  ShareUser.m
//  RobotSweeper
//
//  Created by Joey on 2018/1/27.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import "ShareUser.h"


@implementation ShareUser
MJCodingImplementation
+ (ShareUser *)sharedUserInfo {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
    
    
}
@end
