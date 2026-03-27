//
//  ModelHeader.h
//  Community
//
//  Created by 余莹 on 2020/11/12.
//

#ifndef ModelHeader_h
#define ModelHeader_h

#import <CoreLocation/CoreLocation.h>
#import "NSString+ArvinCategory.h"
#import "ShareUserInfo.h"
#import "UserModel.h"
#import "WeChatLoginUserModel.h"
#import "ZFBLoginModel.h"
#import "AppleLoginModel.h"
//

#import "CommitRightIdsModel.h"
#import "CommitRightAllDataModel.h"//当前小区角色权限

//聊天相关
#import "ChatUserModel.h"
#import "ChatFriendModel.h"
#import "ChatGroupModel.h"


#pragma mark === main_view_model
#import "TableViewTopAndCenterBannerCellModel.h"
#import "MainCenterCollectionViewCellModel.h"
#import "MainCenterCollectionViewAddressBookCellModel.h"
#import "MainCenterCollectionViewShoppingCellModel.h"
#import "TableViewBottomNewsCellModel.h"//更换弃了
#import "CommunityFunModel.h"//社区趣事
#import "MainWeatherModel.h"//天气相关
#import "MainRecommendedServiceHourseEstateModel.h"//房屋租赁主页右3行

#pragma mark === main_sub
#import "CityChooseModel.h"
#import "CommunityModel.h"
#import "BuildingModel.h"
#import "UnitModel.h"
#import "FloorModel.h"
#import "AddressModel.h"
#import "PublicChooseHouseMultipleLevelsModel.h" //新 房屋层级list选择相关的model

#pragma mark == 业主是否已经登记 判断 关系VC跳转走向
#import "UserInfoRegistWillEnterWhichVcWithData.h"
#import "RealNameAuthenticationCardModel.h"//实名认证卡片的数据model
#pragma mark == 业主登记 客人等
#import "UserInfoRegistModel.h"//业主
#import "UserFamilyModel.h"//家属
#import "GuestInfoModel.h"//客人访客
#import "CarTypeModel.h"//车类型
#import "CarInfoModel.h"//车牌+车类型
#import "RelationshipModel.h"//亲属关系
#import "AccessModel.h"//门禁（小区门禁 楼栋门禁）

#import "UserHouseModel.h"//获取的用户房产

#pragma mark == 房屋报修
#import "HouseRepairListModel.h"
#import "HouseRepairDetailModel.h"
#import "HouseRepairEditModel.h"
#import "HouseRepairTypeModel.h"

#pragma mark ==  出租 转让
#import "HouseRentListVcHouseCellModel.h"
#import "HouseRentListVcBuniessShopCellModel.h"
#import "HouseRentDetailVcHouseModel.h"
#import "HouseRentDetailVcBuniessShopModelShopModel.h"
#import "HouseRentDetailVcBuniessShopModelUserModel.h"
#import "HouseRentMoreShaixuanModel.h"//房屋租赁更多筛选model

#pragma mark == 生活缴费
#import "LifeCostMyCostModel.h"
#import "LifeCostAddNewCostModel.h"
#import "LifeCostAddNewCompanyModel.h"
#import "LifeCostHistoryCostModel.h"

#pragma  mark == 个人中心
//房屋租赁发布
#import "IssueBuniessShopTagsModel.h" //发布商铺的类型tagsModel
#import "IssueBuniessShopPublishTypeModel.h"  //发布商铺的类型滚轮用到的Type
#import "PopViewBuniessShopAndHouseChoosePayWayModel.h" //押金方式的model 也是房屋常量的model
#import "IssueHouseCellBlueSubBtnCellModel.h" //发布房屋的blueCellBtn的model
#import "IssueHouseConstModel.h" //常量的model

//新增所用
#import "IssueHouseAddNewModel.h"       //房屋租赁发布 （房屋的新增）
#import "IssueShopBuniessAddNewModel.h" //商铺租赁发布 （商铺的新增）

//
#import "IssueShopBuniessQuYuModel.h"   //商铺 区域

//支付相关
#import "WillPayOrderInfoModel.h"


//租赁签约信息
#import "ZYRentSignInfoModel.h"

//仓储小店
#import "SmallShopNowShopShare.h"


#pragma mark === wx
#define WX_ACCESS_TOKEN_UserDefaults_Get     [[NSUserDefaults standardUserDefaults]objectForKey:@"access_token"]
#define WX_REFRESH_TOKEN_UserDefaults_Get    [[NSUserDefaults standardUserDefaults]objectForKey:@"refresh_token"]
#define WX_OPEN_ID_UserDefaults_Get          [[NSUserDefaults standardUserDefaults]objectForKey:@"openid"]
#define WX_ACCESS_TOKEN_UserDefaults_Set     [[NSUserDefaults standardUserDefaults]setValue:responsObject[@"access_token"] forKey:@"access_token"];
#define WX_OPEN_ID_UserDefaults_Set          [[NSUserDefaults standardUserDefaults]setValue:responsObject[@"openid"] forKey:@"openid"];
#define WX_REFRESH_TOKEN_UserDefaults_Set    [[NSUserDefaults standardUserDefaults]setValue:responsObject[@"refresh_token"] forKey:@"refresh_token"];

#pragma mark === zfb

#endif /* ModelHeader_h */
