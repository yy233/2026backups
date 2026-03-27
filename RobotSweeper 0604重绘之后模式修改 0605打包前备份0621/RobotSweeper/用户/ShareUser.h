//
//  ShareUser.h
//  RobotSweeper
//
//  Created by Joey on 2018/1/27.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface ShareUser : NSObject
 
@property (nonatomic, strong) UserModel *userMode;//登录时获取的数据 存之
@property (nonatomic, strong) NSString * token;//用户token

@property (nonatomic, strong) NSString *accountNum;//用户登录名 无后缀
@property (nonatomic, strong) NSString *accPasswordNum;//用户登录密码

+ (ShareUser *)sharedUserInfo;
@end
