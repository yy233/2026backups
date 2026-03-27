//
//  CommunityManagementMainVcLast.m
//  Community
//
//  Created by 余莹 on 2021/7/26.
// 20220120
// 

#import "CommunityManagementMainVcLate.h"
#import "ZYBannerDetailVc.h"
#import "ZYChatRootTabBarVc.h"
#import "ZYCommunityFairDetailVC.h"
#import "IssueHouseQianYueManagerVC.h"
#import "ScanHelper.h"
#import "HouseRentVCListViewModel.h"
#import "HouseRentListVcHouseCellModel.h"
#import "MainShengHuoGuangChangListData.h"
#import "MainShengHuoGuangChangListErShouUseModel.h"
#import "LifeCostPropertyFeeListVc.h"
#import "LifeCostPropertyFeeListLateVc.h" //物业缴费
#import "MedicalWebViewVc.h"
#import "ZYSmallShopGoodsSpellGroupDetailVc.h"
#import "ZYSmallShopGoodsSpellGroupShareWebVc.h"
#import "ZYSmallShopGoodsData.h"
#import "ExitActionWithCleanOrChangeUserInfoTool.h"

#import "PackingPayHistoryVC.h"

// 投诉意见
#import "ZYComplaintsOpinionVC.h"
// 活动报名
#import "ZYActivityApplyVC.h"
// 社区集市
#import "ZYCommunityFairVC.h"
// 业主投票
#import "ZYOwnersVoteVC.h"
//绑定 家属租客跳转确定vc
#import "InformationOrScanGoToWebVc.h"
//通知消息
#import "MainAllTypeInformationVC.h"
//生活缴费
#import "LifeCostMainVC.h"
// 社区养老
#import "ZYPensionRootTabBarVC.h"
// 社区医疗
#import "ZYMedicalRootTabBarVC.h"
// 社区小店
#import "ZYSmallShopMainVC.h"
// 新版报事报修
#import "ZYHouseRepairIssueVc.h"
// 智能停车（新）
#import "ZYParkingVcLate.h"

// 问卷调查
#import "ZYQuestionnaireSurveyVc.h"
// 社区集市(新)
#import "ZYCommunityFairLateVc.h"
// 闲置商品发布
#import "ZYCommunityFairIssueVc.h"
// 活动报名
#import "ActivityListVC.h"

 
#define MainVcSectionAllNum               (3)
#define SectionNum_Top                    (0)
#define SectionNum_MyService              (1)
#define SectionNum_LifeSquare             (2)
#define RowNum_TopScrollBanner            (0)
#define RowNum_TopMenuAll                 (1)
#define RowNum_TopJingJIInfoScrollBanner  (2)
//

static NSInteger kNoAccessLevel = 999;//没有权限数据时的初使level
static NSInteger kNotHaveCommunityInfo_ID  = 444;//没有认证小区时的暂位ID

@interface CommunityManagementMainVcLate ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,MainTableViewTopMenuCellDelegate,SGAdvertScrollViewDelegate,AddressBookViewDelegate,MainTableViewPersionAndMedicalTableViewCellDelegate,ShoppingViewDelegate,MainConvenienceSeriveViewDelegate,MainCellRecommendedServiceHourseEstateDelegate,BasePopTableViewChooseDelegate,PopViewWithGoToRealCertificationDelegate,PopViewWithOtherFunctionDelegate,IssuLastAddressCellSubBasePopViewDelegate,ZYCommunityManagementMainSpellGroupCellDelegate>
@property (nonatomic,strong) UITableView *mainTableView;
@property (nonatomic,strong) UIButton *cityItem;
@property (nonatomic,strong) UIButton *scanningItem;
@property (nonatomic,strong) UIButton *infoItem;
@property (nonatomic,assign) CGFloat bottomCellH;
@property (nonatomic,assign) MainLateShengHuoGuangChangCell_TopHeader_Type shengHuoGuangChagnSubCellHeaderTypeUseRefreshUpData;

// 拼团model
@property (nonatomic, strong) ZYSmallShopGoodsSpellGroupDetailModel *spellGroupModel;

@end

@implementation CommunityManagementMainVcLate
//取出数据+初始化model //初始化用户信息和小区信息model
- (void)initShareUserAndCommunityInfo{
    //userinfo
    [[ShareUserInfo sharedUserInfo] getDefaultsLoginUserInfo];
    if (isNil([ShareUserInfo sharedUserInfo].userInfo)) {
        UserModel *userInfo = [[UserModel alloc]init];
        [ShareUserInfo sharedUserInfo].userInfo = userInfo;
    }else{
        NSLog(@"initShareUserAndCommunityInfo  have userInfo");
    }
    //小区数据
    [[ShareUserInfo sharedUserInfo] getDefaultsCityCommnuit];
    if (isNil([ShareUserInfo sharedUserInfo].commuityInfo)) {
        CommunityModel *communityInfo = [[CommunityModel alloc]init];
        if ([IsLoginTool share].save_Login_Type==IS_Login_Nomal) {
            communityInfo.ID = 0;
            communityInfo.areaId = 0;
        }else{
            communityInfo.name = @"暂未认证房屋";
            communityInfo.ID = kNotHaveCommunityInfo_ID;
        }
      
        [ShareUserInfo sharedUserInfo].commuityInfo = communityInfo;
        [self initData];//1102 得到新校区数据后重新刷新主页
    }else{
        NSLog(@"initShareUserAndCommunityInfo  have commuityInfo");
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [ShareUserInfo sharedUserInfo].isHavaChooseAgreeBtn = YES;//登录页的底部同意按钮需要的数据

    [self.view.layer setOpaque:NO];
    self.view.opaque = NO;
    [self initNav];//导航栏初始化
    [self initView];

    [self.view.layer setOpaque:NO];
    self.view.opaque = NO;
    
    [self initShareUserAndCommunityInfo];//取出数据or初始化modelsave
    NSLog(@"begin  当前小区数据  commuityInfo %@",[[ShareUserInfo sharedUserInfo].commuityInfo mj_keyValues]);
    if ([ShareUserInfo sharedUserInfo].commuityInfo.ID==0) {
        [ShareUserInfo sharedUserInfo].commuityInfo.name = @"暂未认证房屋";
        [ShareUserInfo sharedUserInfo].commuityInfo.ID = kNotHaveCommunityInfo_ID;//默认值使主页有数据 20220421 不使主页有默认数据
        NSLog(@"当前小区数据 空 需要经纬度 commuityInfo %@",[[ShareUserInfo sharedUserInfo].commuityInfo mj_keyValues]);
        [self useLocAndLatToGetCommunityInfo];
    }

    [self initData];//默认值刷的主页数据 防止无数据情况 |由旧的社区信息支持本处方法 ｜【后续 位置信息 获得的新社区 再调用initData获取处理新数据】
    // 定位处理
    [self positioningHandle];//拿到定位数据用定位数据获取主页小区 主页小区拿到后加载initdata
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self headerInitData];
    });
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        if (@available(iOS 14.0, *)) {
            self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    }else {
        if (@available(iOS 14.0, *)) {
            self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        }
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    }
    
    self.navigationItem.title = @"";
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self setupNavigationBarStyleWithThemeColor];
    [self navBtnsChangeColor];//navItems
    dispatch_async(dispatch_get_main_queue(), ^{
        self.backImgView.image = [ThemeManager shareManager].mainViewLayerContentsImg;
    });
    
    // 实名查询
    [ZYRealNameAuthenticationTool realNameqQeryAuthentication];
    
    if (self.isJumpMyRent) {
        for (int i = 0; i < self.tabBarController.viewControllers.count; i++) {
            UINavigationController *naviVc = self.tabBarController.viewControllers[i];
            if ([naviVc.viewControllers.firstObject isKindOfClass:[PersonCenterVcLate class]]) {
                self.isJumpMyRent = NO;
                self.tabBarController.selectedIndex = i;
                IssueHouseQianYueManagerVC *vc = [[IssueHouseQianYueManagerVC alloc] init];
                //当前最高权限 来定初使的展示类型
                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel>1) {//1为业主 234为用户 5为游客
                    vc.myType = IssueHouseManagerVC_MyType_ZuKe;//初始状态为租客
                }else{
                    vc.myType = IssueHouseManagerVC_MyType_FangDong;//初始状态为房东
                }
                vc.hidesBottomBarWhenPushed = YES;
                [naviVc pushViewController:vc animated:YES];
            }
        }
    }
    
    if (self.isJumpContractManage) {
        for (int i = 0; i < self.tabBarController.viewControllers.count; i++) {
            UINavigationController *naviVc = self.tabBarController.viewControllers[i];
            if ([naviVc.viewControllers.firstObject isKindOfClass:[ElectronicSignatureVC class]]) {
                self.isJumpContractManage = NO;
                self.tabBarController.selectedIndex = i;
                if (ZY_IsRealName) {
                    ZYContrectManageVC *vc = [[ZYContrectManageVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [naviVc pushViewController:vc animated:YES];
                }else {
                    ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [naviVc pushViewController:vc animated:YES];
                }
            }
        }
    }
    
    if (isNotNil([ShareUserInfo sharedUserInfo].shareDict)) {
        NSString *communityId = [ShareUserInfo sharedUserInfo].shareDict[@"communityId"];
        NSString *spellId = [ShareUserInfo sharedUserInfo].shareDict[@"spellId"];
        [ShareUserInfo sharedUserInfo].shareDict = nil;
        ZYSmallShopGoodsSpellGroupShareWebVc *vc = [[ZYSmallShopGoodsSpellGroupShareWebVc alloc] init];
        vc.communityId = communityId;
        vc.spellId = spellId;
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        
        return UIStatusBarStyleDarkContent;
    }else {
        
        return UIStatusBarStyleLightContent;
    }
}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//
//    // 获取定位权限
//    [[ZYAuthorizationManager sharedManager] requestAuthorization:KCLLocationManager presentVc:self];
//}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setupNavigationBarStyleWithMainColor];
}

- (void)themeIsChange:(NSNotification*)notice{
    DLog(@"||||************主页themeIsChange***********|||");
     dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainTableView reloadData];
         [self navBtnsChangeColor];
    });
}
#pragma mark ====  拿到经纬度
// 定位处理
- (void)positioningHandle {
    
    // 获取定位信息
    WEAKSELF
    [ZYPositioningManager startPositioningWithLocationCompletion:^(ZYPositioningModel * _Nullable model, NSError * _Nullable error) {
        if (model) {
            // 持久化
            [[ShareUserInfo sharedUserInfo] saveDefaultsPositioningInfo:model];//经纬度存储
            [weakSelf useLocAndLatToGetCommunityInfo];// 已有的小区or经纬度获取就近小区 并显示文本 再获取小区相关数据
        }else {
            [[ShareUserInfo sharedUserInfo] getDefaultsPositioningInfo];
            if (![ShareUserInfo sharedUserInfo].positioningModel) {
                // 定位失败给一个默认地址
                ZYPositioningModel *positioningModel = [[ZYPositioningModel alloc] init];
                positioningModel.latitude = 29.606;
                positioningModel.longitude = 106.55;
                positioningModel.locality = @"重庆市";
                // 持久化
                [[ShareUserInfo sharedUserInfo] saveDefaultsPositioningInfo:positioningModel];
                [weakSelf useLocAndLatToGetCommunityInfo];// 已有的小区or经纬度获取就近小区 并显示文本 再获取小区相关数据
            }
        }
    }];
}
#pragma mark ====  使用经纬度获取小区
- (void)useLocAndLatToGetCommunityInfo{//经纬度最近小区
    NSLog(@"历史存入的 当前小区数据 经纬度获取前  commuityInfo = %@",[[ShareUserInfo sharedUserInfo].commuityInfo mj_keyValues]);
    Y_SVP_SHOW_MES_IsLoading_15Delay
    /**
     【 20211230主页右上小区数据每次都要请求 ｜topview 先使用 存储的数据｜不再做是否有旧数据的相关判定]
     */
    [self userGetNewCommuityInfoModelWillChangeNavViweData];
    Y_SVP_DISMISS
    WEAKSELF
    [[ShareUserInfo sharedUserInfo] getDefaultsPositioningInfo];
    [PositionViewModel getNewCommunityInfoWithLon:[ShareUserInfo sharedUserInfo].positioningModel.longitude AndLat:[ShareUserInfo sharedUserInfo].positioningModel.latitude WithModelBlock:^(CommunityModel * _Nonnull model) {
        STRONGSELF
        Y_SVP_DISMISS
        if (model.name==nil || [model.name isEqualToString:@"暂未认证房屋"] || model.name.length==0 ) {//空地址
            [ShareUserInfo sharedUserInfo].commuityInfo.name = @"暂未认证房屋";
            NSLog(@"空地址小区");
            [ShareUserInfo sharedUserInfo].commuityInfo.ID = kNotHaveCommunityInfo_ID;//游客账号登录
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [strongSelf initData];//主页数据
                [strongSelf userGetNewCommuityInfoModelWillChangeNavViweData];
                
            });
        }else{
            [[ShareUserInfo sharedUserInfo] saveDefaultsCityCommnuitInfo:model];//存储
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [strongSelf initData];//主页数据
                [strongSelf userGetNewCommuityInfoModelWillChangeNavViweData];
            });
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.cityItem setTitle:[NSString stringWithFormat:@"%@",model.name] forState:UIControlStateNormal];
                CGSize buttonTitleLabelSize = [[NSString stringWithFormat:@"%@",model.name] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}]; //文本尺寸
                strongSelf.cityItem.frame = CGRectMake(0,0,30 + buttonTitleLabelSize.width+20,24);
                [strongSelf.cityItem layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
                [strongSelf.cityItem setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
            });
        }
    }];

}
//topview  更新
- (void)userGetNewCommuityInfoModelWillChangeNavViweData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.cityItem setTitle:[NSString stringWithFormat:@"%@",[ShareUserInfo sharedUserInfo].commuityInfo.name] forState:UIControlStateNormal];
        CGSize buttonTitleLabelSize = [[NSString stringWithFormat:@"%@",[ShareUserInfo sharedUserInfo].commuityInfo.name] sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}]; //文
        self.cityItem.frame = CGRectMake(0,0,30 + buttonTitleLabelSize.width+20,24);//间隔20
        [self.cityItem layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        [self.cityItem setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           // [self initData]//1103这里不做获取，和本方法为同级别数据请求 没有先后 都要调用
        });
        
    });
}

#pragma mark ==== Refresh  刷新 action
- (void)headerInitData{
    NSLog(@"------------headeerRefres------------");
    [self useLocAndLatToGetCommunityInfo];//做经纬度查询 得到小区不一定为当前小区查询 内部会调用initData
    [self.mainTableView.mj_header endRefreshing];
}

#pragma mark ==== 主页变化时的通知 重点刷新小区文本图标颜色等
//(主页变化时的通知)（本notice重点刷新小区文本图标颜色）(切换房屋后 小区变了 nav数据刷新伴随着颜色刷新)
- (void)noticeWithCommnityIdIsChangeToRefreshMainVcInfo{
    [self userGetNewCommuityInfoModelWillChangeNavViweData];
}


#pragma mark == nav sub actions
#pragma mark == 小区切换
- (void)cityChooseAction{
    if ([IsLoginTool share].save_Login_Type==IS_Login_Tourists) {
        return;//游客不响应点击小区切换事件
    }
    //非游客
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [UserHouseOrCommunityListModel getUerAllCommunityListWithBlock:^(NSArray * arr, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            if (arr.count<=0) {//默认数据切换掉 都能切换1102去掉《=1的限制 改为〈=0的判断数据（1个小区也能切，后台数据返回有误时也能使用本处进行切换，在用户有小区时 返回测试小区的数据情况）
                Y_SVP_SHOW_INFO_MES(@"暂无可切换的小区");
                return;//不做切换
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popViewWithChangeCommunity showInViewWithPopType:IssuLastAddressCellSubBasePopView_Type_Community withListArray:arr.mutableCopy];
            });
        }
    }];
}
//小区切换
- (void)okBtnWithChooseListCellWithPopType:(IssuLastAddressCellSubBasePopView_Type)type withCellData:(NSDictionary *)dic{
    NSInteger communityId = [[dic allKeys]containsObject:@"id"] ? [[dic objectForKey:@"id"] integerValue] :1;
    NSString *communityName = [[dic allKeys]containsObject:@"name"] ? [dic objectForKey:@"name"] : @"暂无认证小区";
    [ShareUserInfo sharedUserInfo].commuityInfo.ID = communityId;
    [ShareUserInfo sharedUserInfo].commuityInfo.name = communityName;
    [ShareUserInfo sharedUserInfo].commuityInfo.detailAddress = @"";//切换的列表数据 没有对应详情 防止以后界面用到本键值时数据对应错误 现做清空处理
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self initData];
        [self userGetNewCommuityInfoModelWillChangeNavViweData];//主页顶部UI+数据
      
    });
}


#pragma mark ====  主页 —— 各个接口 数据 init Data

 
#pragma mark ==== init Data action
- (void)initData{
    WEAKSELF
    [self upJiGuangRegId];//极光
    //_____app版本强制更新与否
    [VersionShowOrHiddenTool getShowUpdataSignInfoWithBlock:^(BOOL success, BOOL isMastUpdataBool, NSString * _Nonnull showVersionNumStr, NSString * _Nonnull showVersionMsg) {
        STRONGSELF
        if (success) {
            if (isMastUpdataBool) {
                //提示用户需要更新版本
                if (showVersionNumStr.length>0||showVersionMsg.length>0) {
                    NSString *strWithNewVersionShowStr = [NSString stringWithFormat:@"最新版本%@:%@",showVersionNumStr,showVersionMsg];
                    [strongSelf showSignUpdataViewWithShowStr:strWithNewVersionShowStr];
                    
                }else{
                    [strongSelf showSignUpdataViewWithShowStr:@""];
                }
            }
        }
    }];
   
    //全部类型 协议版本同意与否
   NSArray *allAgreementArr = @[@(Agreements_Type_Disclaimer),
                                @(Agreements_Type_User),
                                @(Agreements_Type_Privacy),
                                @(Agreements_Type_Settlement),
                                @(Agreements_Type_Secondhand),
                                @(Agreements_Type_Lease),
                                @(Agreements_Type_Payment),
                                @(Agreements_Type_AboutUs),
   ];
    [PrivacyAgreementUserAgreementTool  getAgreementAgreeOrNotAgreeWithTypeArr:allAgreementArr.mutableCopy withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        STRONGSELF
        if (success) {
            AllAgreementUseModel *model = [AllAgreementUseModel mj_objectWithKeyValues:dic];
            //有协议的新版本 提示用户需要同意的大图
            if ( model.typeList.count > 0 ) {
                [strongSelf showPrivacyAgreenmentNewVersionWithNeedAgreeWithInfoModel:model];
                
            }
        }
    }];
    
    
    //
    [self chatSeverConnectionBeginGetNeedInfoAndFirstOpenSocketAction];//聊天相关未登录则需要重新请求
    //
    if (([ShareUserInfo sharedUserInfo].commuityInfo.ID != kNotHaveCommunityInfo_ID) && ([ShareUserInfo sharedUserInfo].commuityInfo.ID != 0)) {
        [self getNowCommunitySubHouseRightData];//用户在当前小区的权限
        [self topScrollViewBannerListData];//顶部主banner
        [self centerOneMenuListData];//菜单列表数据
        [self centerScrollViewUrgenMessageListData];//紧急消息
        //生活广场
        if (kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1) {//展示拼团数据
            // 是否开通小店查询
            [ZYSmallShopGoodsData isSmallShopGoodsOpen:^(id  _Nullable responsObject, BOOL success) {
                if (success) {
                    [self initPingTuanData];//拼团
                }
            }];
        }else{//租房二手数据
            [self zuFangListData];//生活广场_租房//    [self erShouListData];//生活广场_二手
            self.shengHuoGuangChagnSubCellHeaderTypeUseRefreshUpData = MainLateShengHuoGuangChangCell_TopHeader_Type_ZuFang;
        }
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mainTableView reloadData];
        });
    }
}
//
- (void)upJiGuangRegId{
    NSString *jgRId = [JGSaveIdShare sharedUserInfo].registrationID;
    NSString *url = [NSString stringWithFormat:@"%@?regId=%@",URL_PUT_JG_regId,jgRId ];//JiGuang_RegId
    [[ToolOfNetWork sharedTools]YrequestPutURLNoMainQueue:url withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {// "离线推送设备id设置成功";
        
    }];
}
- (void)getNowCommunitySubHouseRightData{
    if (isNil([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel)) {//空的时候的初始化
        [UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel = [[CommitRightAllDataModel alloc]init];
        [UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel = kNoAccessLevel;//初始权限999 底层， 1最高有房用户权限 0不能用于初值
    }else{//新请求时初始 防止切换小区状态下 新小区权限未获得时 使用了旧小区权限
        [UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel = kNoAccessLevel;//初始权限999 底层， 1最高有房用户权限 0不能用于初值

    }
    [NowCommunitySubHouseRightListDataReq nowCommunitySubHouseRight];
}

- (void)topScrollViewBannerListData{
    WEAKSELF
    [MainBannerListViewModel getTopBannerListDataWithListBlock:^(NSArray * arr) {
        STRONGSELF
        strongSelf.topSourceArr = [NSMutableArray arrayWithArray:[TableViewTopAndCenterBannerCellModel mj_objectArrayWithKeyValuesArray:arr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.mainTableView reloadData];
        });
    }];
}
//菜单list
- (void)centerOneMenuListData{
    if (kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1) {//敏捷版用同一个菜单列表接口
    }else{
    }
    WEAKSELF
    [MainCenterOneMenuListViewModel getCenterOneMenuListArrWithMenuBlockNew:^(NSMutableArray * arr) {
        STRONGSELF
        strongSelf.centerMenuSourceArr =  [NSMutableArray arrayWithArray:[MainCenterCollectionViewCellModel mj_objectArrayWithKeyValuesArray:arr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.mainTableView reloadData];
        });
    }];
}
- (void)centerScrollViewUrgenMessageListData{
    WEAKSELF
    [MainUrgentMessageListViewModel getCenterUrgentMessageListDataWithListBlock:^(NSArray * arr,BOOL success) {
        STRONGSELF
        if (success) {
            strongSelf.centeradvertScrollviewSourceArr = [NSMutableArray arrayWithArray:[TableViewTopAndCenterBannerCellModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.mainTableView reloadData];
            });
        }
    }];
}
- (void)footerLoadMoreNewsData{
    NSLog(@"------------footerRefres------------");
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mainTableView.mj_footer endRefreshing];
    });
    //
    if (self.shengHuoGuangChagnSubCellHeaderTypeUseRefreshUpData == MainLateShengHuoGuangChangCell_TopHeader_Type_ZuFang) {
        //加载更多 生活广场
        
        [HouseRentVCListViewModel  upDataRentVcHouseListArrToMainVcWithPageNum:self.bottomShengHuoGuangChangPageNum WithBlock:^(NSArray * arr, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView.mj_footer endRefreshing];
            });
            if (success) {
                if (arr.count>0) {
                    [self.zuFangArr addObjectsFromArray:[HouseRentListVcHouseCellModel mj_objectArrayWithKeyValuesArray:arr]];
                    self.bottomShengHuoGuangChangPageNum += 1;
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:SectionNum_LifeSquare];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    });
                }
            }
        }];
 
    }
    if (self.shengHuoGuangChagnSubCellHeaderTypeUseRefreshUpData == MainLateShengHuoGuangChangCell_TopHeader_Type_ErShou) {
        //加载更多 生活广场
        
        [MainShengHuoGuangChangListData updataErShouListWithPageNum:self.bottomShengHuoGuangChangPageNum withBlock:^(NSArray * arr, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.mainTableView.mj_footer endRefreshing];
            });
            if (success) {
                if (arr.count>0) {
                    [self.erShouArr addObjectsFromArray:[MainShengHuoGuangChangListErShouUseModel mj_objectArrayWithKeyValuesArray:arr]];
                    self.bottomShengHuoGuangChangPageNum += 1;
                    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:SectionNum_LifeSquare];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    });
                }
            }
        }];
    }
}
- (void)zuFangListData{//生活广场_租房
    self.bottomShengHuoGuangChangPageNum = 1;//初始化 重置
    DLog(@"______________租房______________");

    [HouseRentVCListViewModel  initRentVcHouseListArrToMainVcWithBlock:^(NSArray * arr, BOOL success) {
        if (success) {
            if (arr.count>0) {
                self.zuFangArr = [NSMutableArray arrayWithArray:[HouseRentListVcHouseCellModel mj_objectArrayWithKeyValuesArray:arr]];
                self.bottomShengHuoGuangChangPageNum += 1;
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:SectionNum_LifeSquare];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    self.mainTableView.mj_footer.hidden = NO;
                });
            }
        }
    }];
   
}
- (void)erShouListData{//生活广场_二手
    self.bottomShengHuoGuangChangPageNum = 1;//初始化 重置
    DLog(@"______________二手______________");
    
    [MainShengHuoGuangChangListData initErShouListWithBlock:^(NSArray * arr, BOOL success) {
        if (success) {
            if (arr.count>0) {
                self.erShouArr = [NSMutableArray arrayWithArray:[MainShengHuoGuangChangListErShouUseModel mj_objectArrayWithKeyValuesArray:arr]];
                self.bottomShengHuoGuangChangPageNum += 1;
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:SectionNum_LifeSquare];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    self.mainTableView.mj_footer.hidden = NO;
                });
            }
        }
    }];
}

// 加载拼团数据
- (void)initPingTuanData{
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLPostNotMainQueue:ZY_BASEURL(kSmallShopSpellGroupDetailUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    ZYSmallShopGoodsSpellGroupDetailModel *model = [ZYSmallShopGoodsSpellGroupDetailModel yy_modelWithJSON:responsObject[@"data"]];
                    self.spellGroupModel = model;
                    [self.mainTableView reloadData];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}
 
#pragma mark === UI
- (void)initNav{
    
    _cityItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cityItem setImage:[UIImage imageWithColor:[UIColor blueColor]] forState:UIControlStateNormal];
    [_cityItem setImage:[UIImage imageNamed:@"Head_Positioning_night"] forState:UIControlStateNormal];//Head_Positioning_night  main_Top_positioning
    _cityItem.titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    [_cityItem setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
    _cityItem.titleLabel.textAlignment = NSTextAlignmentLeft;
    _cityItem.titleLabel.font = [UIFont systemFontOfSize:14];
    _cityItem.frame = CGRectMake(0 , 0, Screen_W*0.5, 24);
    [_cityItem addTarget:self action:@selector(cityChooseAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *cityBarItem = [[UIBarButtonItem alloc]initWithCustomView:_cityItem];
    [self.navigationItem setLeftBarButtonItem:cityBarItem];
    
    _scanningItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scanningItem setImage:[UIImage imageNamed:@"Head_Sweepit_night"] forState:UIControlStateNormal];//Head_Sweepit_night  main_Top_scan
    _scanningItem.bounds = CGRectMake(0 , 0, 34, 24);
    [_scanningItem addTarget:self action:@selector(scanningItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *scanningItemBar = [[UIBarButtonItem alloc]initWithCustomView:_scanningItem];
    
    _infoItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [_infoItem setImage:[UIImage imageNamed:@"head_news_night"] forState:UIControlStateNormal];//head_news_night@3x Head_News_Default_content_night@3x main_Top_message
    [_infoItem setImage:[UIImage imageNamed:@"Head_News_Default_content_night"] forState:UIControlStateSelected];
//    infoItem.selected = YES;//红点的
    _infoItem.bounds = CGRectMake(0 , 0, 34, 24);
    [_infoItem addTarget:self action:@selector(infoItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoItemBar = [[UIBarButtonItem alloc]initWithCustomView:_infoItem];
    
//    [self.navigationItem setRightBarButtonItems:@[scanningItemBar,infoItemBar]];
    [self.navigationItem setRightBarButtonItems:@[infoItemBar,scanningItemBar]];
    
}
- (void)navBtnsChangeColor{
    //主题色更新后willapper时用
    [_cityItem setImage:[[UIImage imageNamed:@"Head_Positioning_night"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _cityItem.imageView.tintColor =  [ThemeManager shareManager].mainTextColor;//源图附色
    _cityItem.titleLabel.textColor = [ThemeManager shareManager].mainTextColor;
    //
    [_scanningItem setImage:[[UIImage imageNamed:@"Head_Sweepit_night"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _scanningItem.imageView.tintColor =  [ThemeManager shareManager].mainTextColor;//源图附色
    //
    [_infoItem setImage:[[UIImage imageNamed:@"head_news_night"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    _infoItem.imageView.tintColor =  [ThemeManager shareManager].mainTextColor;//源图附色
    
    //数据未更新则自行处理城市颜色
    [self.cityItem setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
 
}
- (void)initView{
    [self.view addSubview:self.backImgView];
    [self.view addSubview:self.mainTableView];
    
    if (kMYAPP_Now_IS_HIDDEN_MORE_INDEX==1) {
        //隐藏不出现
    }else{
        [self initMianBottomRightBtnView];//右下悬浮按钮
    }
    [self setUI];
    [self addRefresh];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerInitData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMoreNewsData)];
    self.mainTableView.mj_header = headeerRefresh;
    self.mainTableView.mj_footer = footerRefresh;
    self.mainTableView.mj_footer.hidden = YES;
}
- (void)setUI{
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backImgView.superview);
    }];
    [_mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_mainTableView.superview.mas_top).offset(0);
        make.left.equalTo(_mainTableView.superview.mas_left).offset(16);
        make.right.equalTo(_mainTableView.superview.mas_right).offset(-16);
        make.bottom.equalTo(_mainTableView.superview.mas_bottom).offset(-KTabBarHeight);
    }];
}
#pragma mark ==== topScollview 第一 主滚动视图
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    if (cycleScrollView.tag == MainTopCycleScrollView_TAG) {
        NSLog(@" 顶部滚动图点击了 %ld  ==== cycleScrollView ",(long)index);
        
        ZYBannerDetailVc *vc = [[ZYBannerDetailVc alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
}
#pragma mark === 判定是否需要弹出登录vc或绑定vc
- (BOOL)shouldShowLoginVcOrBindVcBool{
    WEAKSELF
    STRONGSELF
    if ([IsLoginTool share].save_Login_Type==IS_Login_Tourists) {
        //登录view
        [[IsLoginTool share]willPresentLoginViewControllerWithLoginVCBlock:^(UINavigationController * _Nonnull navc) {
                navc.modalPresentationStyle = UIModalPresentationFullScreen;
                [strongSelf presentViewController:navc animated:YES completion:^{
                    NSLog(@"present弹出登录vc");
                }];
        }];
        return YES;
  
    } else if( [IsLoginTool share].save_Login_Type==IS_Login_UnboundPhone){
        //用三方ID绑定电话
        //苹果 绑定手机操作
        AppleLoginModel *model = [[AppleLoginModel alloc]init];
        model.thirdPlatformId = [IsLoginTool share].appleLoginSaveThridIdWillUseToBindPhone;
        //
        BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
        bindVc.appleUserModel = model;
        bindVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:bindVc animated:YES];
        return YES;
    }
    return NO;
}

#pragma mark ==== CenterMenu ViewDelegate 菜单
- (void)topMenuViewCollectionCellDidSelectWithItem:(NSIndexPath *)indexPath{
    if (indexPath.row != self.centerMenuSourceArr.count) {//更多按钮 需要能点击跳转
        if ([self shouldShowLoginVcOrBindVcBool]) {
            return;
        }
    }
    //更多
    if (indexPath.row == self.centerMenuSourceArr.count) {
        NSLog(@"center_menu点击了 更多");
    
        MoreMenuVC *moreMenuVc = [[MoreMenuVC alloc]init];
        moreMenuVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:moreMenuVc animated:YES];
    }else{
        //_____________新
        MainCenterCollectionViewCellModel *model = self.centerMenuSourceArr[indexPath.row];
        NSInteger willPushVcNum_New = [MoreMenuChooseVCType getNewMenuChooseVcWithPathStr:model.path];
        switch (willPushVcNum_New) {
            case Menu_choose_Notice:
            {
                //游客和未绑定手机 则总消息按钮不可点击
                if ([self shouldShowLoginVcOrBindVcBool]) {
                    return;
                }
//                //不走社区总消息列表 跳转当前社区紧急消息列表
//                [self urgentMoreBtnAction];
                
//                //test 车辆
//                MyCarListInfoVC *vc = [[MyCarListInfoVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self pushVc:vc];
//                // 问卷调查
//                ZYQuestionnaireSurveyVc *vc = [[ZYQuestionnaireSurveyVc alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self pushVc:vc];
//                // 社区集市(新)
//                ZYCommunityFairLateVc *vc = [[ZYCommunityFairLateVc alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self pushVc:vc];
                // 闲置商品发布
                ZYCommunityFairIssueVc *vc = [[ ZYCommunityFairIssueVc alloc] init];
                vc.type = ZYCommunityFairIssue_Type_Add;
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
//                //活动
//                ActivityListVC *vc = [[ActivityListVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self pushVc:vc];
            }
                break;
            case Menu_choose_Property:
            {
 
                //判定弹出登录或者绑定手机
                if ([self shouldShowLoginVcOrBindVcBool]) {
                    return;
                }
                NSLog(@"生活缴费");////更换到物业缴费列表 不再走生活缴费界面
           
                //判定业主家属租客身份
                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                    return;;
                }
                LifeCostMainVC *vc = [[LifeCostMainVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
                break;
            case Menu_choose_Advice:
            {
                DLog(@"投诉建议");
//                ComplaintsSuggestionsVC *vc = [[ComplaintsSuggestionsVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self pushVc:vc];
                //判定业主家属租客身份
                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                    return;
                }
                ZYComplaintsOpinionVC *vc = [[ZYComplaintsOpinionVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
                break;
            case Menu_choose_Activity:
            {
                DLog(@"活动报名")
                //判定业主家属租客身份
                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                    return;;
                }
                ZYActivityApplyVC *vc = [[ZYActivityApplyVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
                break;
            case Menu_choose_Lease:
            {
                DLog(@"租房")
                HouseRentVC *rentVc = [[HouseRentVC alloc]init];
    //            rentVc.viewType = MainCellRecommendedServiceHourse_Type_BusinessShop;
                rentVc.viewType = MainCellRecommendedServiceHourse_Type_RentHouse;
                rentVc.hidesBottomBarWhenPushed = YES;
                [self pushVc:rentVc];
            }
                break;
            case Menu_choose_Bbazaar:
            {
                DLog(@"社区集市")
                //判定业主家属租客身份
                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                    return;;
                }
                ZYCommunityFairVC *vc = [[ZYCommunityFairVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
                break;
            case Menu_choose_Vote:
            {
                DLog(@"业主投票")
                //判定弹出登录或者绑定手机
                if ([self shouldShowLoginVcOrBindVcBool]) {
                    return;
                }
                //判定业主家属租客身份
                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 1) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                    return;;
                }
                //跳转
                ZYOwnersVoteVC *vc = [[ZYOwnersVoteVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
                break;
            case Menu_choose_Shop:
            {
                //判定弹出登录或者绑定手机
                if ([self shouldShowLoginVcOrBindVcBool]) {
                    return;
                }
                //判定业主家属租客身份
                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                    return;;
                }
                NSLog(@"周边店铺 总商城");
                MedicalWebViewVc *vc = [[MedicalWebViewVc alloc]init];
                vc.selfInitType = MedicalWebViewVc_ShowInitType_BaseShoppingMain;
                vc.hidesBottomBarWhenPushed = YES; 
                [self pushVc:vc];
            }
                break;
            case Menu_choose_SeniorLifeMainActivity:
            { //判定弹出登录或者绑定手机
                if ([self shouldShowLoginVcOrBindVcBool]) {
                    return;
                }
                //判定业主家属租客身份
                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                    return;;
                }
                NSLog(@"社区养老");
                ZYPensionRootTabBarVC *vc = [[ZYPensionRootTabBarVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
                break;
            case Menu_choose_MedicalMainActivity:
            { //判定弹出登录或者绑定手机
                if ([self shouldShowLoginVcOrBindVcBool]) {
                    return;
                }
                //判定业主家属租客身份
                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                    return;;
                }
                NSLog(@"社区医疗");
                ZYMedicalRootTabBarVC *vc = [[ZYMedicalRootTabBarVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
                break;
            case  Menu_choose_Hotline:
            {
                [self showHouLinePopV];
            }
                break;
                
            case  Menu_choose_SmallShop:
            {
                NSLog(@"社区小店");
                //判定业主家属租客身份
                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                    return;;
                }
                if (ZY_IsSmallShopGoodsOpen) {
                    ZYSmallShopMainVC *vc = [[ZYSmallShopMainVC alloc] init];
                    vc.hidesBottomBarWhenPushed = YES;
                    [self pushVc:vc];
                }else {
                    [ZYProgressHUDTool showCustomHUDTextMessage:@"本小区暂未开放" toView:self.view];
                }
            }
                break;
            case  Menu_choose_PakingCar:
            {
                NSLog(@"停车缴费");
                //判定业主家属租客 游客等身份
                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                    return;;
                }
                // 智能停车（新）
                ZYParkingVcLate *vc = [[ZYParkingVcLate alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
//                //停车缴费 相关
//                ParkingVcLate *vc = [[ParkingVcLate alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self pushVc:vc];
                
            }
                break;
            
            default:
                DLog(@"Menu_choose_NoThing");
                break;
        }
    }
    
}

#pragma mark ==   扫一扫
- (void)scanAction{
    WEAKSELF
    ScanQRViewController *vc = [[ScanHelper shareInstance] ScanVCWithStyle:qqStyle qrResultCallBack:^(id result) {
        BaseViewController *vc = [[BaseViewController alloc] init];
        vc.title = [NSString stringWithFormat:@"%@",result];
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        NSLog(@"result=%@", result);
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ==  更多社区服务正在逐步开放中
- (void)showPopViewWithMoreServiceWillBeOpen{
    [self.popViewMoreServiceWillOpening showInView:self.view thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
}
#pragma mark == 右下角 按钮 弹出的其他点击协议

- (void)popViewOtherFunctionSubTouchPopViewWithOtherFunction:(PopViewWithOtherFunction_Type)type{

    self.mainVcBottomRightBtn.selected = NO;
    switch (type) {
        case PopViewWithOtherFunction_Type_DisMissPopView:
        {
        }
            break;
        case PopViewWithOtherFunction_Type_forum://论坛
        {
            DLog(@"论坛");
            [self showPopViewWithMoreServiceWillBeOpen];
        }
            break;
        case PopViewWithOtherFunction_Type_shortvideo://短视频
        {
            DLog(@"短视频");
            [self showPopViewWithMoreServiceWillBeOpen];
        }
            break;
        case PopViewWithOtherFunction_Type_chat://聊天
        {
            DLog(@"聊天");
 
            if ([self shouldShowLoginVcOrBindVcBool]) {
                return;
            }
            ZYChatRootTabBarVc *vc = [[ZYChatRootTabBarVc alloc] init];
            //设置模态视图弹出样式
            vc.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:vc animated:YES completion:nil];
//
        }
            break;
        case PopViewWithOtherFunction_Type_fleaMarket://跳蚤市场
        {
            DLog(@"跳蚤市场");
            [self showPopViewWithMoreServiceWillBeOpen];

        }
            break;
            
        default:
            break;
    }
}
#pragma mark == 未实名认证的popView
- (void)notGoRealCertificationPopViewShow{
    [self.popViewGotoCertification showInView:self.view thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
}
- (void)popViewBtnActionWithGoToRealCertificationAction{
    DLog(@"去认证");
    ElectroniNewRealNameAuthenticationCardVc *vc = [[ElectroniNewRealNameAuthenticationCardVc alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
#pragma mark ==== 紧急消息
- (void)advertScrollView:(SGAdvertScrollView *)advertScrollView didSelectedItemAtIndex:(NSInteger)index{
    if (advertScrollView.tag == MainCenterAdvertScrollView_TAG) {
        UrgentInfoOrTopInfoDetailVC *detailVc = [[UrgentInfoOrTopInfoDetailVC alloc]init];
        TableViewTopAndCenterBannerCellModel *model =  self.centeradvertScrollviewSourceArr[index];
        detailVc.communityId =  [ShareUserInfo sharedUserInfo].commuityInfo.ID;//当前小区id
        detailVc.infoId = model.id;
        detailVc.hidesBottomBarWhenPushed = YES;
        [self pushVc:detailVc];
    }
}
//紧急消息 跳转 列表页面
- (void)urgentMoreBtnAction{
    MoreUrgentListVC *vc = [[MoreUrgentListVC alloc]init];
    vc.isTopInfoVcDetailListVc = NO;
    vc.dataSourceArr = self.centeradvertScrollviewSourceArr;//dataarr暂不需要了
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
#pragma mark ==== 我的服务
- (void)mySeverSectionGoSubVcWith:(MyServiceSubCollectionViewCell_Type)type{
    NSLog(@" 我的服务 mySeverSectionGoSubVcWith type:%lu",(unsigned long)type);
    //业主家属租客身份判定——————暂时都可以跳转
    //——————游客判定非登陆状态----不可
    //游客和未绑定手机 则总消息按钮不可点击
    if ([self shouldShowLoginVcOrBindVcBool]) {
        return;
    }
    switch (type) {
        case MyServiceSubCollectionViewCell_Type_Repair:
        {
            NSLog(@" center_menu  一键报修");
            //判定业主家属租客 游客等身份
            if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
        
                return;;
            }
//            HouseRepairListVC *vc = [[HouseRepairListVC alloc]init];
//            HouseRepairMainPageVC *vc = [[HouseRepairMainPageVC alloc]init];
//            vc.hidesBottomBarWhenPushed = YES;
//            [self pushVc:vc];
            
            ZYHouseRepairIssueVc *vc = [[ZYHouseRepairIssueVc alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }
            break;
        case MyServiceSubCollectionViewCell_Type_Visitor:
        { //访客邀请
            //判定业主家属租客 游客等身份
            if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                return;;
            }
            GuestInfoRegistionVC *vc = [[GuestInfoRegistionVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self pushVc:vc];
        }
            break;
        case MyServiceSubCollectionViewCell_Type_WuYe:
        {
          
            //判定业主家属租客 游客等身份
            if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                return;;
            }
            if (kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1) {
//                LifeCostPropertyFeeListVc *vc =[[LifeCostPropertyFeeListVc alloc]init];//物业缴费主列表
                LifeCostPropertyFeeListLateVc *vc = [[LifeCostPropertyFeeListLateVc alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }else{
                //物业管家
                MyHousekeeperVC *vc = [[MyHousekeeperVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self pushVc:vc];
            }
           
        }
            break;
            
        default:
            break;
    }
}
#pragma mark ==== 租房详情 二手详情
- (void)shengHuoGuangChangWithRowNum:(NSInteger)rowNum withType:(MainLateShengHuoGuangChangCell_TopHeader_Type)type{
    DLog(@"租房详情 二手详情 %ld %lu",rowNum ,(unsigned long)type);
 
     if (type == MainLateShengHuoGuangChangCell_TopHeader_Type_ZuFang) {
         //租赁房屋详情
         HouseRentListVcHouseCellModel *model = self.zuFangArr[rowNum];
         HouseRentHouseDetailVc *houseDetailVc = [[HouseRentHouseDetailVc alloc]init];
         houseDetailVc.IDNum = model.ID;
         houseDetailVc.hidesBottomBarWhenPushed = YES;
         [self pushVc:houseDetailVc];
     }else{
         //二手商品详情
         MainShengHuoGuangChangListErShouUseModel *model = self.erShouArr[rowNum];
         ZYCommunityFairDetailVC *vc = [[ZYCommunityFairDetailVC alloc]init];
         vc.ID = model.idStr; 
         vc.hidesBottomBarWhenPushed = YES;
         [self pushVc:vc];
    }
  

}

#pragma mark ==== tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return MainVcSectionAllNum;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == SectionNum_Top) {
        return 3;
    }else if(section == SectionNum_MyService){//我的服务
        return 1;
    }else if (section == SectionNum_LifeSquare) {//生活广场
        return 1;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == SectionNum_Top) {
        return 1;
    }else if(section == SectionNum_MyService){//我的服务
        return mainTableViewCell_Height_cell_HeaderView;
    }else if (section == SectionNum_LifeSquare) {//生活广场
        return mainTableViewCell_Height_cell_HeaderView;
    }else{
        return 0.1;
    }
  
}

- (void)headerTitleStr{
    self.headerViewRightTextArr = [[NSMutableArray alloc]initWithObjects:@"",@"我的服务",@"生活广场",@"推荐服务", nil];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    [self headerTitleStr];
    MainSectionHeaderViewTextLabel *headerViewTextLabel = [[MainSectionHeaderViewTextLabel alloc]initWithFrame:CGRectMake(0, 0,Screen_W-32, 20)];
    NSArray *headerTextArr = self.headerViewRightTextArr;//
    headerViewTextLabel.text = headerTextArr[section];
    if (headerTextArr.count-1==section) {
        headerViewTextLabel.userInteractionEnabled = YES;
        headerViewTextLabel.rightBtnFunCellSectionHeaderWillShow.hidden = NO;
        [headerViewTextLabel.rightBtnFunCellSectionHeaderWillShow addTarget:self action:@selector(funMoreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        headerViewTextLabel.rightBtnFunCellSectionHeaderWillShow.hidden = YES;//更多按钮隐藏掉
    }else{
        headerViewTextLabel.rightBtnFunCellSectionHeaderWillShow.hidden = YES;
    }
    
    return headerViewTextLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionNum_Top) {
        if(indexPath.row == RowNum_TopScrollBanner){
            return mainTableViewCell_Height_cell_topRollingView;
        }else if(indexPath.row == RowNum_TopMenuAll){
            //菜单
            if (kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1) {//敏捷版4个每行
                if (self.centerMenuSourceArr.count>4) {
                    return  mainTableViewCell_Height_cell_TopMenuCell;//菜单最多两行高度
                }else{
                    return mainTableViewCell_Height_cell_TopMenuCell*0.5;
                }
            }else{//普通版5个每行
                if (self.centerMenuSourceArr.count>5) {
                    return  mainTableViewCell_Height_cell_TopMenuCell;//菜单最多两行高度
                }else{
                    return mainTableViewCell_Height_cell_TopMenuCell*0.5;
                }
            }
         
         
        }else if (indexPath.row == RowNum_TopJingJIInfoScrollBanner) {
            return mainTableViewCell_Height_cell_centerRollingView;
        }else{
            return 1;
        }
    }else if (indexPath.section == SectionNum_MyService){
        return mainTableViewCell_Height_cell_topRollingView;
        
    }else if (indexPath.section == SectionNum_LifeSquare){

        if (kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1) {//拼团
            if (isNotNil(self.spellGroupModel)) {
                return mainTableViewCell_Height_PingTuan;
            }else {
                return mainTableViewCell_NoDataHeight_PingTuan;
            }
        }else{
            //租赁+二手的 高度回调后的刷新用数据
            
            if ( self.bottomCellH <= 20+kTabBarHeight) {
                return (20+kTabBarHeight +10);//10的间
            }
            return self.bottomCellH;
        }
      
    }else{
        return 1;
    }
     
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == SectionNum_Top) {
        return [self oneSectionWithtableView:tableView cellForRowAtIndexPath:indexPath];
//    }else if (indexPath.section == SectionNum_MyService){
//        return [self recommendedServiceSectionWithtableView:tableView cellForRowAtIndexPath:indexPath];
//    }else if (indexPath.section == RowNum_YangLaoYiLiao){
//        return [self yanglaoAndYiLiaoSectionWithtableView:tableView cellForRowAtIndexPath:indexPath];
    }else if (indexPath.section == SectionNum_LifeSquare){
        return [self shengHuoGuangChangSectionWithtableView:tableView cellForRowAtIndexPath:indexPath];
    }else{
        return [self mySeverSectionWithtableView:tableView cellForRowAtIndexPath:indexPath];
    }
}
 
- (UITableViewCell *)oneSectionWithtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == RowNum_TopScrollBanner){//顶部滚动banner
        MainTableViewTopBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_top_BannerScrollView_Identifier];
        if (!cell) {
            cell = [[MainTableViewTopBannerCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:mainTableViewCell_top_BannerScrollView_Identifier];
        }
        cell.cycleScrollView.delegate = self;
        cell.dataSource = self.topSourceArr;
        return cell;
    }else if(indexPath.row == RowNum_TopMenuAll){//菜单
        MainTableViewTopMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_TopMenuCell_Identifier];
        if (!cell) {
            cell = [[MainTableViewTopMenuCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:mainTableViewCell_TopMenuCell_Identifier];
        }
//        else{
//            while ( [cell.contentView.subviews lastObject] != nil) {
//                [(UIView*) [cell.contentView.subviews lastObject] removeFromSuperview];
//            }
//        }
        cell.delegate = self;
        cell.sourceArr = self.centerMenuSourceArr;
    
        return cell;
    }else  if (indexPath.row == RowNum_TopJingJIInfoScrollBanner) {//紧急消息
        MainTableViewCenterBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_cneter_BannerScrollView_Identifier];
        if (!cell) {
            cell = [[MainTableViewCenterBannerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mainTableViewCell_cneter_BannerScrollView_Identifier];
        } 
        cell.advertScrollView.delegate = self;
        [cell.rightMoreBtn addTarget:self action:@selector(urgentMoreBtnAction) forControlEvents:UIControlEventTouchUpInside];
        cell.dataSource = self.centeradvertScrollviewSourceArr;
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_Identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:mainTableViewCell_Identifier];
        }
        return cell;
    }
}
- (UITableViewCell *)mySeverSectionWithtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainLateMyServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_MainLateMyServiceCell_Identifier];
    if (!cell ) {
        cell = [[MainLateMyServiceCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:mainTableViewCell_MainLateMyServiceCell_Identifier];
    }
    
    WEAKSELF
    cell.touchSubCellBlock = ^(NSInteger itemNum) {
        [weakSelf mySeverSectionGoSubVcWith:itemNum];
    };
    return cell;
}


- (UITableViewCell *)shengHuoGuangChangSectionWithtableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1) {
        ZYCommunityManagementMainSpellGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_PingTuan_Identifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = self.spellGroupModel;
        
        return cell;
    }else{
        MainLateShengHuoGuangChangCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableViewCell_ShengHuoGuangChangCell_Identifier];
        if (!cell) {
            cell = [[MainLateShengHuoGuangChangCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:mainTableViewCell_ShengHuoGuangChangCell_Identifier];
        }
        //
        if (self.shengHuoGuangChagnSubCellHeaderTypeUseRefreshUpData == MainLateShengHuoGuangChangCell_TopHeader_Type_ZuFang) {
            [cell fillShengHuoGuangChangWithZuFangArr:self.zuFangArr];
        }
        if (self.shengHuoGuangChagnSubCellHeaderTypeUseRefreshUpData == MainLateShengHuoGuangChangCell_TopHeader_Type_ErShou) {
            [cell fillShengHuoGuangChangWithErShouArr:self.erShouArr];
        }
        //

        WEAKSELF
        cell.getMainSubCellShowHeightBlock = ^(CGFloat subShowH) {//刷新本组 做高度更改
            weakSelf.bottomCellH = subShowH;
            //延时做刷新 防止cell重叠
            [weakSelf performSelector:@selector(getNewHeightWithReloadThisView) withObject:nil afterDelay:0.5];
        };
        //header
        cell.touchTopHeaderBtnBlock = ^(MainLateShengHuoGuangChangCell_TopHeader_Type showHeaderType) {
            weakSelf.shengHuoGuangChagnSubCellHeaderTypeUseRefreshUpData = showHeaderType;
            if (showHeaderType == MainLateShengHuoGuangChangCell_TopHeader_Type_ZuFang) {
                [weakSelf zuFangListData];
            }
            if (showHeaderType == MainLateShengHuoGuangChangCell_TopHeader_Type_ErShou) {
                [weakSelf erShouListData];
            }
        };
        //subcell
        cell.touchSubCellBlock = ^(NSInteger rowNum,  MainLateShengHuoGuangChangCell_TopHeader_Type showHeaderType) {
            [weakSelf shengHuoGuangChangWithRowNum:rowNum withType:showHeaderType];
        };
        return cell;
    }

}
- (void)getNewHeightWithReloadThisView{
    [self.mainTableView beginUpdates];//只刷新高度 不做cell内容刷新
    [self.mainTableView  endUpdates];
    [self.mainTableView reloadData];//会有大的刷新折叠型态 但是能刷新完全
}
 
#pragma mark ====
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H) style:UITableViewStyleGrouped];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [UIView new];
        _mainTableView.tableHeaderView = [UIView new];
//        [_mainTableView setTableHeaderView:self.tableViewHeaderView];//搜索框不要了
        _mainTableView.tag = MainTableView_TAG;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTableView.backgroundColor = [UIColor clearColor];
        _mainTableView.delaysContentTouches = NO;
        _mainTableView.showsHorizontalScrollIndicator = NO;
        _mainTableView.showsVerticalScrollIndicator = NO;
        _mainTableView.bounces = YES;
        [_mainTableView registerNib:[UINib nibWithNibName:mainTableViewCell_PingTuan_Identifier bundle:nil] forCellReuseIdentifier:mainTableViewCell_PingTuan_Identifier];
    }
    return _mainTableView;
}

#pragma mark ==
- (void)showHouLinePopV{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"服务热线" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.backgroundColor = [UIColor whiteColor];
    alertController.view.layer.cornerRadius = 5;
    alertController.view.layer.masksToBounds = YES;
    alertController.view.bounds = CGRectMake(0, 0, alertController.view.bounds.size.width, 280);
    //
    UIView *alertBackView = [[UIView alloc] init];//back
    alertBackView.backgroundColor = [alertController.view.backgroundColor colorWithAlphaComponent:0.8];
//    alertBackView.layer.cornerRadius = 5;
//    alertBackView.layer.masksToBounds = YES;
    //
    UILabel *alertNameL = [[UILabel alloc]init];
    alertNameL.textColor = [UIColor blackColor];
    alertNameL.font = [UIFont boldSystemFontOfSize:20];
    alertNameL.textAlignment = NSTextAlignmentCenter;
    alertNameL.text = Hot_Photos;
    [alertBackView addSubview:alertNameL];
    //
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [callBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
    [callBtn newAnBtnWithTextStr:@"立即拨打"];
    [callBtn newAnBtnWithBackColor:Color_38BlueColor];
    [callBtn newAnBtnWithLayerCorNerNum:5 withLayerLineWidth:0 withLayerLineColor:Color_38BlueColor];
    [callBtn addTarget:self action:@selector(callBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [alertBackView addSubview:callBtn];
    //
    [alertNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertNameL.superview).offset(10);
        make.left.equalTo(callBtn.superview.mas_left).offset(10);
        make.right.equalTo(alertNameL.superview).offset(-10);
        make.height.offset(20);
    }];
    [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertNameL.mas_bottom).offset(20);
        make.left.equalTo(callBtn.superview.mas_left).offset(10);
        make.right.equalTo(callBtn.superview.mas_right).offset(-10);
        make.height.offset(40);
    }];
    //
    [alertController.view addSubview:alertBackView];
    [alertBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertBackView.superview).offset(60);
        make.left.equalTo(alertBackView.superview).offset(0);
        make.right.equalTo(alertBackView.superview).offset(0);
        make.height.offset(100);
    }];
    //占位
    UIAlertAction *centerZanWeiOneAlertAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *centerZanWeiTwoAlertAction = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:nil];

    //
    UIAlertAction *bottomKnowAlertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:centerZanWeiOneAlertAction];
    [alertController addAction:centerZanWeiTwoAlertAction];
    [alertController addAction:bottomKnowAlertAction];
    //
    alertController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)callBtnAction:(UIButton *)sender{
    NSString *phoneStr = Hot_Photos;//热线服务号码
    [self callPhoneWithStr:phoneStr];
}

- (void)callPhoneWithStr:(NSString *)phoneStr{
 
    NSMutableString *callStr=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneStr];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callStr] options:@{} completionHandler:nil];
}
 
#pragma mark == 总消息
- (void)infoItemAction{
    //游客和未绑定手机 则总消息按钮不可点击
    if ([self shouldShowLoginVcOrBindVcBool]) {
        return;
    }
    //21主页顶部消息跳转走通知消息 不走本社区总消息
   /**
    TopInformationVC *vc = [[TopInformationVC alloc]init];
    */
    MainAllTypeInformationVC *vc = [[MainAllTypeInformationVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
 
}
#pragma mark == 扫描
- (void)scanningItemAction{
    NSLog(@"扫描");
//    [self showPopViewWithMoreServiceWillBeOpen];
    
    __weak typeof(self) weakSelf = self;
    ScanQRViewController *vc = [[ScanHelper shareInstance] ScanVCWithStyle:ZhiFuBaoStyle qrResultCallBack:^(id result) {
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        DLog(@"result=%@", result);
        [weakSelf scanGetDataStr:result];
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
 
 
- (void)scanGetDataStr:(NSString *)result{
    //登录和绑定手机
    if ([self shouldShowLoginVcOrBindVcBool]) {
        return;
    }
 
    DLog(@"");
    if ([result containsString:URL_UserBangDingFamileOrRentUseJudgeHttpHeaderStr] && [result containsString:@"id"] && [result containsString:@"mobile"]) {
        [self gotoBindFamileOrRentPersonWithStr:result];
        
    }else if ([result containsString:@"name"]){//name ImId
       
        ZYChatRootTabBarVc *vc = [[ZYChatRootTabBarVc alloc] init];
        //设置模态视图弹出样式
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        Y_SVP_SHOW_INFO_MES(@"当前二维码不能匹配任意功能，请扫描本App可以使用的二维码！");
        DLog(@"其他 scanGetDataStr %@ ",result);
    }
}
//绑定家属租客的确认
- (void)gotoBindFamileOrRentPersonWithStr:(NSString *)result{
    NSString *getUrlStr = result;// 1021全部url判断后直接赋予给跳转页 不做拼接了 截取后只用来判断电话是本用户电话
    NSString *phoneS = @"";
    NSString *idStr = @"";
    //
    NSArray *resComOneArr = [result componentsSeparatedByString:@"?"];
    NSString *notBaseIsInfoStr =  [NSString stringWithFormat:@"%@",resComOneArr.lastObject];
    NSArray *resComTwoArr = [notBaseIsInfoStr componentsSeparatedByString:@"&"];
    NSString *idKeyObjStr = [NSString stringWithFormat:@"%@",resComTwoArr.firstObject];
    NSString *phoneKeyObjStr = [NSString stringWithFormat:@"%@",resComTwoArr.lastObject];
    //
    idStr = [NSString stringWithFormat:@"%@",([idKeyObjStr componentsSeparatedByString:@"="].lastObject)];
    phoneS = [NSString stringWithFormat:@"%@",([phoneKeyObjStr componentsSeparatedByString:@"="].lastObject)];
    //
    NSString *bindUserPhoneStr = phoneS;//@"18012345678";//
    if (![bindUserPhoneStr isEqualToString: [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.mobile]]) {
        Y_SVP_SHOW_ERR_MES(@"用户手机号与本数据不匹配，不能做绑定！");
        return;
    }
    //实名
    if (!ZY_IsRealName) {
        ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.otherShowDetailStr = nomalGotoRealNameShowStr;
        [self pushVc:vc];
        return;
    }
    //
    InformationOrScanGoToWebVc *vc = [[InformationOrScanGoToWebVc alloc]init];
    /** 1021 不做每个键值的拼接 只做url的全部赋过去
     */
    vc.httpAllUseStr = getUrlStr;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

#pragma mark - ZYCommunityManagementMainSpellGroupCellDelegate
- (void)contentVEvent {
    NSLog(@"拼团");
    if (isNotNil(self.spellGroupModel)) {
        ZYSmallShopGoodsSpellGroupDetailVc *vc = [[ZYSmallShopGoodsSpellGroupDetailVc alloc] init];
        vc.model = self.spellGroupModel;
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
}

#pragma mark -  大视图view UIWindow上层显示

//____________________________________________________________________________ app版本
- (void)showSignUpdataViewWithShowStr:(NSString *)showStr{
    dispatch_async(dispatch_get_main_queue(), ^{
        SignShowOfGoToTheStoreToUpdateTheVersion *signShowOfGoToTheStoreToUpdateTheVersion =  [[SignShowOfGoToTheStoreToUpdateTheVersion alloc]initWithFrame:CGRectZero];
        signShowOfGoToTheStoreToUpdateTheVersion.tag = signShowOfGoToTheStoreToUpdateTheVersion_Tag;
        [signShowOfGoToTheStoreToUpdateTheVersion fillInfoOfStr:showStr];
        // 当前顶层窗口
        UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        for (UIView *windowSubView in window.subviews) {
            if (windowSubView.tag == signShowOfGoToTheStoreToUpdateTheVersion_Tag) {//防止重复添加
                return;
            }
        }
        // 添加到窗口
        [window addSubview:signShowOfGoToTheStoreToUpdateTheVersion];
    });
 
}
//____________________________________________________________________________协议版本

- (void)showPrivacyAgreenmentNewVersionWithNeedAgreeWithInfoModel:(AllAgreementUseModel *)model{
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView *needAgreeShowView =  [[PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView alloc]initWithFrame:CGRectZero];
        needAgreeShowView.tag = PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView_Tag;
        [needAgreeShowView fillNewPrivacyAgreementUserAgreementVersionInfo:model];
        needAgreeShowView.notAgreeActionBlock = ^{
            [weakSelf exitAction];
        };
        
        __weak PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView *needAgreeShowViewUseBlock = needAgreeShowView;
        needAgreeShowView.gotoPrivacyAgreementVcBlock = ^(PrivacyAgreementVCLate * _Nonnull vc) {
            dispatch_async(dispatch_get_main_queue(), ^{
                vc.hidesBottomBarWhenPushed = YES;
               //UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
                UIWindow *window = ([UIApplication sharedApplication].delegate).window;
                [window.rootViewController presentViewController:vc animated:YES completion:^{
                    [needAgreeShowViewUseBlock bringSubviewToFront:vc.view]; //在视图上面

                }];

                
//                DLog(@"非全屏的协议展示vc");
                /**
                 * //[needAgreeShowViewUseBlock bringSubviewToFront:vc.view]; //在视图上面
                 UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
                 for ( UIView *windowSubView in window.subviews) {
                     if (windowSubView.tag == PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView_Tag) {
                         PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView* bringUseView = (PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView *)windowSubView;
                         [window.rootViewController  presentViewController:vc animated:YES completion:^{
                             [bringUseView bringSubviewToFront:vc.view]; //在视图上面
                         }];
                         return;
                     }
                    

                 }
                 */
               
                
            });
        };
         // 当前顶层窗口
        //UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
        UIWindow *window = ([UIApplication sharedApplication].delegate).window;
        for ( UIView *windowSubView in window.subviews) {
            if (windowSubView.tag == PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView_Tag || [windowSubView isKindOfClass:[PrivacyAgreementUserAgreementHaveNewVersionWithNeedAgreeShowView class]]) {//防止重复添加
                return;;
            }else{//非showview
            }
        }
        //没有该图 添加到窗口
        [window addSubview:needAgreeShowView];
      
    });
}


//                vc.view.tag = vc.selfAgreementsType +  PrivacyAgreementUserAgreementHaveNewVersionWithShowDetailView_BaseTag;
//                [weakSelf addDetailShowView:vc.view];
//- (void)addDetailShowView:(UIView *)detailView{
//    // 点击后详情加到当前顶层窗口
//   UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
//   for (UIView *windowSubView in window.subviews) {
//       if (windowSubView.tag == PrivacyAgreementUserAgreementHaveNewVersionWithShowDetailView_BaseTag + detailView.tag) {//防止重复添加
//           return;
//       }
//   }
//   // 添加到窗口
//   [window addSubview:detailView];
//}
//退出登录
- (void)exitAction{
    
    [ExitActionWithCleanOrChangeUserInfoTool exitActionWithDealUseInfo];// //退出登录 的数据清理
    
    //页面
//    LoginVC *loginVC = [[LoginVC alloc]init];
    LoginAndRegiestVC *loginVC = [[LoginAndRegiestVC alloc] init];//20220514新版
    self.view.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.view.window makeKeyAndVisible];
}
@end
