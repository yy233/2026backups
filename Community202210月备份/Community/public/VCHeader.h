//
//  VCHeader.h
//  Community
//
//  Created by 余莹 on 2020/11/11.
//

#ifndef VCHeader_h
#define VCHeader_h




#pragma mark ==== base
#import "AppDelegate.h"
#import "TabBarController.h"
#import "BaseViewController.h"
#import "BaseViewController+NavColorNotMain.h"
#import "ZYBaseViewController.h"
#import "BaseViewControllerNotNoticeWithUI.h"
#import "BaseHiddenNavViewController.h"
#import "BaseNavigationController.h"
#import "BaseTableViewController.h"
#import "BaseTableViewController+NavColorNotMain.h"
#import "BaseTableViewController_DW.h"
#import "BaseTableViewControllerNotNoticeWithUI.h"
#import "BaseHaveTableViewViewController.h"
#import "BaseMoneyWalletVC.h"
#import "ZYRootBaseVc.h"
#import "ZYPageBaseVc.h"
#import "ChatBaseViewController.h"
#import "ChatBaseTableViewController.h"
#import "ZYPensionTopBaseVC.h"
#import "ZYPensionBaseVC.h"
#import "ZYMedicalTopBaseVC.h"
#import "ZYMedicalBaseVC.h"
#import "ZYSmallShopBaseVC.h"

#pragma mark ==== LoginAndOtherVC
#import "LoginVC.h"
#import "LoginAndRegiestVC.h"
#import "RegistVC.h"
#import "FirstPassWordSetVC.h"
#import "ResetPasswordVC.h"
#import "ResetPasswordVCLast.h" 
#import "NewPassWordSetVC.h"
#import "BindingPhoneVC.h"
#import "InputCodeVC.h"
#import "PrivacyAgreementVC.h"
#import "PrivacyAgreementVCLate.h"

#pragma mark ==== MainVC
#import "ElectronicSignatureVC.h"
#import "ZYContrectManageVC.h"
#import "ContrectAllListVC.h"
#import "MainBaseViewController.h"
#import "CommunityManagementMainVC.h"
#import "BusinessServicesVC.h"
#import "ShortcutMenuVC.h"
#import "PersonCenterVC.h"
#import "CommunityFunMoreVC.h"
#import "CommunityManagementMainVcLate.h"
#import "PersonCenterVCLate.h"
//main-sub-vc
// 未实名认证的vc 与签章共用同一个UI
#import "ElectroniNewRealNameAuthenticationCardVc.h"
//业主登记的vc
#import "UserInfoRegistVC.h"
#import "UserCertificationViewController.h"
#import "CityChooseTableViewController.h"
#import "BaseChooseTableViewController.h"
#import "CommunityChooseTableViewController.h"
#import "UnitChooseTableViewController.h"
#import "BuildingNumChooseTableViewController.h"
#import "FloorChooseTableViewController.h"
#import "AddressesChooseTableViewController.h"

#import "UserCertificationChooseHouseDetailAddressVC.h"//房屋选择vc

//客人相关
#import "GuestInfoRegistionVC.h"
#import "GuestInfoRegistionAddOrShowVC.h"
#import "GuestInfoRegistionAccompanyVC.h" //随行

//菜单vc
#import "MoreMenuChooseVCType.h"
#define Meue_Path_UserInfoRegist          @"home"     // 我的房屋
//#define Meue_Path_Life                    @"cost"     // 生活缴费
#define Meue_Path_Guest                   @"visitor"  //访客邀请
#define Meue_Path_Scan                    @"scan"     //扫一扫
#define Meue_Path_Repair                  @"repair"   //一键报修
#define Meue_Path_Hotline                 @"hotline"  //服务热线
#define Meue_Path_Shop                    @"shop"        //周边店铺
#define Meue_Path_MedicalMainActivity     @"MedicalMainActivity"    //社区医疗
#define Meue_Path_SeniorLifeMainActivity  @"SeniorLifeMainActivity"    //社区养老
//#define Meue_Path_Advice                  @"advice"   //投诉建议//新旧都用
#define Menu_Path_SmallShop               @"store" //仓储小店
#define Menu_Path_PakingCar               @"smartParking" //停车缴费


#define Meue_Path_Notice                  @"notice"      //社区公告
#define Meue_Path_Property                @"property"    //物业缴费 这是生活缴费
#define Meue_Path_Advice                  @"advice"      //投诉建议
#define Meue_Path_Activity                @"activity"    //活动报名
#define Meue_Path_Lease                   @"lease"       //房屋租赁
#define Meue_Path_Bbazaar                 @"bazaar"      //社区集市
#define Meue_Path_Vote                    @"vote"        //业主投票



//#define Meue_Path_House @"house"

#import "TopInformationVC.h"
#import "MoreUrgentListVC.h"
#import "MoreMenuVC.h"
//通讯录详情列表
#import "AddressBookDetaillPhoneVC.h"


//房屋报告修
#import "HouseRepairListVC.h" //旧 弃用
#import "HouseRepairEditVC.h"
#import "HouseRepairDetailShowVC.h"


#import "HouseRepairMainPageVC.h"//旧版 弃用
#import "HouseRepairPageBaseListVC.h"


#import "MyRepairMainPageVC.h"
#import "MyRepairPageBaseListVC.h"

//投诉建议 ---房屋报修的评价 （好评 差评）
#import "AdviceVc.h"

//出租
#import "HouseRentVC.h"

//生活缴费
#import "LifeCostVC.h"
#import "LifeCostPaymentOnePayProgressDetailsVC.h"
#import "LifeCostPaymentOneEndBillOrderDetailsVC.h"
#import "LifeCostPaymentOnePayProgressEndCredentialsDetailsVC.h"


//个人中心
//---租赁发布
#import "HouseAllTypeBaseIssueVc.h" //房屋的提交前第一页
#import "HouseZhengZuIssueOkVc.h" //房屋提交——整租类型——提交页
#import "HouseDanJianIssueOkVc.h"
#import "HouseHeZuIssueOkVc.h"

#import "IssueChooseCityBaseVc.h"
#import "IssueChooseCommunityBaseVc.h"

#import "IssueHouseManagerVC.h"//租房管理

//投诉建议
#import "ComplaintsSuggestionsVC.h"

// 智能停车(新)
#import "ZYParkingVcLate.h"

#pragma mark ==== OtherVc
#endif /* VCHeader_h */
