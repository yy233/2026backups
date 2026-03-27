//
//  LoginUserInfo.h
//  投票
//
//  Created by yy on 17/3/3.
//  Copyright © 2017年 yy. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "MethodsHeader.h"
#import "CommunityModel.h"
#import "ZYPositioningModel.h"
#import "ZYCommunityFairMarketModel.h"
#import "ZYMyPensionInfoModel.h"

static NSInteger const kMYAPP_Now_IS_HIDDEN_MORE_INDEX = 1;//当前给的隐藏多种模块的版本（是否为最小敏捷版）

static NSInteger const kMYAPP_Now_IS_HIDDEN_CAR = 1;//当前 （是否为隐藏车辆相关的UI ）

static NSInteger const kPayMoneyTypeShow_HidenZFB = 1;//支付展示 隐藏支付宝项目 (社区小店和物业缴费2.4.0后是做了展示限制)


static  NSString  * const kLogin_ExpiredTime_Key = @"expiredTime";//过期时间键 


@interface ShareUserInfo : NSObject <NSCopying,NSMutableCopying>
singleton_interface(sharedUserInfo)

@property (nonatomic, assign) BOOL isHavaChooseAgreeBtn;
//0927过期时间 文本类型
@property (nonatomic, strong) NSString *expiredTime;//"2021-10-04 15:20:16";格式
//用户
@property (nonatomic, strong) UserModel *userInfo;//用户模型
@property (nonatomic, strong) NSString *token;//用户token
@property (nonatomic, strong) NSString *account;//用户
@property (nonatomic, strong) NSString *password;//密码
@property (nonatomic,strong) CommunityModel *commuityInfo;
@property (nonatomic, strong) ZYPositioningModel *positioningModel; //定位信息
@property (nonatomic, strong) ZYCommunityFairMarketModel *communityFairMarketModel; //社区集市编辑的商品信息
@property (nonatomic, strong) ZYMyPensionInfoModel *pensionInfoModel; //养老用户信息
@property (nonatomic, strong) NSDictionary *shareDict;
 
- (void)saveDefaultsCityCommnuitInfo:(CommunityModel *)model;
- (void)getDefaultsCityCommnuit;
- (void)saveDefaultsLoginUserInfo:(UserModel *)model;
- (void)getDefaultsLoginUserInfo;
- (void)saveDefaultsPositioningInfo:(ZYPositioningModel *)model;
- (void)getDefaultsPositioningInfo;
- (void)saveDefaultsCommunityFairMarketInfo:(ZYCommunityFairMarketModel *)model;
- (void)getDefaultsCommunityFairMarketInfo;
- (void)savePensionInfoModel:(ZYMyPensionInfoModel *)model;
- (void)getPensionInfoModel;
//用户注册 房子的时候处理的部分数据
- (void)saveDefaultsUserInfoRegist:(UserModel *)model;
@end
