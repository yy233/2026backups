//
//  PersonCenterVC.m
//  test
//
//  Created by 余莹 on 2020/11/9.
//

#import "PersonCenterVC.h"
#import "PersonSetVC.h"
#import "IssueHouseMainVc.h"
#import "MoneyWalletVC.h"
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
#import "PersonCenterVcLate.h"//

#define  PersonCenterTitleTableViewCell_Identifier                      @"PersonCenterTitleTableViewCell"
#define  PersonCenterNomalSubCollectionviewTableViewCell_Identifier     @"PersonCenterNomalSubCollectionviewTableViewCell"
#define  PersonCenterTOPSubCollectionviewTableViewCell_Identifier       @"PersonCenterTOPSubCollectionviewTableViewCell"
#define  PersonMembersVipAdTableViewCell_Identifier                     @"PersonMembersVipAdTableViewCell"
//#define Num_Section 6
#define Num_Section 3
#define Num_Row 2
#define Height_TableView_HeaderView 80
#define Height_Cell_One_Row  40
#define Height_Cell_CollectionViewOneHang 90

typedef enum : NSUInteger {         //隐藏
//    PersonMainVC_SectionNum_Order,
//    PersonMainVC_SectionNum_Vip,
    PersonMainVC_SectionNum_CommonlyUsedFunctions,
//    PersonMainVC_SectionNum_Moeny,
    PersonMainVC_SectionNum_House,
    PersonMainVC_SectionNum_More,
} PersonMainVC_SectionNum;


@interface PersonCenterVC () <UITableViewDelegate,UITableViewDataSource,PersonCenterHeaderViewDelegate,PersonCenterNomalSubCollectionviewTableViewCellDelegate,PersonCenterTOPSubCollectionviewTableViewCellDelegate>
@property (nonatomic,strong) UITableView *myTableView;
@property (nonatomic,strong) PersonCenterHeaderView *headerView;
@property (nonatomic,strong) NSArray *secetionTitleArr;
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
 
@end

@implementation PersonCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    [self addRefresh];
    [self initNoticeWithPersonInfo];
}
 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor;
    [self setupNavigationBarStyleWithMainColor];
}

#pragma mark === addRefresh
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initPersonData)];
    self.myTableView.mj_header = headeerRefresh;
    [self.myTableView.mj_header beginRefreshing];
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
- (void)initData{
    _arrTop = [NSMutableArray arrayWithObjects:@"我的订单",@"待付款",@"待使用",@"待评价",@"退款/售后", nil];
    _arrCommonFunction = [NSMutableArray arrayWithObjects:@"红包卡券",@"收藏",@"购物车",@"我的地址", nil];
//    _arrRentHouse = [NSMutableArray arrayWithObjects:@"发布房源",@"商铺",@"认证房屋",@"最近浏览", nil];//0710  "商铺" 暂时隐藏 换成总租房管理跳转位置
    _arrRentHouse = [NSMutableArray arrayWithObjects:@"发布房源",@"租房管理",@"认证房屋",@"最近浏览", nil];
    _arrMoneyTitle = [NSMutableArray arrayWithObjects:@"银行卡",@"余额",@"现金劵", nil];
    _arrMoneyDetailTitle = [NSMutableArray arrayWithObjects:@"银行卡(张)",@"当前余额",@"当前可用(张)", nil];
    _arrMoneyCenterConenct = [NSMutableArray arrayWithObjects:@(0),@(0),@(0), nil];
    //
    _arrTopImgName = [NSMutableArray arrayWithObjects:@"My_Shoping_order",@"My_Shoppingmall_Tobepaid", @"My_Shoppingmall_Tobeused", @"My_Shoppingmall_Tobeevaluated", @"My_Shoppingmall_refund",  nil];
    _arrCommonFunctionImgName = [NSMutableArray arrayWithObjects:@"My_Redenvelopes",@"My_Collection", @"My_ShoppingCart", @"My_address",nil];
    _arrRentHouseImgName = [NSMutableArray arrayWithObjects:@"My_Releaseofhousing",@"My_shops", @"My_Certifiedhousing", @"My_Recentbrowsing", nil];
    /**保留
     _arrMoreRecommend = [NSMutableArray arrayWithObjects:@"天天好券",@"充值中心",@"发票助手",@"天气",@"点餐提醒", nil];
     _arrMoreRecommendImgName = [NSMutableArray arrayWithObjects:@"My_Tiantianhaoquan",@"My_VoucherCenter", @"My_Invoiceassistant", @"My_weather", @"My_Orderreminder", nil];
     */
    _arrMoreRecommend = [NSMutableArray arrayWithObjects:@"充值中心",@"发票助手",@"天气",nil];
    _arrMoreRecommendImgName = [NSMutableArray arrayWithObjects:@"My_VoucherCenter", @"My_Invoiceassistant", @"My_weather", nil];

    [_myTableView reloadData];
}
- (void)initPersonData {
    if ([IsLoginTool share].save_Login_Type == IS_Login_Nomal) {
        //普通有账号有绑定手机的才做这个数据获取
        [self initHeaderViewIofo];
        [self initMoneyShowData];
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
            NSLog(@"%@",dic);
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
            [weakSelf.arrMoneyCenterConenct replaceObjectAtIndex:0 withObject:@(model.bankCard)];
            [weakSelf.arrMoneyCenterConenct replaceObjectAtIndex:1 withObject:@(model.balance)];
            [weakSelf.arrMoneyCenterConenct replaceObjectAtIndex:2 withObject:@(model.tickets)];
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
#pragma mark ==
- (void)personVcHeaderViewSubSetBtnTouchUp{
    DLog(@"");
//    PersonSetVC *vc = [[PersonSetVC alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
//    [self pushVc:vc];
    
     
    PersonCenterVcLate *vc = [[PersonCenterVcLate alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
    
}
- (void)personVcHeaderViewSubInfoBtnTouchUp{
    DLog(@"总消息界面");
    if ([self shouldShowBindVcBool]) {
        return;
    }
    TopInformationVC *vc = [[TopInformationVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
#pragma mark == 会员
- (void)rightOpenVipBtnAction{
    DLog(@"开会员");
    if ([self shouldShowBindVcBool]) {
        return;
    }
    VipMemberVC *vc = [[VipMemberVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
#pragma mark == 第一行订单相关
- (void)personVcTopSubCollectionViewTouchUpItemWithIndex:(NSInteger)index{
        NSLog(@"TOPSubCollectionviewT    %@",self.arrTop[index]);
    if ([self shouldShowBindVcBool]) {
        return;
    }
    MyOrderListCell_Type listType = MyOrderListCell_Type_All;
    
    /**
     MyOrderListCell_Type_All=1,
     MyOrderListCell_Type_WillPay=2, //待付款
     MyOrderListCell_Type_PayEnd =3, //3"已付款"
     MyOrderListCell_Type_WillUse=4, // 4"待使用"
     MyOrderListCell_Type_WillEvaluation=5,//"待评价5" == 已完成MyOrderListCell_Type_EndDeal
     MyOrderListCell_Type_EvaluationEnd =6,//已经评价
     MyOrderListCell_Type_ReturnComIng=7,//退款中
     MyOrderListCell_Type_ReturnComSuccess=8,//退款成功
     MyOrderListCell_Type_ReturnComRefused=9,//拒绝退款
     MyOrderListCell_Type_ReturnCom=10,//退款/售后
     */

    switch (index) {
            case 0:
                listType = MyOrderListCell_Type_All;
                break;
            case 1:
                listType = MyOrderListCell_Type_WillPay;
                break;
            case 2:
                listType = MyOrderListCell_Type_WillUse;
                break;
            case 3:
                listType = MyOrderListCell_Type_WillEvaluation;
                break;
    
            default:
            listType = MyOrderListCell_Type_ReturnCom;//售后相关键值
                break;
        }
 
        MyOrderListVC *vc = [[MyOrderListVC alloc]init];
        [vc listShowIsType:listType];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
//    //当前item type  详情
//    if (index==1) {
//        MyOrderDetailVcWillPay *vc = [[MyOrderDetailVcWillPay alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//    }
//    if (index==2) {
//        MyOrderDetailVcWillUse *vc = [[MyOrderDetailVcWillUse alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//    }
//    if (index==3) {
//        MyOrderDetailVcEndDeal *vc = [[MyOrderDetailVcEndDeal alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//    }
//    if (index==4) {
//        MyOrderDetailVcIsCancel*vc = [[MyOrderDetailVcIsCancel alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
//    }
}
#pragma mark === 常用功能
- (void)personVcNomalSubCollectionViewCellTouchUpItemWithIndex:(NSInteger)index{//待处理 //待后续增加类型
    if ([self shouldShowBindVcBool]) {
        return;
    }
    if (index==0) {
//        RedCardListVC *vc = [[RedCardListVC alloc]init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
        
        ZYRedCardListVC *vc = [[ZYRedCardListVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
    if (index==1) {
        MyCollectionVC *vc = [[MyCollectionVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
    if (index==3) {
        ShippingAddressVC *vc = [[ShippingAddressVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
//    if (index<=3) {
//            NSLog(@"NomalSubCollec    %@ %@ %@",self.arrCommonFunction[index],self.arrRentHouse[index],self.arrMoreRecommend[index]);
//    }else{
//        DLog(@"NomalSubCollectionViewCellTouchUpItem 主页cell sub item 点击");
//    }
    
}
#pragma mark === 租房服务
- (void)issueManagerRightBtnAction{
    DLog(@"");
    if ([self shouldShowBindVcBool]) {
        return;
    }
    /** 暂时隐藏租客模式 预约时间 时间有问题 隐藏 0710？*/
    IssueHouseManagerVC *vc = [[IssueHouseManagerVC alloc]init];
    vc.myType = IssueHouseManagerVC_MyType_ZuKe;//初始状态为租客
//    vc.myType = IssueHouseManagerVC_MyType_FangDong;//初始状态为房东
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
- (void)personVcNomalSubCollectionViewHouseCellTouchUpItemWithIndex:(NSInteger)index{
    NSLog(@"NomalSubCollec  housecell type  %@  ", self.arrRentHouse[index]);
    if ([self shouldShowBindVcBool]) {
        return;
    }
    if (index==0) {
        //add 发布房源
        IssueHouseMainVc *issueHouse = [[IssueHouseMainVc alloc]init];
        issueHouse.hidesBottomBarWhenPushed = YES;
        [self pushVc:issueHouse];
    }
    if(index==1){
        //商铺管理---0710 暂合并到右上角按钮一起的vc里面  总 出租管理
//        IssueBuniessShopManagerVC *vc = [[IssueBuniessShopManagerVC alloc]init];
//        vc.myType = IssueHouseManagerVC_MyType_BuniessShopManager;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self pushVc:vc];
        
        IssueHouseManagerVC *vc = [[IssueHouseManagerVC alloc]init];
        vc.myType = IssueHouseManagerVC_MyType_FangDong;//初始状态为房东
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
    if (index==2) { //认证页 数据需要 判定当前的
        
            //判断认证的位置 处理跳转
            Y_SVP_SHOW_MES_IsDling_15Delay(@"正在获取认证信息")
            [UserInfoRegistWillEnterWhichVcWithData goToWhichVcWithType:^(UserInfoRegistVC_GoToVC_Type goToVcType, BOOL success) {
                Y_SVP_DISMISS
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!success) {
                        Y_SVP_SHOW_ERR_MES(@"认证数据请求失败");
                    }else{
                        
                        switch (goToVcType) {
                            case UserInfoRegistVC_GoToVC_Type_PersonInfoUnRegistered://都没认证
                            {
                                // 未实名认证的vc 与签章共用同一个UI

                                ElectroniNewRealNameAuthenticationCardVc *vc = [[ElectroniNewRealNameAuthenticationCardVc alloc]init];
                                vc.hidesBottomBarWhenPushed = YES;
                                [self pushVc:vc];
                                //    [self notGoRealCertificationPopViewShow];待
                            }
                                break;
                            case UserInfoRegistVC_GoToVC_Type_HouseUnRegistered: //已经认证过 个人信息+ 未认证 房屋信息
                            {
                                UserInfoRegistVC *vc = [[UserInfoRegistVC alloc]init];
                                vc.userInfoListIsRegistered = NO;//只有人认证过+房屋没有认证过 no
                                vc.hidesBottomBarWhenPushed = YES;
                                [self pushVc:vc];
                            }
                                break;
                            case UserInfoRegistVC_GoToVC_Type_Registered: //已经认证过 个人信息+房屋信息
                            {
                               
                                UserInfoRegistVC *vc = [[UserInfoRegistVC alloc]init];
                                vc.userInfoListIsRegistered = YES;//已经认证过房屋 yes
                                vc.hidesBottomBarWhenPushed = YES;
                                [self pushVc:vc];
                            }
                                break;
                            default:
                                break;
                        }
                    }
                });
                
            }];
    }
    if (index==3) {
        //浏览记录
        IssueHistroyListVC *vc = [[IssueHistroyListVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
    
}
#pragma mark === 钱包
- (void)myMoneyRightBtnAction{
    if ([self shouldShowBindVcBool]) {
        return;
    }
    MoneyWalletVC *vc = [[MoneyWalletVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVc:vc];
}
- (void)personVcNomalSubCollectionViewMoneyCellTouchUpItemWithIndex:(NSInteger)index{
    NSLog(@"MoneyCellTouchUp   %@",self.arrMoneyTitle[index]);
    if ([self shouldShowBindVcBool]) {
        return;
    }
    if (index==0) {//银行卡
        BankCardVC *vc = [[BankCardVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
    if (index==1) { //当前余额
        MoneyWalletYuEVc *vc = [[MoneyWalletYuEVc alloc]init];
        vc.yuE = [self.arrMoneyCenterConenct[1] doubleValue];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
    if (index==2) {//现金券
        XianjingJuanVC *vc = [[XianjingJuanVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
}
#pragma mark == 更多推荐
- (void)personVcNomalSubCollectionViewMoreRecommendCellTouchUpItemWithIndex:(NSInteger)index{
 
    NSLog(@"MoreCellTouchUp   %@",self.arrMoreRecommend[index]);
    if ([self shouldShowBindVcBool]) {
        return;
    }
    /**保留
     if (index==2) {
         InvoiceAssistantVC *vc = [[InvoiceAssistantVC alloc]init];
         vc.hidesBottomBarWhenPushed = YES;
         [self pushVc:vc];
     }
     if (index==3) {
         WeaherVC *vc = [[WeaherVC alloc]init];
         vc.hidesBottomBarWhenPushed = YES;
         [self pushVc:vc];
     }
     if (index==4) {
         MyOrderTimeSetVC *vc = [[MyOrderTimeSetVC alloc]init];
         vc.hidesBottomBarWhenPushed = YES;
         [self pushVc:vc];
     }
     */
    if (index==1) {
        InvoiceAssistantVC *vc = [[InvoiceAssistantVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
    if (index==2) {
        WeaherVC *vc = [[WeaherVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
    }
}
#pragma mark == tableview ——————————


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return Num_Section;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    if (section==PersonMainVC_SectionNum_CommonlyUsedFunctions) {
        return 1;
//    }else if(section==PersonMainVC_SectionNum_Vip){
//        return 1;
    }else{
        return 10;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    /** 保留
    
    if (section==PersonMainVC_SectionNum_Order ) {
        return 1;
    }else if(section==PersonMainVC_SectionNum_Vip){
        return 1;
    }
     */
    return Num_Row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /** 保留
     //row==0 textCell
     if (indexPath.section==PersonMainVC_SectionNum_Order) {
         return Height_Cell_CollectionViewOneHang;
     }else if(indexPath.section==PersonMainVC_SectionNum_Vip){//vip
         return 60;
 //        return 0.01;//vip隐藏
     }else if(indexPath.section==PersonMainVC_SectionNum_Moeny && indexPath.row!=0){//moneyCell
         return Height_Cell_CollectionViewOneHang+20;
     }else if(indexPath.section==PersonMainVC_SectionNum_More){
         if (indexPath.row==0) {
             return Height_Cell_One_Row;
         }else {
             return Height_Cell_CollectionViewOneHang*2;
         }
     }else{
         if (indexPath.row==0) {
             return Height_Cell_One_Row;
         }else {
             return Height_Cell_CollectionViewOneHang;
         }
     }
     */
 if(indexPath.section==PersonMainVC_SectionNum_More){
  
    if (indexPath.row==0) {
        return Height_Cell_One_Row;
    }else {
        /**保留。
         return Height_Cell_CollectionViewOneHang*2;
         */
        return Height_Cell_CollectionViewOneHang;
    }
}else{
    if (indexPath.row==0) {
        return Height_Cell_One_Row;
    }else {
        return Height_Cell_CollectionViewOneHang;
    }
}
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /**保留
     if (indexPath.section==PersonMainVC_SectionNum_Order) {
         PersonCenterTOPSubCollectionviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonCenterTOPSubCollectionviewTableViewCell_Identifier];
         if (!cell) {
             cell = [[PersonCenterTOPSubCollectionviewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonCenterTOPSubCollectionviewTableViewCell_Identifier];
         }
         [cell showInitWithType:PersoncenterSubCollectionviewCell_Type_TopCell andTitleArr:self.arrTop imgArr:self.arrTopImgName];
         cell.topCellDelegate = self;
         return cell;
     }else if(indexPath.section==PersonMainVC_SectionNum_CommonlyUsedFunctions||indexPath.section==PersonMainVC_SectionNum_House || indexPath.section==PersonMainVC_SectionNum_More){
         if (indexPath.row==0) {
             PersonCenterTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonCenterTitleTableViewCell_Identifier];
             if (!cell) {
                 cell = [[PersonCenterTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonCenterTitleTableViewCell_Identifier];
             }
             cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.secetionTitleArr[indexPath.section]];
             if (indexPath.section==4) {
                 cell.rightBtn.hidden = NO;
                 [cell.rightBtn newAnBtnWithTextStr:@"租房管理"];
                 [cell.rightBtn newAnBtnWithImg:[UIImage imageNamed:@"rightSkip"]];
                 [cell.rightBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
                 [cell.rightBtn addTarget:self action:@selector(issueManagerRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
             }else{
                 cell.rightBtn.hidden = YES;
             }
             return cell;
         }else{
             PersonCenterNomalSubCollectionviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonCenterNomalSubCollectionviewTableViewCell_Identifier];
             if (!cell) {
                 cell = [[PersonCenterNomalSubCollectionviewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonCenterNomalSubCollectionviewTableViewCell_Identifier];
             }
             if (indexPath.section==5) {
                 [cell showInitWithType:PersoncenterSubCollectionviewCell_Type_MoreRrecommend andTitleArr:self.arrMoreRecommend imgArr:self.arrMoreRecommendImgName];//待后续增加类型
             }else if(indexPath.section==4){
                 [cell showInitWithType:PersoncenterSubCollectionviewCell_Type_House andTitleArr:self.arrRentHouse imgArr:self.arrRentHouseImgName];//房屋类型
             }else{
                 [cell showInitWithType:PersoncenterSubCollectionviewCell_Type_Nomal andTitleArr:self.arrCommonFunction imgArr:self.arrCommonFunctionImgName];
             }
             cell.nomalAndMoneyCellDelegate = self;
             return cell;
         }
     }else if(indexPath.section==PersonMainVC_SectionNum_Moeny){
         if (indexPath.row==0) {
             PersonCenterTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonCenterTitleTableViewCell_Identifier];
             if (!cell) {
                 cell = [[PersonCenterTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonCenterTitleTableViewCell_Identifier];
             }
             //
             cell.rightBtn.hidden = NO;
             [cell.rightBtn newAnBtnWithTextStr:@"我的钱包"];
             [cell.rightBtn newAnBtnWithImg:[UIImage imageNamed:@"rightSkip"]];
             [cell.rightBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
             [cell.rightBtn addTarget:self action:@selector(myMoneyRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
             //
             cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.secetionTitleArr[indexPath.section]];
             return cell;
         }else{
             PersonCenterNomalSubCollectionviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonCenterNomalSubCollectionviewTableViewCell_Identifier];
             if (!cell) {
                 cell = [[PersonCenterNomalSubCollectionviewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonCenterNomalSubCollectionviewTableViewCell_Identifier];
             }
             [cell showInitWithMoneyType:PersoncenterSubCollectionviewCell_Type_Money andTopTitleArr:self.arrMoneyTitle andBottomTitleArr:self.arrMoneyDetailTitle andMoneyCenterNumArr:self.arrMoneyCenterConenct];
             cell.nomalAndMoneyCellDelegate = self;
             return cell;
         }
     }else{
         //vip po indexPath.section1 row0
         PersonMembersVipAdTableViewCell *cell = [[PersonMembersVipAdTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonMembersVipAdTableViewCell_Identifier];
         [cell.rightOpenVipBtn addTarget:self action:@selector(rightOpenVipBtnAction) forControlEvents:UIControlEventTouchUpInside];
 //        cell.contentView.hidden = YES;//vip隐藏
         return cell;
     }
     
     
     
     */
    /**
     
     PersonMainVC_SectionNum_Order, 0
     PersonMainVC_SectionNum_Vip,  1
     PersonMainVC_SectionNum_CommonlyUsedFunctions, 2
     PersonMainVC_SectionNum_Moeny, 3
     PersonMainVC_SectionNum_House, 4
     PersonMainVC_SectionNum_More, 5
     */

   if(indexPath.section==PersonMainVC_SectionNum_CommonlyUsedFunctions||indexPath.section==PersonMainVC_SectionNum_House || indexPath.section==PersonMainVC_SectionNum_More){
        if (indexPath.row==0) {
            PersonCenterTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonCenterTitleTableViewCell_Identifier];
            if (!cell) {
                cell = [[PersonCenterTitleTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonCenterTitleTableViewCell_Identifier];
            }
            cell.titleLabel.text = [NSString stringWithFormat:@"%@", self.secetionTitleArr[indexPath.section]];
            if (indexPath.section== PersonMainVC_SectionNum_House) {
                cell.rightBtn.hidden = NO;
                [cell.rightBtn newAnBtnWithTextStr:@"租房管理"];
                [cell.rightBtn newAnBtnWithImg:[UIImage imageNamed:@"rightSkip"]];
                [cell.rightBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5];
                [cell.rightBtn addTarget:self action:@selector(issueManagerRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
                cell.rightBtn.hidden = YES;//0710 暂时隐藏本按钮 @"租房管理"换到原本 ‘商铺’管理的位置
            }else{
                cell.rightBtn.hidden = YES;
            }
            return cell;
        }else{
            PersonCenterNomalSubCollectionviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PersonCenterNomalSubCollectionviewTableViewCell_Identifier];
            if (!cell) {
                cell = [[PersonCenterNomalSubCollectionviewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonCenterNomalSubCollectionviewTableViewCell_Identifier];
            }
            if (indexPath.section == PersonMainVC_SectionNum_More) {
                [cell showInitWithType:PersoncenterSubCollectionviewCell_Type_MoreRrecommend andTitleArr:self.arrMoreRecommend imgArr:self.arrMoreRecommendImgName];//待后续增加类型
            }else if(indexPath.section == PersonMainVC_SectionNum_House){
                [cell showInitWithType:PersoncenterSubCollectionviewCell_Type_House andTitleArr:self.arrRentHouse imgArr:self.arrRentHouseImgName];//房屋类型
            }else{
                [cell showInitWithType:PersoncenterSubCollectionviewCell_Type_Nomal andTitleArr:self.arrCommonFunction imgArr:self.arrCommonFunctionImgName];
            }
            cell.nomalAndMoneyCellDelegate = self;
            return cell;
        }
    }else{
        //vip po indexPath.section1 row0
        PersonMembersVipAdTableViewCell *cell = [[PersonMembersVipAdTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PersonMembersVipAdTableViewCell_Identifier];
        [cell.rightOpenVipBtn addTarget:self action:@selector(rightOpenVipBtnAction) forControlEvents:UIControlEventTouchUpInside];
//        cell.contentView.hidden = YES;//vip隐藏
        return cell;
    }
}

#pragma mark ===
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    /**保留
    if (indexPath.section==PersonMainVC_SectionNum_Order||indexPath.section==PersonMainVC_SectionNum_Vip) {//第一行和会员广告cell
        return;
    }
     */
 
    
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
    return _headerView;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _myTableView.estimatedSectionFooterHeight = 0.01;
        _myTableView.estimatedSectionHeaderHeight = 0.01;
//        _myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = [UIColor clearColor];
    }
    return _myTableView;
}
- (NSArray *)secetionTitleArr{
    if (!_secetionTitleArr) {
        /**保留
         _secetionTitleArr = [[NSArray alloc]initWithObjects:@"",@"",@"常用功能",@"我的钱包",@"租房服务",@"更多推荐", nil]; //订单0 VIP1 常用功能2...
         */
        _secetionTitleArr = [[NSArray alloc]initWithObjects:@"常用功能",@"租房服务",@"更多推荐", nil];//订单0 VIP1 常用功能2....
    }
    return _secetionTitleArr;
}
- (NSMutableArray *)arrTop{
    if (!_arrTop) {
        _arrTop = [[NSMutableArray alloc]init];
    }
    return _arrTop;
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
- (NSMutableArray *)arrMoreRecommend{
    if (!_arrMoreRecommend) {
        _arrMoreRecommend  = [[NSMutableArray alloc]init];
    }
    return _arrMoreRecommend;
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
//
- (NSMutableArray *)arrTopImgName{
    if (!_arrTopImgName) {
        _arrTopImgName = [[NSMutableArray alloc]init];
    }
    return _arrTopImgName;
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
- (NSMutableArray *)arrMoreRecommendImgName{
    if (!_arrMoreRecommendImgName) {
        _arrMoreRecommendImgName = [[NSMutableArray alloc]init];
    }
    return _arrMoreRecommendImgName;
}
@end
