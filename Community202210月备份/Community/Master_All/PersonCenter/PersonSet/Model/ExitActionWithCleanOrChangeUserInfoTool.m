//
//  ExitActionWithCleanOrChangeUserInfoTool.m
//  Community
//
//  Created by 余莹 on 2022/3/21.
//

#import "ExitActionWithCleanOrChangeUserInfoTool.h"
#import "ZBLocalNotification.h"
#import "HealthBaseDataManager.h"
#import "TrusangBlueToothSdkDataManager.h"
#import "DevGetNowUsersDevInfoModel.h"
#import "SocketRocketUtility.h"


@implementation ExitActionWithCleanOrChangeUserInfoTool

+ (void)exitActionWithDealUseInfo{
    //登录状态
    [IsLoginTool share].save_Login_Type = IS_Login_NotLogin;
    //聊天连接关闭
    [[SocketRocketUtility instance]SRWebSocketClose];
     
    [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUseContactTheMerchantHeader_Token = @"";
    [[NSUserDefaults standardUserDefaults] setValue:@""  forKey:@"chatUseContactTheMerchantHeader_Token"];
    [[NSUserDefaults standardUserDefaults] setValue:@""  forKey:@"isSignPassword"];
    [[NSUserDefaults standardUserDefaults] setValue:@""  forKey:@"isRealNameElectronicSignature"];
    //token 过期时间
    [ShareUserInfo sharedUserInfo].userInfo = [[UserModel alloc]init];
    [ShareUserInfo sharedUserInfo].commuityInfo  = [[CommunityModel alloc]init];
    [ShareUserInfo sharedUserInfo].token = @"";
    [ShareUserInfo sharedUserInfo].expiredTime = @"";
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:kLogin_ExpiredTime_Key];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"token"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    //重置本地存储数据
    [[ShareUserInfo sharedUserInfo] saveDefaultsLoginUserInfo:[UserModel new]];
    [[ShareUserInfo sharedUserInfo] saveDefaultsCityCommnuitInfo:[CommunityModel new]];
    [[ShareUserInfo sharedUserInfo] saveDefaultsPositioningInfo:[ZYPositioningModel new]];
    //
    [ShareUserInfo sharedUserInfo].commuityInfo = [[CommunityModel alloc] init];
    [ShareUserInfo sharedUserInfo].userInfo = [[UserModel alloc] init];
    [ShareUserInfo sharedUserInfo].positioningModel = [[ZYPositioningModel alloc] init];
    [ShareUserInfo sharedUserInfo].communityFairMarketModel = [[ZYCommunityFairMarketModel alloc] init];
    [ShareUserInfo sharedUserInfo].pensionInfoModel = [[ZYMyPensionInfoModel alloc] init];
    [UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel = [[CommitRightAllDataModel alloc]init];
    
    // 取消所有本地定时通知
    [self cancelLocalNotification];
    //设备置nil
    [self clearnHealthDevInfo];
}

+ (void)clearnHealthDevInfo{
 
    [TrusangBlueToothSdkDataManager share].showModel = [[TrusangBlueToothUseShowModel alloc]init];
    [TrusangBlueToothSdkDataManager share].showModel.histroy_TempArr = [[NSMutableArray alloc]init];
    [TrusangBlueToothSdkDataManager share].showModel.histroy_HeartRateArr = [[NSMutableArray alloc]init];
    [TrusangBlueToothSdkDataManager share].showModel.histroy_BpSpArr= [[NSMutableArray alloc]init];
    [TrusangBlueToothSdkDataManager share].showModel.histroy_BoArr = [[NSMutableArray alloc]init];
    [TrusangBlueToothSdkDataManager share].showModel.histroy_SleepArr = [[NSMutableArray alloc]init];
    [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave = [[ZHJBTDevice alloc]init];
    [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.mac = @"";
    [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave.name = @"";
    [TrusangBlueToothSdkDataManager share].nowDevState = DeviceStateDefault;
    NSLog(@"设备清空 %@｜（在切换人员时） 扫描的蓝牙设备arr不能删除  需要使用 %@", [TrusangBlueToothSdkDataManager share].nowBlueToothDevSave,[TrusangBlueToothSdkDataManager share].scanDevsSaveArr);
    [TrusangBlueToothSdkDataManager share].scanDevsSaveArr = [NSMutableArray arrayWithCapacity:0];
    //
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel = [[HealthBaseDataSaveNowUseModel alloc]init];
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserHealthInfoDic = [NSMutableDictionary dictionaryWithCapacity:0];
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel = [[DevGetNowUsersDevInfoModel alloc]init];
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceName = @"";
    [HealthBaseDataManager share].nowUserInfoAndHealthSaveModel.nowUserDevInfoModel.mdeviceAddress = @""; 
}

#pragma mark - ===
// 取消本地定时通知
+ (void)cancelLocalNotification {
    NSArray *eventNotiIds = [[NSUserDefaults standardUserDefaults] valueForKey:@"eventNotiIds"];
    [ZBLocalNotification cancelLocalNotificationWithNotiIds:eventNotiIds];
    [[NSUserDefaults standardUserDefaults] setValue:@[] forKey:@"eventNotiIds"];
}

@end
