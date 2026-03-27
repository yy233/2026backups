//
//  ShareUserInfo.m
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/15.
//

#import "ShareUserInfo.h"

@implementation ShareUserInfo

MJCodingImplementation //归档

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
          
            NSLog(@"userModel信息 获取 成功 %@",[[ShareUserInfo share].userInfo mj_keyValues]);
        }else{
            NSLog(@"userModel信息 获取 失败");//解档的大坑 如果其中存在NSArray等集合，那么解档同样会失败。又或者是因为缺失协议supportsSecureCoding yes
        }
    }
    
   
}
@end
