//
//  UserModel.h
//  RobotSweeper
//
//  Created by Joey on 2018/1/27.
//  Copyright © 2018年 美超刘. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
 
@property (nonatomic ,strong) NSString *userName;//这个才有值 在登录时，获取到的值，用于登录xmpp账号，现在正式环境无_,测试环境有_。
@property (nonatomic ,strong) NSString *passWord;//这个原为手机号后6位 为登录时所得 用于登录xmpp账号
@property (nonatomic ,strong) NSString *userHostName;
@property (nonatomic ,strong) NSString *userHostPost;

@property (nonatomic ,strong) NSString *userJid;//这个是否现添加值，付之为登录时所得？暂待定
@property (nonatomic ,strong) NSString *nowRobotJid;
@property (nonatomic ,strong) NSString *nowRobotJidMonitor;
@property (nonatomic ,strong) NSMutableArray *friendArr;//存的是好友订阅关系
@property (nonatomic ,strong) NSMutableArray *userWiFiArr;

@property (nonatomic ,strong) NSString *userNameNoSuffix;//新增无后坠的username 用于测试服时userName不是手机号的情况，在登录时付值，在请求服务器之类中使用。 ==[ShareUser sharedUserInfo].accPasswordNum
@end
