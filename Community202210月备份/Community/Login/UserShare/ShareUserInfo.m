//
//  LoginUserInfo.m
//  投票
//
//  Created by yy on 17/3/3.
//  Copyright © 2017年 yy. All rights reserved.
//

#import "ShareUserInfo.h"

@implementation ShareUserInfo
MJCodingImplementation //归档

//+ (ShareUserInfo *)sharedUserInfo {
//    static id instance;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        instance = [[self alloc] init];
//    });
//
//    return instance;
//}

singleton_implementation(sharedUserInfo)

//小区信息
- (void)saveDefaultsCityCommnuitInfo:(CommunityModel *)model{
    CommunityModel *communityInfo = model;
    [ShareUserInfo sharedUserInfo].commuityInfo = communityInfo;
   // NSData *communityInfoData = [NSKeyedArchiver archivedDataWithRootObject:communityInfo requiringSecureCoding:YES error:nil];
    NSData *communityInfoData = [NSKeyedArchiver archivedDataWithRootObject:communityInfo];
    [[NSUserDefaults standardUserDefaults] setValue:communityInfoData forKey:NSUserDefaults_Name_CommunityInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//用户注册 房子的时候处理的部分数据
- (void)saveDefaultsUserInfoRegist:(UserModel *)model{
    [ShareUserInfo sharedUserInfo].userInfo.idCard = model.idCard;
    [ShareUserInfo sharedUserInfo].userInfo.sex = model.sex;
    [ShareUserInfo sharedUserInfo].userInfo.realName = model.realName;
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)getDefaultsCityCommnuit{
    NSData *communitInfoData = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaults_Name_CommunityInfo];
    //CommunityModel *communitModel = [NSKeyedUnarchiver unarchivedObjectOfClass:[CommunityModel class] fromData:communitInfoData error:nil];
    CommunityModel *communitModel = [NSKeyedUnarchiver unarchiveObjectWithData:communitInfoData];
    [ShareUserInfo sharedUserInfo].commuityInfo = communitModel;

}
//登录个人信息
- (void)saveDefaultsLoginUserInfo:(UserModel *)model{
    UserModel *userInfo = model;
    [ShareUserInfo sharedUserInfo].userInfo = userInfo;
    NSData *userInfoData = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [[NSUserDefaults standardUserDefaults] setValue:userInfoData forKey:NSUserDefaults_Name_UserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)getDefaultsLoginUserInfo{
    NSData *userInfoData = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaults_Name_UserInfo];
    UserModel *userInfoModel = [NSKeyedUnarchiver unarchiveObjectWithData:userInfoData];
    [ShareUserInfo sharedUserInfo].userInfo = userInfoModel;
}

//定位信息
- (void)saveDefaultsPositioningInfo:(ZYPositioningModel *)model {
    [ShareUserInfo sharedUserInfo].positioningModel = model;
    NSData *positioningData = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setValue:positioningData forKey:NSUserDefaults_Name_PositioningInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)getDefaultsPositioningInfo {
    NSData *positioningData = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaults_Name_PositioningInfo];
    ZYPositioningModel *positioningModel = [NSKeyedUnarchiver unarchiveObjectWithData:positioningData];
    [ShareUserInfo sharedUserInfo].positioningModel = positioningModel;
}

// 商品信息
- (void)saveDefaultsCommunityFairMarketInfo:(ZYCommunityFairMarketModel *)model {
    [ShareUserInfo sharedUserInfo].communityFairMarketModel = model;
    NSData *communityFairMarketData = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setValue:communityFairMarketData forKey:NSUserDefaults_Name_CommunityFairMarketInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)getDefaultsCommunityFairMarketInfo {
    NSData *communityFairMarketData = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaults_Name_CommunityFairMarketInfo];
    ZYCommunityFairMarketModel *communityFairMarketModel = [NSKeyedUnarchiver unarchiveObjectWithData:communityFairMarketData];
    [ShareUserInfo sharedUserInfo].communityFairMarketModel = communityFairMarketModel;
}

- (void)savePensionInfoModel:(ZYMyPensionInfoModel *)model {
    [ShareUserInfo sharedUserInfo].pensionInfoModel = model;
    NSData *infoData = [NSKeyedArchiver archivedDataWithRootObject:model];
    [[NSUserDefaults standardUserDefaults] setValue:infoData forKey:NSUserDefaults_Name_MyPensionInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)getPensionInfoModel {
    NSData *infoData = [[NSUserDefaults standardUserDefaults] objectForKey:NSUserDefaults_Name_MyPensionInfo];
    ZYCommunityFairMarketModel *infoModel = [NSKeyedUnarchiver unarchiveObjectWithData:infoData];
    [ShareUserInfo sharedUserInfo].communityFairMarketModel = infoModel;
}

@end
