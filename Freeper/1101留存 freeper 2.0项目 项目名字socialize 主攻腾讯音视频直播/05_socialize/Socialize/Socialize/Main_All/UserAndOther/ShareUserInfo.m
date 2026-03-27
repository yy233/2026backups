//
//  ShareUserInfo.m
//  Socialize
//
//  Created by 余莹 on 2023/5/25.
//

#import "ShareUserInfo.h"

#define NSUserDefaults_Name_UserInfo @"Y_ThisUserInfo"

#define NSUserDefaults_Name_UserAddress @"Y_UserAddress"
@implementation ShareUserInfo

singleton_implementation(share)



//UserModel信息存储
- (void)saveDefaultsLoginUserInfo:(UserModel *)model{
    UserModel *userInfo = model;
    [ShareUserInfo share].userInfo = userInfo;
//    NSData *userInfoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    NSError *err = nil;
    NSData *userInfoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo requiringSecureCoding:NO error:&err];
    if(err == nil){
        [[NSUserDefaults standardUserDefaults] setValue:userInfoData forKey:NSUserDefaults_Name_UserInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self addressInfoSave];
        NSLog(@"userModel信息存储 成功");
    }else{
        NSLog(@"userModel信息存储 失败");
    }

}
- (void)getDefaultsLoginUserInfo{
    NSData *userInfoData = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaults_Name_UserInfo];
    NSError *err = nil;
    
    UserModel *userInfoModel = [NSKeyedUnarchiver unarchivedObjectOfClass:[UserModel class] fromData:userInfoData error:&err];
    if(userInfoData == nil){
        [ShareUserInfo share].userInfo = [[UserModel alloc]init];//初始无数据时
        NSLog(@"userModel信息 无数据 初始化");
    }else {
        if(err == nil){
            [ShareUserInfo share].userInfo = userInfoModel;
            [self addressInfoSave];
            NSLog(@"userModel信息 获取 成功");
        }else{
            NSLog(@"userModel信息 获取 失败");//解档的大坑 如果其中存在NSArray等集合，那么解档同样会失败。又或者是因为缺失协议supportsSecureCoding yes
        }
    }
    
   
}

- (void)addressInfoSave{
    if([ShareUserInfo share].userInfo.address.length>0){//地址数据 存储
        [[NSUserDefaults standardUserDefaults] setValue:[ShareUserInfo share].userInfo.address forKey:NSUserDefaults_Name_UserAddress];
    }else{
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:NSUserDefaults_Name_UserAddress];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
