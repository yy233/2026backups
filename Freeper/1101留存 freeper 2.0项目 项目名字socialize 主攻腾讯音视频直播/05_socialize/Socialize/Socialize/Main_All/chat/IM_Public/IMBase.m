//
//  IMBase.m
//  Socialize
//
//  Created by 余莹 on 2023/5/11.
//

#import "IMBase.h"

@implementation IMBase

+ (void)imLoginInfoUserID:(NSString *)userid
                  userSig:(NSString *)sig
               withBlockk:(void(^)(BOOL loginStue))loginStuesBlock{
    WEAKSELF
    [TUILogin login:SDKAppID userID:userid userSig:sig succ:^{
        NSLog(@"登录成功");
        loginStuesBlock(YES);
        [weakSelf getUserInfoData];
    } fail:^(int code, NSString *msg) {
        NSLog(@"登录失败 %d  %@",code,msg);
        loginStuesBlock(NO);
    }];
}

+ (void)getUserInfoData{
    NSString *imNick = [TUILogin getNickName];
    NSString *imUserid = [TUILogin getUserID];

    DLog(@"userid %@ 昵称 --  %@",imUserid,imNick);
}


+ (void)imLogoutAction{
    [TUILogin logout:^{
        NSLog(@"退出登录 成功");
    } fail:^(int code, NSString *msg) {
        NSLog(@"退出登录 成功");
    }];
}
@end
