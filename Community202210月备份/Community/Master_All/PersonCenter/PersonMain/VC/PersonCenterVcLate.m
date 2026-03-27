//
//  PersonCenterVcLate.m
//  Community
//
//  Created by 余莹 on 2021/7/27.
//
#import "PersonCenterVcLate.h"
#import "PersonSetVC.h"
#import "IssueHouseMainVc.h"
#import "MoneyWalletVC.h"
#import "MoneyWalletVcLate.h"
#import "MoneyWalletYuEVc.h"
#import "VipMemberVC.h"
#import "RedCardListVC.h"
#import "ZYRedCardListVC.h"
#import "XianjingJuanVC.h"
#import "BankCardVC.h"
#import "MyOrderListVC.h"
#import "MyOrderDetailVcWillPay.h"
#import "MyOrderDetailVcWillUse.h"
#import "MyOrderDetailVcIsCancel.h"
#import "MyOrderDetailVcEndDeal.h"
#import "MyOrderTimeSetVC.h"
#import "IssueBuniessShopManagerVC.h"
#import "IssueHistroyListVC.h"
#import "MyCollectionVC.h"
#import "InvoiceAssistantVC.h"
#import "ShippingAddressVC.h"
#import "WeaherVC.h"
//
#import "PersonCenterHeaderView.h"
#import "PersonCenterTitleTableViewCell.h"
#import "PersonCenterNomalSubCollectionviewTableViewCell.h"
#import "PersonCenterTOPSubCollectionviewTableViewCell.h"
#import "PersonMembersVipAdTableViewCell.h"
//
#import "PersonMoneyModelData.h"
#import "PersonInfoUseModel.h"
//
#import "ZYBlockchainIDcardVC.h"
// 出入记录
#import "ZYAccessRecordVc.h"

#import "PersonCenterUseShowModel.h"
#define  PersonCenterTitleTableViewCell_Identifier                      @"PersonCenterTitleTableViewCell"
#define  PersonCenterTitleTableViewCellMoney_Identifier                 @"PersonCenterTitleTableViewCell_Money"
#define  PersonCenterNomalSubCollectionviewTableViewCell_Identifier     @"PersonCenterNomalSubCollectionviewTableViewCell"
#define  PersonCenterTOPSubCollectionviewTableViewCell_Identifier       @"PersonCenterTOPSubCollectionviewTableViewCell"
#define  PersonMembersVipAdTableViewCell_Identifier                     @"PersonMembersVipAdTableViewCell"


#define Num_Section 2   // 1018我的钱包更改到第一section替换原本的访客
#define Num_Row 2  //title+subCells


#define Section_Num_BasicServices          0
#define Section_Num_CommonlyUsedFunctions  1
#define Section_Num_MyMoney                2

#define Height_TableView_HeaderView 80
#define Height_Cell_One_Row  40
//#define Height_Cell_CollectionViewOneHang 90
#define Height_Cell_CollectionViewOneHang   ((Screen_W -32 -40)/4 +30)


#import "PersonCenterVcLateBaseTableViewCell.h"
#define  PersonCenterVcLateBaseTableViewCell_Identifier  @"PersonCenterVcLateBaseTableViewCell"
#import "MyHousekeeperVC.h"
#import "MyHouseVc.h"
#import "MyCarListVC.h"
#import "ParkingVC.h"
#import "ParkingVcLate.h"
#import "IssueHouseQianYueManagerVC.h"
#import "IssueHouseManagerVcLate.h"
#import "MainAllTypeInformationVC.h"

// 实名提示弹窗
#import "ZYRealNameAuthenticationPopView.h"
// 实名认证
#import "ZYElectroniNewRealNameAuthenticationCardVc.h"

// 社区集市
#import "ZYCommunityFairVC.h"
// 人脸上传
#import "ZYUploadFaceVC.h"

#import "InformationOrScanGoToWebVc.h"
#import "MyHouseAddSubPeronOkShowScanCodeVc.h"

// 智能停车（新）
#import "ZYParkingVcLate.h"
//闲置
#import "LdleGoodsVC.h"


typedef enum : NSUInteger {         //隐藏
    PersonMainVC_SectionNum_First,
    PersonMainVC_SectionNum_Second,
    PersonMainVC_SectionNum_Third,
} PersonMainVC_SectionNum;

typedef enum : NSUInteger {         //实名选中的功能
    ZYRealName_Selected_Type_FangWu = 1,    // 房屋
    ZYRealName_Selected_Type_RenLian = 2    // 人脸
} ZYRealName_Selected_Type;


@interface PersonCenterVcLate () <UITableViewDelegate,UITableViewDataSource,PersonCenterHeaderViewDelegate,PersonCenterNomalSubCollectionviewTableViewCellDelegate,PersonCenterTOPSubCollectionviewTableViewCellDelegate,ZYRealNameAuthenticationPopViewDelegate>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) PersonCenterHeaderView *headerView;
@property (nonatomic,strong) NSArray *secetionTitleArr;
//
@property (nonatomic,strong) NSMutableArray *secetionOneUseShowArr;
@property (nonatomic,strong) NSMutableArray *secetionTwoUseShowArr;
@property (nonatomic,strong) NSMutableArray *secetionThrUseShowArr;

//
@property (nonatomic,strong) NSMutableArray *arrTop;
@property (nonatomic,strong) NSMutableArray *arrCommonFunction;
@property (nonatomic,strong) NSMutableArray *arrRentHouse;
@property (nonatomic,strong) NSMutableArray *arrMoreRecommend;
@property (nonatomic,strong) NSMutableArray *arrMoneyTitle;
@property (nonatomic,strong) NSMutableArray *arrMoneyDetailTitle;
@property (nonatomic,strong) NSMutableArray *arrMoneyCenterConenct;
//
@property (nonatomic,strong) NSMutableArray *arrTopImgName;
@property (nonatomic,strong) NSMutableArray *arrCommonFunctionImgName;
@property (nonatomic,strong) NSMutableArray *arrRentHouseImgName;
@property (nonatomic,strong) NSMutableArray *arrMoreRecommendImgName;

@property (nonatomic, strong) PersonMoneyModel *personMoneyModel;

@property (nonatomic, strong) ZYRealNameAuthenticationPopView *realNamePopView;

@property (nonatomic, assign) ZYRealName_Selected_Type realNameType;

@end

@implementation PersonCenterVcLate

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    [self addRefresh];
    [self initNoticeWithPersonInfo];
}

- (void)themeIsChange:(NSNotification*)notice{
    NSLog(@"----Base VC---themeIsChange----%@",[self class]);
    DLog(@"themeIsChange");
    dispatch_async(dispatch_get_main_queue(), ^{
        self.view.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
        [self setupNavigationBarStyleWithMainColor];
        [self.myTableView reloadData];
        self.myTableView.tableHeaderView =  self.headerView;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
        [self initData];
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
    [self setupNavigationBarStyleWithMainColor];
    
    // 实名查询
    [ZYRealNameAuthenticationTool realNameqQeryAuthentication];
    
    [self initData];//图片更新
    [self initPersonData];
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        
        return UIStatusBarStyleDarkContent;
    }else {
        
        return UIStatusBarStyleLightContent;
    }
}
#pragma mark === addRefresh
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initPersonData)];
    self.myTableView.mj_header = headeerRefresh;
//    [self.myTableView.mj_header beginRefreshing];
}
- (void)initNoticeWithPersonInfo{
    Y_NSNotificationCenter_Creat_NameAction(PersonInfo_Change_Notice, personInfoChangeNoticeAction)
}
- (void)personInfoChangeNoticeAction{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.headerView  headerViewRefreshPersonInfo];
    });
}

- (void)initView{
    [self.view addSubview:self.myTableView];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.tableHeaderView = self.headerView;
    self.myTableView.tableFooterView = [UIView new];
    [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_myTableView.superview).insets(UIEdgeInsetsMake(0, 0, 44, 0));
    }];
}
 
#pragma mark ===

- (void)initData{
    
    NSArray *sectionOneShowTitleArr = @[@"我的房屋",@"我的车辆",@"我的车位",@"人脸服务",@"出入记录"];
    NSArray *sectionOneShowImgNameArr_W = @[@"My_HouseList_W",@"My_Car_W",@"My_Redenvelopes",@"My_face_W",@"My_Accessrecord"];
    NSArray *sectionOneShowImgNameArr_D = @[@"My_HouseList_Night",@"My_Car_Night",@"My_Redenvelopesye",@"My_face_Night",@"My_Accessrecord_D"];
    self.secetionOneUseShowArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i< sectionOneShowTitleArr.count; i++) {
        PersonCenterUseShowModel *useShowModel = [[PersonCenterUseShowModel alloc]init];
        useShowModel.titleStr = sectionOneShowTitleArr[i];
        useShowModel.imgNameStr_W = sectionOneShowImgNameArr_W[i];
        useShowModel.imgNameStr_D = sectionOneShowImgNameArr_D[i];
        [self.secetionOneUseShowArr addObject:useShowModel];
    }
    
    NSArray *sectionTwoShowTitleArr = @[@"我的管家",@"我的报事",@"我的闲置"];
    NSArray *sectionTwoShowImgNameArr_W = @[@"My_houser_W",@"My_baoshi",@"My_xianzhi"];
    NSArray *sectionTwoShowImgNameArr_D = @[@"My_houser_Night",@"My_baoshi_D",@"My_xianzhi_D"];
    self.secetionTwoUseShowArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i< sectionTwoShowTitleArr.count; i++) {
        PersonCenterUseShowModel *useShowModel = [[PersonCenterUseShowModel alloc]init];
        useShowModel.titleStr = sectionTwoShowTitleArr[i];
        useShowModel.imgNameStr_W = sectionTwoShowImgNameArr_W[i];
        useShowModel.imgNameStr_D = sectionTwoShowImgNameArr_D[i];
        [self.secetionTwoUseShowArr addObject:useShowModel];
    }
    
     [self.headerView  headerViewRefreshPersonInfo];
     [_myTableView reloadData];
    
}

//- (void)initData111{
//    if (kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1) {//待原型OK后处理
//
//        if (kMYAPP_Now_IS_HIDDEN_CAR == 1) {//隐藏车辆
//            _arrRentHouse = [NSMutableArray arrayWithObjects:@"我的房屋", @"人脸服务", nil];
//            _arrCommonFunction = [NSMutableArray arrayWithObjects:@"我的管家",@"出入记录", @"我的报事", nil];
//            if ([ThemeManager shareManager].type == ThemeType_Drak) { //_Night
//                _arrRentHouseImgName = [NSMutableArray arrayWithObjects:@"My_HouseList_Night",@"My_face_Night",nil];
//                _arrCommonFunctionImgName = [NSMutableArray arrayWithObjects:@"My_houser_Night", @"My_Accessrecord_D",  @"My_baoshi_D", nil];
//            }else{
//                _arrRentHouseImgName = [NSMutableArray arrayWithObjects:@"My_HouseList_W", @"My_face_W",nil];
//                _arrCommonFunctionImgName = [NSMutableArray arrayWithObjects:@"My_houser_W",@"My_Accessrecord", @"My_baoshi", nil];
//           }
//        }else{
//            _arrRentHouse = [NSMutableArray arrayWithObjects:@"我的房屋",@"我的车辆",@"人脸服务", nil];
//            _arrCommonFunction = [NSMutableArray arrayWithObjects:@"我的管家",@"智能停车",@"我的报事", nil];
//            if ([ThemeManager shareManager].type == ThemeType_Drak) { //_Night
//                _arrRentHouseImgName = [NSMutableArray arrayWithObjects:@"My_HouseList_Night",@"My_Car_Night", @"My_face_Night",nil];
//                _arrCommonFunctionImgName = [NSMutableArray arrayWithObjects:@"My_houser_Night",@"My_ParkingCar_Night", @"My_baoshi_D", nil];
//            }else{
//                _arrRentHouseImgName = [NSMutableArray arrayWithObjects:@"My_HouseList_W",@"My_Car_W", @"My_face_W",nil];
//                _arrCommonFunctionImgName = [NSMutableArray arrayWithObjects:@"My_houser_W",@"My_ParkingCar_W", @"My_baoshi", nil];
//            }
//        }
//
//    }else{
//        _arrRentHouse = [NSMutableArray arrayWithObjects:@"我的房屋",@"我的车辆",@"我的钱包",@"人脸服务", nil];
//        _arrCommonFunction = [NSMutableArray arrayWithObjects:@"我的管家",@"智能停车",@"我的集市",@"我的租赁", nil];
//        if ([ThemeManager shareManager].type == ThemeType_Drak) { //_Night
//            _arrRentHouseImgName = [NSMutableArray arrayWithObjects:@"My_HouseList_Night",@"My_Car_Night", @"wallet_Night", @"My_face_Night",nil];//visitor_Night
//            _arrCommonFunctionImgName = [NSMutableArray arrayWithObjects:@"My_houser_Night",@"My_ParkingCar_Night", @"My_ShoppingCart_Night", @"My_lease_Night", nil];
//        }else{
//            _arrRentHouseImgName = [NSMutableArray arrayWithObjects:@"My_HouseList_W",@"My_Car_W", @"wallet", @"My_face_W",nil];//My_visitor_W
//            _arrCommonFunctionImgName = [NSMutableArray arrayWithObjects:@"My_houser_W",@"My_ParkingCar_W", @"My_ShoppingCart_W", @"My_lease_W", nil];
//        }
//    }
//
//    //
//    _arrMoneyTitle = [NSMutableArray arrayWithObjects:@"银行卡",@"余额",@"现金劵", nil];
//    _arrMoneyDetailTitle = [NSMutableArray arrayWithObjects:@"银行卡(张)",@"当前余额",@"当前可用(张)", nil];
//    _arrMoneyCenterConenct = [NSMutableArray arrayWithObjects:@(0),@(0),@(0), nil];
//
//
//
//
//    [self.headerView  headerViewRefreshPersonInfo];
//    [_myTableView reloadData];
//}
- (void)initPersonData {
    if ([IsLoginTool share].save_Login_Type == IS_Login_Nomal) {
        //普通有账号有绑定手机的才做这个数据获取
        [self initHeaderViewIofo];
        //[self initMoneyShowData]; //钱包相关的接口 UI暂时没使用 数据暂不调用
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTableView.mj_header endRefreshing];
        });
    }

    [_myTableView reloadData];
}
- (void)initHeaderViewIofo{
    WEAKSELF
    [PersonInfoViewModel getPersonUserInfoWithBlock:^(NSDictionary * dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.myTableView.mj_header endRefreshing];
        });
        if (success) {
            NSLog(@"initHeaderViewIofo %@",dic);
            PersonInfoUseModel *getInfodel = [PersonInfoUseModel mj_objectWithKeyValues:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.headerView fillPersonInfoWithPersonInfoUseModel:getInfodel];
            });
        }
    }];
  
}
- (void)initMoneyShowData{
    WEAKSELF
    [PersonMoneyModelData getPersonMoneyDataWithBlock:^(NSDictionary * dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.myTableView.mj_header endRefreshing];
        });
        if (success) {
            PersonMoneyModel *model = [PersonMoneyModel mj_objectWithKeyValues:dic];
            self.personMoneyModel = model;
            [weakSelf.arrMoneyCenterConenct replaceObjectAtIndex:0 withObject:@(model.bankCard)];
            [weakSelf.arrMoneyCenterConenct replaceObjectAtIndex:1 withObject:@(model.balance)];
            [weakSelf.arrMoneyCenterConenct replaceObjectAtIndex:2 withObject:@(0)];
//            [weakSelf.arrMoneyCenterConenct replaceObjectAtIndex:2 withObject:@(model.tickets)];//现金券暂时不做 设置为0
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.myTableView reloadData];
            });
        }
    }];
    
}
#pragma mark == 是否绑定手机的跳转判定
#pragma mark === 判定是否需要弹出绑定vc (需要登录的游客账号不会显示本页)
- (BOOL)shouldShowBindVcBool{
    if( [IsLoginTool share].save_Login_Type==IS_Login_UnboundPhone){
        //用三方ID绑定电话
        //苹果 绑定手机操作
        AppleLoginModel *model = [[AppleLoginModel alloc]init];
        model.thirdPlatformId = [IsLoginTool share].appleLoginSaveThridIdWillUseToBindPhone;
        //
        BindingPhoneVC *bindVc = [[BindingPhoneVC alloc]init];
        bindVc.appleUserModel = model;
        bindVc.hidesBottomBarWhenPushed = YES;
        [self pushVc:bindVc];
        return YES;
    }else{
        return NO;
    }
}
//____________________________________________
#pragma mark === header基础action
- (void)personVcHeaderViewSubSetBtnTouchUp{
    DLog(@"个人中心设置按钮");//不做登录是否限制 下级别关于允许开放 其他
    PersonSetVC *vc = [[PersonSetVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
- (void)personVcHeaderViewSubInfoBtnTouchUp{
//    DLog(@"总消息界面");
//    if ([self shouldShowBindVcBool]) {
//        return;
//    }
//    MainAllTypeInformationVC *vc = [[MainAllTypeInformationVC alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self pushVc:vc];
    NSLog(@"主题色切换");
    [self changeThemeColorAction];
}

- (void)blockchainIDCardButtonEvent {
    NSLog(@"区块链认证");
    
    ZYBlockchainIDcardVC *vc = [[ZYBlockchainIDcardVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}

// 主题色切换
- (void)changeThemeColorAction{
    DLog(@"主题模式切换 %lu",(unsigned long)[ThemeManager shareManager].type);
    [ThemeManager shareManager].type = ([ThemeManager shareManager].type==ThemeType_White)?(ThemeType_Drak):(ThemeType_White);
    //切换
    if ([ThemeManager shareManager].type==ThemeType_White) {
        [ThemeManager shareManager].type = ThemeType_White;
        [ThemeManager shareManager].saveThemeTypeWithStr = kSaveThemeTypeWithStr_White;
        [ZYThemeManager shareManager].themeType = ZYThemeType_White;
        if (@available(iOS 14.0, *)) {
            self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    }else{
        [ThemeManager shareManager].type = ThemeType_Drak;
        [ThemeManager shareManager].saveThemeTypeWithStr = kSaveThemeTypeWithStr_Dray;
        [ZYThemeManager shareManager].themeType = ZYThemeType_Dark;
        if (@available(iOS 14.0, *)) {
            self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        }
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    }
    //存储
    [[NSUserDefaults standardUserDefaults] setValue:[ThemeManager shareManager].saveThemeTypeWithStr forKey:Key_SaveThemeTypeWithStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //通知
    Y_NSNotificationCenter_PostNotice_NilObject_Name(NOTICE_NAME_ThemeISChanged);
}


#pragma mark === 基础服务|( 房屋 有业主认证模块的总cell)
//house type
- (void)personVcNomalSubCollectionViewHouseCellTouchUpItemWithIndex:(NSInteger)index{
    PersonCenterUseShowModel *m = self.secetionOneUseShowArr[index];
    NSLog(@"基础服务|%@ ",m.titleStr);
    
                switch (index) {
                    case 0:
                    {
    //                    // 实名判断（新版本去掉）
    //                    if (!ZY_IsRealName) {
    //                        self.realNameType = ZYRealName_Selected_Type_FangWu;
    //                        self.realNamePopView = [[NSBundle mainBundle] loadNibNamed:@"ZYRealNameAuthenticationPopView" owner:nil options:nil].lastObject;
    //                        self.realNamePopView.delegate = self;
    //                        [self.realNamePopView showRealNameAuthenticationPopView];
    //                        return;
    //                    }
    
                        //判定业主家属租客 游客等身份
                        if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                            [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                            return;;
                        }
                        MyHouseVc *vc = [[MyHouseVc alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self pushVc:vc];
                    }
                        break;
    
                    case 1:
                    {
                        //判定业主家属租客 游客等身份
                        if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                            [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                            return;;
                        }
                        //  车辆
                        MyCarListInfoVC *vc = [[MyCarListInfoVC alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self pushVc:vc];
                    }
                        break;
                    case 2:
                    {
                        //判定业主家属租客 游客等身份
                        if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                            [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                            return;;
                        }
                        // 车位
                        MyCarWithParkingSpotListVC *vc = [[MyCarWithParkingSpotListVC alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self pushVc:vc];
                    }
                        break;
                    case 3:
                    {
    //                    // 实名判断（新版本去掉）
    //                    if (!ZY_IsRealName) {
    //                        self.realNameType = ZYRealName_Selected_Type_RenLian;
    //                        self.realNamePopView = [[NSBundle mainBundle] loadNibNamed:@"ZYRealNameAuthenticationPopView" owner:nil options:nil].lastObject;
    //                        self.realNamePopView.delegate = self;
    //                        [self.realNamePopView showRealNameAuthenticationPopView];
    //                        return;
    //                    }
    
                        //判定业主家属租客 游客等身份
                        if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                            [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                            return;;
                        }
                        //人脸
                        ZYUploadFaceVC *vc = [[ZYUploadFaceVC alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self pushVc:vc];
                    }
                        break;
                    case 4:
                    {
                        
                        NSLog(@" center_menu  出入记录");
                        //判定业主家属租客 游客等身份
                        if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                            [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                            return;;
                        }
                        
                        ZYAccessRecordVc *vc = [[ZYAccessRecordVc alloc] init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self pushVc:vc];
                    }
                        break;
                        
                    default:
                        break;
                }

    
    //                    //是否实名
    //                    if (ZY_IsRealName) {
    //                        //已经实名 可继续后面的判定
    //                    }else {
    //                        //没有实名 跳转去实名  不走房屋界面
    //                        ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
    //                        vc.otherShowDetailStr = nomalGotoRealNameShowStr;
    //                        vc.hidesBottomBarWhenPushed = YES;
    //                        [self pushVc:vc];
    //                        return;
    //                    }
}
//- (void)personVcNomalSubCollectionViewHouseCellTouchUpItemWithIndex:(NSInteger)index{
//    if ([self shouldShowBindVcBool]) {//需要登录 被阻挡
//        return;
//    }
//    DLog(@"%@",self.arrRentHouse[index]);
//    if (kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1) {
//
//
//        if (kMYAPP_Now_IS_HIDDEN_CAR == 1) {//隐藏车辆
//
//            switch (index) {
//                case 0:
//                {
////                    // 实名判断（新版本去掉）
////                    if (!ZY_IsRealName) {
////                        self.realNameType = ZYRealName_Selected_Type_FangWu;
////                        self.realNamePopView = [[NSBundle mainBundle] loadNibNamed:@"ZYRealNameAuthenticationPopView" owner:nil options:nil].lastObject;
////                        self.realNamePopView.delegate = self;
////                        [self.realNamePopView showRealNameAuthenticationPopView];
////                        return;
////                    }
//
//                    //判定业主家属租客 游客等身份
//                    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 4) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                        [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                        return;;
//                    }
//                    MyHouseVc *vc = [[MyHouseVc alloc]init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self pushVc:vc];
//                }
//                    break;
//
//                case 1:
//                {
////                    // 实名判断（新版本去掉）
////                    if (!ZY_IsRealName) {
////                        self.realNameType = ZYRealName_Selected_Type_RenLian;
////                        self.realNamePopView = [[NSBundle mainBundle] loadNibNamed:@"ZYRealNameAuthenticationPopView" owner:nil options:nil].lastObject;
////                        self.realNamePopView.delegate = self;
////                        [self.realNamePopView showRealNameAuthenticationPopView];
////                        return;
////                    }
//
//                    //判定业主家属租客 游客等身份
//                    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 4) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                        [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                        return;;
//                    }
//                    //人脸
//                    ZYUploadFaceVC *vc = [[ZYUploadFaceVC alloc] init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self pushVc:vc];
//                }
//                    break;
//
//                default:
//                    break;
//            }
//        }else{
//            switch (index) {
//                case 0:
//                {
//                    //是否实名
//                    if (ZY_IsRealName) {
//                        //已经实名 可继续后面的判定
//                    }else {
//                        //没有实名 跳转去实名  不走房屋界面
//                        ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
//                        vc.otherShowDetailStr = nomalGotoRealNameShowStr;
//                        vc.hidesBottomBarWhenPushed = YES;
//                        [self pushVc:vc];
//                        return;
//                    }
//                    //判定业主家属租客 游客等身份
//                    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 4) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                        [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                        return;;
//                    }
//                    MyHouseVc *vc = [[MyHouseVc alloc]init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self pushVc:vc];
//                }
//                    break;
//                case 1:
//                {
//                    //判定业主家属租客 游客等身份
//                    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                        [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                        return;;
//                    }
//                    //我的车辆
//                    MyCarListVC *vc = [[MyCarListVC alloc]init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self pushVc:vc];
//
//                }
//                    break;
//
//
//                case 2:
//                {
//                    //是否实名
//                    if (ZY_IsRealName) {
//                        //已经实名 可继续后面的判定
//                    }else {
//                        //没有实名 跳转去实名  不走房屋界面
//                        ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
//                        vc.otherShowDetailStr = nomalGotoRealNameShowStr;
//                        vc.hidesBottomBarWhenPushed = YES;
//                        [self pushVc:vc];
//                        return;
//                    }
//                    //判定业主家属租客 游客等身份
//                    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 4) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                        [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                        return;;
//                    }
//                    //人脸
//                    ZYUploadFaceVC *vc = [[ZYUploadFaceVC alloc] init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self pushVc:vc];
//                }
//                    break;
//
//                default:
//                    break;
//            }
//        }
//
//    }else{
//        switch (index) {
//            case 0:
//            {
//                //是否实名
//                if (ZY_IsRealName) {
//                    //已经实名 可继续后面的判定
//                }else {
//                    //没有实名 跳转去实名  不走房屋界面
//                    ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
//                    vc.otherShowDetailStr = nomalGotoRealNameShowStr;
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self pushVc:vc];
//                    return;
//                }
//                //判定业主家属租客 游客等身份
//                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 4) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                    return;;
//                }
//                MyHouseVc *vc = [[MyHouseVc alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self pushVc:vc];
//            }
//                break;
//            case 1:
//            {
//                //判定业主家属租客 游客等身份
//                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                    return;;
//                }
//                //我的车辆
//                MyCarListVC *vc = [[MyCarListVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self pushVc:vc];
//
//            }
//                break;
//            case 2:
//                // 1018我的钱包更改到第一section替换原本的访客
//            {
//                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 4) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                    return;;
//                }
//                if ([self shouldShowBindVcBool]) {
//                    return;
//                }
//                //是否实名
//                if (ZY_IsRealName) {
//                    //已经实名 可继续后面的判定
//                }else {
//                    //没有实名 跳转去实名  不走房屋界面
//                    ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
//                    vc.otherShowDetailStr = nomalGotoRealNameShowStr;
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self pushVc:vc];
//                    return;
//                }
//             //   MoneyWalletVC *vc = [[MoneyWalletVC alloc]init];
//                 MoneyWalletVcLate *vc  = [[MoneyWalletVcLate alloc]init];
//                 vc.hidesBottomBarWhenPushed = YES;
//                 [self pushVc:vc];
//            }
//            /**
//             { //访客邀请
//                 //判定业主家属租客 游客等身份
//                 if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                     [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                     return;;
//                 }
//                 GuestInfoRegistionVC *vc = [[GuestInfoRegistionVC alloc]init];
//                 vc.hidesBottomBarWhenPushed = YES;
//                 [self pushVc:vc];
//             }*/
//                break;
//            case 3:
//            {
//                //是否实名
//                if (ZY_IsRealName) {
//                    //已经实名 可继续后面的判定
//                }else {
//                    //没有实名 跳转去实名  不走房屋界面
//                    ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
//                    vc.otherShowDetailStr = nomalGotoRealNameShowStr;
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self pushVc:vc];
//                    return;
//                }
//                //判定业主家属租客 游客等身份
//                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 4) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                    return;;
//                }
//                //人脸
//                ZYUploadFaceVC *vc = [[ZYUploadFaceVC alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self pushVc:vc];
//            }
//                break;
//
//            default:
//                break;
//        }
//    }
//
//}
#pragma mark === 常用工具
//nomal type

- (void)personVcNomalSubCollectionViewCellTouchUpItemWithIndex:(NSInteger)index{
 
                 switch (index) {
                    case 0:
                    {
                        //判定业主家属租客 游客等身份
                        if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                            [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                            return;;
                        }
                        //管家
                        MyHousekeeperVC *vc = [[MyHousekeeperVC alloc]init];
                        vc.hidesBottomBarWhenPushed = YES;
                        [self pushVc:vc];
                    }
                        break;
    
                    case 1:
                    {
    
                         NSLog(@" center_menu  一键报修");
                         //判定业主家属租客 游客等身份
                         if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
                             [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
                             return;;
                         }
         //                HouseRepairMainPageVC *vc = [[HouseRepairMainPageVC alloc]init];
                         MyRepairMainPageVC *vc = [[MyRepairMainPageVC alloc]init];
                         vc.hidesBottomBarWhenPushed = YES;
                         [self pushVc:vc];
                    }
                        break;
                         
                         
                     case 2:
                     {
                         NSLog(@" center_menu  我的闲置");
                         LdleGoodsVC *vc = [[LdleGoodsVC alloc]init];
                         vc.hidesBottomBarWhenPushed = YES;
                         [self pushVc:vc];
                         
                     }
                         break;
                          
    
                    default:
                        break;
                }
    
}

//- (void)personVcNomalSubCollectionViewCellTouchUpItemWithIndex:(NSInteger)index{
//    if ([self shouldShowBindVcBool]) {
//        return;
//    }
//    DLog(@"%@",self.arrCommonFunction[index]);
//
//    if (kMYAPP_Now_IS_HIDDEN_MORE_INDEX == 1) {//敏捷版
//
//        if (kMYAPP_Now_IS_HIDDEN_CAR == 1) {//隐藏车辆
//            switch (index) {
//                case 0:
//                {
//                    //判定业主家属租客 游客等身份
//                    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                        [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                        return;;
//                    }
//                    //管家
//                    MyHousekeeperVC *vc = [[MyHousekeeperVC alloc]init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self pushVc:vc];
//                }
//                    break;
//
//                case 1:
//                {
//
//                     NSLog(@" center_menu  出入记录");
//                     //判定业主家属租客 游客等身份
//                     if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                         [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                         return;;
//                     }
//
//                    ZYAccessRecordVc *vc = [[ZYAccessRecordVc alloc] init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self pushVc:vc];
//                }
//                    break;
//
//                case 2:
//                {
//
//                     NSLog(@" center_menu  一键报修");
//                     //判定业主家属租客 游客等身份
//                     if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                         [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                         return;;
//                     }
//     //                HouseRepairMainPageVC *vc = [[HouseRepairMainPageVC alloc]init];
//                     MyRepairMainPageVC *vc = [[MyRepairMainPageVC alloc]init];
//                     vc.hidesBottomBarWhenPushed = YES;
//                     [self pushVc:vc];
//                }
//                    break;
//
//                default:
//                    break;
//            }
//
//        }else{
//            switch (index) {
//                case 0:
//                {
//                    //判定业主家属租客 游客等身份
//                    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                        [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                        return;;
//                    }
//                    //管家
//                    MyHousekeeperVC *vc = [[MyHousekeeperVC alloc]init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self pushVc:vc];
//                }
//                    break;
//                case 1:
//                {
//                    //判定业主家属租客 游客等身份
//                    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                        [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                        return;;
//                    }
//                    // 智能停车（新）
//                    ZYParkingVcLate *vc = [[ZYParkingVcLate alloc] init];
//                    vc.hidesBottomBarWhenPushed = YES;
//                    [self pushVc:vc];
////                    //停车缴费 相关
////                    ParkingVcLate *vc = [[ParkingVcLate alloc]init];
////                    vc.hidesBottomBarWhenPushed = YES;
////                    [self pushVc:vc];
//                    /**
//                     //报修
//                     HouseRepairListVC *vc = [[HouseRepairListVC alloc]init];
//                     vc.hidesBottomBarWhenPushed = YES;
//                     [self pushVc:vc];
//                     */
//                }
//                    break;
//                case 2:
//                {
//
//                     NSLog(@" center_menu  一键报修");
//                     //判定业主家属租客 游客等身份
//                     if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                         [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                         return;;
//                     }
//     //                HouseRepairMainPageVC *vc = [[HouseRepairMainPageVC alloc]init];
//                     MyRepairMainPageVC *vc = [[MyRepairMainPageVC alloc]init];
//                     vc.hidesBottomBarWhenPushed = YES;
//                     [self pushVc:vc];
//                }
//                    break;
//
//                case 3:
//                {
//                    DLog(@"");
//                }
//                    break;
//
//
//                default:
//                    break;
//            }
//        }
//
//    }else{
//        switch (index) {
//            case 0:
//            {
//                //判定业主家属租客 游客等身份
//                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                    return;;
//                }
//                //管家
//                MyHousekeeperVC *vc = [[MyHousekeeperVC alloc]init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self pushVc:vc];
//            }
//                break;
//            case 1:
//            {
//                //判定业主家属租客 游客等身份
//                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                    return;;
//                }
//                // 智能停车（新）
//                ZYParkingVcLate *vc = [[ZYParkingVcLate alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self pushVc:vc];
////                //停车缴费 相关
////                ParkingVcLate *vc = [[ParkingVcLate alloc]init];
////                vc.hidesBottomBarWhenPushed = YES;
////                [self pushVc:vc];
//            }
//                break;
//            case 2:
//            {
//                //集市
//                DLog(@"集市");
//                //判定业主家属租客 游客等身份
//                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 3) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                    return;;
//                }
//                ZYCommunityFairVC *vc = [[ZYCommunityFairVC alloc] init];
//                vc.hidesBottomBarWhenPushed = YES;
//                [self pushVc:vc];
//
//            }
//                break;
//            case 3:
//            {
//                //租赁
//                //判定业主家属租客 游客等身份
//                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 4) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
//                    [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
//                    return;;
//                }
//
//    //            IssueHouseManagerVcLate *vc = [[IssueHouseManagerVcLate alloc]init];
//                IssueHouseQianYueManagerVC *vc = [[IssueHouseQianYueManagerVC alloc]init];
//                //当前最高权限 来定初使的展示类型
//                if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel>1) {//1为业主 234家属租客新用户 5游客
//                    vc.myType = IssueHouseManagerVC_MyType_ZuKe;//初始状态为租客
//                }else{
//                   vc.myType = IssueHouseManagerVC_MyType_FangDong;//初始状态为房东
//                }
//                vc.hidesBottomBarWhenPushed = YES;
//                [self pushVc:vc];
//            }
//                break;
//
//
//            default:
//                break;
//        }
//    }
//
//
//}

#pragma mark === 钱包
//money type
- (void)myMoneyRightBtnAction{
   if ([self shouldShowBindVcBool]) {
       return;
   }
//   MoneyWalletVC *vc = [[MoneyWalletVC alloc]init];
    MoneyWalletVcLate *vc  = [[MoneyWalletVcLate alloc]init];
    vc.balanceStr = [NSString stringWithFormat:@"%0.2f", self.personMoneyModel.balance];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
- (void)personVcNomalSubCollectionViewMoneyCellTouchUpItemWithIndex:(NSInteger)index{
   NSLog(@"MoneyCellTouchUp   %@",self.arrMoneyTitle[index]);
   if ([self shouldShowBindVcBool]) {
       return;
   }
   if (index==0) {//银行卡
       Y_SVP_SHOW_INFO_MES_5Delay(@"当前暂未开放银行卡,敬请期待");
       return;
       /**
        BankCardVC *vc = [[BankCardVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
        */
   }
   if (index==1) {//当前余额
       MoneyWalletYuEVc *vc = [[MoneyWalletYuEVc alloc]init];
       vc.yuE = [self.arrMoneyCenterConenct[1] doubleValue];
       vc.hidesBottomBarWhenPushed = YES;
       [self pushVc:vc];
   }
   if (index==2) {//现金券
       Y_SVP_SHOW_INFO_MES_5Delay(@"当前暂未开放现金券,敬请期待");
       return;
//       //test
       //NSString *urlStr = @"http://192.168.12.113:8080/#/?id=112584117614415872&mobile=18012345678"
//       NSString *bindUserPhoneStr = @"18012345678";
//       if (![bindUserPhoneStr isEqualToString: [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.mobile]]) { 
//           Y_SVP_SHOW_ERR_MES(@"用户手机号与本数据不匹配，不能做绑定！");
//           return;
//       }
 
//       InformationOrScanGoToWebVc *vc = [[InformationOrScanGoToWebVc alloc]init];
//       vc.infoIdStr = @"112584117614415872";
//       vc.phoneStr = bindUserPhoneStr;
//       vc.hidesBottomBarWhenPushed = YES;
//       [self pushVc:vc];
//       
 
       
       return;
       /**
        XianjingJuanVC *vc = [[XianjingJuanVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
        */
       
   }
}
   
#pragma mark == tableview ——————————


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return Num_Section;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return Num_Row;//title+conview
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ( indexPath.row == 0 ) {
        return Height_Cell_One_Row;
     }else {
         if (indexPath.section == 0) {
             return (Height_Cell_CollectionViewOneHang+10)*2;//基础服务
         }else{
             return Height_Cell_CollectionViewOneHang;//常用工具

         }
    }
 
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  //// 1018我的钱包更改到第一section替换原本的访客
    if (indexPath.row == 0) {
        PersonCenterTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonCenterTitleTableViewCell_Identifier];
        if (!cell) {
            cell = [[PersonCenterTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonCenterTitleTableViewCell_Identifier];
        }
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.secetionTitleArr[indexPath.section]];
        if (indexPath.section== Section_Num_MyMoney ) {
            //
            cell.rightBtn.hidden = NO;
            [cell.rightBtn newAnBtnWithTextStr:@"进入钱包"];
            [cell.rightBtn newAnBtnWithImg:[UIImage imageNamed:@"rightSkip"]];
            [cell.rightBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
            [cell.rightBtn addTarget:self action:@selector(myMoneyRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
            //
        }else{
            cell.rightBtn.hidden = YES;
        }
        return cell;
    }else {//(indexPath.row == 2)
        if (indexPath.section == Section_Num_BasicServices|| indexPath.section == Section_Num_CommonlyUsedFunctions) {
            PersonCenterVcLateBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonCenterVcLateBaseTableViewCell_Identifier];//basecell 图文距离比父类PersonCenterNomalSubCollectionviewTableViewCell小
            if (!cell) {
                cell = [[PersonCenterVcLateBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonCenterVcLateBaseTableViewCell_Identifier];
            }
            if(indexPath.section == Section_Num_BasicServices){
                //[cell showInitWithType:PersoncenterSubCollectionviewCell_Type_House andTitleArr:self.arrRentHouse imgArr:self.arrRentHouseImgName];//房屋类型
                [cell showInitWithType:PersoncenterSubCollectionviewCell_Type_House andShowUseModeArr:self.secetionOneUseShowArr];
            }else if(indexPath.section == Section_Num_CommonlyUsedFunctions){
                //[cell showInitWithType:PersoncenterSubCollectionviewCell_Type_Nomal andTitleArr:self.arrCommonFunction imgArr:self.arrCommonFunctionImgName];
                [cell showInitWithType:PersoncenterSubCollectionviewCell_Type_Nomal andShowUseModeArr:self.secetionTwoUseShowArr];

            }else {
            }
            cell.nomalAndMoneyCellDelegate = self;
            return cell;
        }else{ //==Section_Num_MyMoney
            PersonCenterNomalSubCollectionviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonCenterNomalSubCollectionviewTableViewCell_Identifier];
            if (!cell) {
                cell = [[PersonCenterNomalSubCollectionviewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonCenterNomalSubCollectionviewTableViewCell_Identifier];
            }
            [cell showInitWithMoneyType:PersoncenterSubCollectionviewCell_Type_Money andTopTitleArr:self.arrMoneyTitle andBottomTitleArr:self.arrMoneyDetailTitle andMoneyCenterNumArr:self.arrMoneyCenterConenct];
            cell.nomalAndMoneyCellDelegate = self;
            return cell;
         
    
        }
       
    }
}

#pragma mark ===

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([cell respondsToSelector:@selector(tintColor)]) {
//        if (tableView == self.tableView) {
        CGFloat cornerRadius = 7.0f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
        } else if (indexPath.row == 0) {//上部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//下部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
        layer.strokeColor=[ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
//            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);

            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
//    }
}
#pragma mark ==
- (PersonCenterHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[PersonCenterHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Height_TableView_HeaderView)];
        _headerView.delegate = self;
    }
    [_headerView changeThemeWithColorUpData];
    return _headerView;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.estimatedSectionFooterHeight = 0.01;
        _myTableView.estimatedSectionHeaderHeight = 0.01;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    _myTableView.backgroundColor = [ThemeManager shareManager].themeBackGroundColor;//在更新主题色时的刷新调用
    return _myTableView;
}
- (NSArray *)secetionTitleArr{
    if (!_secetionTitleArr) {
        _secetionTitleArr = [[NSArray alloc]initWithObjects:@"基础服务",@"常用功能", @"我的钱包",nil];//订单0 VIP1 常用功能2....
    }
    return _secetionTitleArr;
}
 
- (NSMutableArray *)arrCommonFunction{
    if (!_arrCommonFunction) {
        _arrCommonFunction = [[NSMutableArray alloc]init];
    }
    return _arrCommonFunction;
}
- (NSMutableArray *)arrRentHouse{
    if (!_arrRentHouse) {
        _arrRentHouse = [[NSMutableArray alloc]init];
    }
    return _arrRentHouse;
}
 
- (NSMutableArray *)arrCommonFunctionImgName{
    if (!_arrCommonFunctionImgName) {
        _arrCommonFunctionImgName = [[NSMutableArray alloc]init];
    }
    return _arrCommonFunctionImgName;
}
- (NSMutableArray *)arrRentHouseImgName{
    if (!_arrRentHouseImgName) {
        _arrRentHouseImgName = [[NSMutableArray alloc]init];
    }
    return _arrRentHouseImgName;
}
- (NSMutableArray *)arrMoneyTitle{
    if (!_arrMoneyTitle) {
        _arrMoneyTitle = [[NSMutableArray alloc]init];
    }
    return _arrMoneyTitle;
}
- (NSMutableArray *)arrMoneyDetailTitle{
    if (!_arrMoneyDetailTitle) {
        _arrMoneyDetailTitle = [[NSMutableArray alloc]init];
    }
    return _arrMoneyDetailTitle;
}
- (NSMutableArray *)arrMoneyCenterConenct{
    if (!_arrMoneyCenterConenct) {
        _arrMoneyCenterConenct = [[NSMutableArray alloc]init];
    }
    return _arrMoneyCenterConenct;
}

#pragma mark - ZYRealNameAuthenticationPopViewDelegate
// 暂不认证
- (void)noRealNameButtonEvent {
    NSLog(@"暂不认证");
    if (self.realNameType == ZYRealName_Selected_Type_FangWu) {
        // 房屋
        MyHouseVc *vc = [[MyHouseVc alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }else if (self.realNameType == ZYRealName_Selected_Type_RenLian) {
        // 人脸
        ZYUploadFaceVC *vc = [[ZYUploadFaceVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
}

// 马上认证
- (void)realNameButtonEvent {
    NSLog(@"马上认证");
    WEAKSELF
    [GotoRealNameAuthenticationCardVcTool needGotoRealNameAuthenticationCardVcWithNowVcType:GotoRealNameAuthenticationCardVc_NowVcType_Nomal withBlock:^(BOOL needGotoRealNameVcBool, ZYElectroniNewRealNameAuthenticationCardVcLate * _Nonnull realNameVc) {
        if (needGotoRealNameVcBool) {
            [weakSelf pushVc:realNameVc];
        }
    }];
}
 
@end
