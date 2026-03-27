//
//  MainBaseViewController.h
//  Community
// 主页数据部分初始化 拆分
//  Created by 余莹 on 2020/11/27.
//

#import <UIKit/UIKit.h>
#import "MainTableViewHeaderView.h"
@class PopViewAddressBookDetaillPhoneList;
#import "UrgentInfoOrTopInfoDetailVC.h"
#import "CommunityFunListViewModel.h"
#import "CommunityFunDetialVC.h"
#import "MainWeatherCellViewModel.h"
#import "MainRecommendedServiceHourseEstateCellViewModel.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"

#import "PesionVC.h"
#import "MedicalVC.h"
#import "HouseRentHouseDetailVc.h"
#import "HouseRentBuniessShopDetailVc.h"
#import "ParkingVC.h"
#import "ParkingVcLate.h"
#import "MyCarWithParkingSpotListVC.h"
#import "MyCarListInfoVC.h"

#import "PopViewWithMoreServiceWillBeOpeningUp.h"
#import "PopViewWithGoToRealCertification.h"
#import "PopViewWithOtherFunction.h"
#import "PopViewWithChangeCommunity.h"

#define PageSize_CommunityFunList 10
#define MainBackgroundColor  [UIColor blackColor]

#define mainTableViewCell_Identifier                                                 @"UITableViewCell"
#define mainTableViewCell_top_BannerScrollView_Identifier                            @"MainTableViewTopBannerCell"
#define mainTableViewCell_cneter_Menu_Identifier                                     @"MainTableViewCenterMenuCell"
#define mainTableViewCell_cneter_BannerScrollView_Identifier                         @"MainTableViewCenterBannerCell"
#define mainTableViewCell_cneter_AddressBook_Identifier                              @"MainTableViewAddressBookCell"
#define mainTableViewCell_cneter_Shopping_Identifier                                 @"MainTableViewShoppingCell"
#define mainTableViewCell_Bottom_News_Identifier                                     @"MainTableViewInterestingNewsCell"
#define mainTableViewCell_RecommendedService_Weather_Identifier                      @"MainTableViewRecommendedServiceWeatherCell"
#define mainTableViewCell_RecommendedService_HourseEstate_Identifier                 @"MainTableViewRecommendedServiceHourseEstateCell"
#define mainTableViewCell_ConvenienceService_Identifier                              @"MainTableViewConvenienceServiceCell"
#define mainTableViewCell_PersionAndMedical_Identifier                               @"MainTableViewPersionAndMedicalTableViewCell"

//
#import "MyHousekeeperVC.h"

#define mainTableViewCell_TopMenuCell_Identifier                                     @"MainTableViewTopMenuCell"
#define mainTableViewCell_MainLateMyServiceCell_Identifier                           @"MainLateMyServiceCell"
#define mainTableViewCell_ShengHuoGuangChangCell_Identifier                          @"MainLateShengHuoGuangChangCell"
#define mainTableViewCell_PingTuan_Identifier                                        @"ZYCommunityManagementMainSpellGroupCell"

 
#define mainTableViewCell_Height_cell_TopMenuCell    ((90+5)*2)    //菜单
//
#define mainTableViewCell_Height_cell_topRollingView 150   //section 0 左右轮播
#define mainTableViewCell_Height_cell_centerOneFunctionView (100+5) //菜单
#define mainTableViewCell_Height_cell_centerRollingView (50+10) //section 0 紧急消息 上下轮播
#define mainTableViewCell_Height_cell_RecommendedServiceView_Weather (130+10) //便民服务——天气
#define mainTableViewCell_Height_cell_RecommendedServiceView_House (140+10) //便民服务——楼盘
#define mainTableViewCell_Height_cell_PeisonAndMedical (70+20) // 医疗养老
#define mainTableViewCell_Height_cell_ConvenienceServiceView (150+10) //推荐服务
#define mainTableViewCell_Height_cell_centerAddressBookView (120) //社区通讯录
#define mainTableViewCell_Height_cell_centerShoppingView (200+20) //轮播图+左右集合视图(2个 110+10+90)
#define mainTableViewCell_Height_cell_centerInterestingNewsView (105+10) //底部新闻
#define mainTableViewCell_Height_cell_HeaderView 30 //组头
#define mainTableViewCell_Height_HeaderViewView 80 //搜索
#define mainTableViewCell_Height_PingTuan  196 //拼团高度
#define mainTableViewCell_NoDataHeight_PingTuan  80 //拼团没数据高度

#define SectionAllNum               (7)
#define RowNum_OneCell_Mene_JingJiInfo_BannerOne             (0)
#define RowNum_BianMingFuWu         (1)
#define RowNum_YangLaoYiLiao        (2)
#define RowNum_TuiJianFuWu          (3)
#define RowNum_PhonesAddress        (4)
#define RowNum_ShopingLife          (5)
#define RowNum_LifeInterestNews     (6)



NS_ASSUME_NONNULL_BEGIN

@interface MainBaseViewController : UIViewController
@property (nonatomic,strong) NSMutableArray *headerViewRightTextArr;
@property (nonatomic,strong) MainTableViewHeaderView *tableViewHeaderView;
@property (nonatomic,strong) UIImageView *backImgView;//主背景
@property (nonatomic,strong) NSMutableArray *tableViewSTitleArr;

@property (nonatomic,strong) NSMutableArray *topSourceArr;//当前顶部轮播图数据
@property (nonatomic,strong) NSMutableArray *topImgUrlArr;//未用
@property (nonatomic,strong) NSMutableArray *topImgTitleArr;//未用

@property (nonatomic,strong) NSMutableArray *centerMenuSourceArr;
@property (nonatomic,strong) NSMutableArray *centerOneImgArr;
@property (nonatomic,strong) NSMutableArray *centerOneTitleArr;

@property (nonatomic,strong) NSMutableArray *centeradvertScrollviewSourceArr;//中间的轮播图数据 紧急消息

@property (nonatomic,strong) NSMutableArray *centerAddressBookSourceArr;
@property (nonatomic,strong) NSMutableArray *shoppingScrollViewArr;//实惠生活轮播图
@property (nonatomic,strong) NSMutableArray *centerShoppingSourceArr;
@property (nonatomic,strong) NSMutableArray *bottomNewsSourceArr;
@property (nonatomic,assign) NSInteger bottomNewsPageNum;//社区趣事
@property (nonatomic,assign) NSInteger bottomShengHuoGuangChangPageNum;//生活广场 页数

@property (nonatomic,strong) PopViewAddressBookDetaillPhoneList *popViewPhoneBookList;//当前部门通讯录
@property (nonatomic,strong) NSMutableArray *popViewPhoneDetailListDataSource;//当前部门通讯录列表
//07late加的
@property (nonatomic,strong) NSMutableArray *zuFangArr;
@property (nonatomic,strong) NSMutableArray *erShouArr;


//天气
@property (nonatomic,strong) NSDictionary *wearherMainDic;
@property (nonatomic,strong) NSMutableArray *wearherRightArr;
//租房旁边的最新消息（原为楼盘消息）
@property (nonatomic,strong) NSMutableArray *recommendedServiceNewsListArr;
//未实名认证的popview
@property (nonatomic,strong) PopViewWithGoToRealCertification *popViewGotoCertification;
//更多服务逐步开发提示
@property (nonatomic,strong) PopViewWithMoreServiceWillBeOpeningUp *popViewMoreServiceWillOpening;
//右下角 按钮
@property (nonatomic,strong) UIButton *mainVcBottomRightBtn;
- (void)initMianBottomRightBtnView;
@property (nonatomic,strong) PopViewWithOtherFunction *popViewWithOtherFunction;
@property (nonatomic,strong) PopViewWithChangeCommunity *popViewWithChangeCommunity;

- (void)showHouLinePopV;
- (void)setupNavigationBarWhiteStyle;
- (void)setupNavigationBarTransparentStyle;
- (void)setupNavigationBarStyleWithMainColor;//更改透明为主题色
- (void)setupNavigationBarClearTransparentStyle;//清除navigationBar的颜色
- (void)setupNavigationBarBlackStyle;
- (void)setupNavigationBarStyleWithThemeColor;
- (void)pushVc:(id)vc;
//
- (void)chatSeverConnectionBeginGetNeedInfoAndFirstOpenSocketAction;
@end

NS_ASSUME_NONNULL_END
