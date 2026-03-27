//
//  HouseRentBuniessShopDetailVc.m
//  Community
//
//  Created by 余莹 on 2021/1/7.
//

#import "HouseRentBuniessShopDetailVc.h"
#import "ZYChatVc.h"
#import "ZYSigningDetailVC.h"
#import "SystemMapNavigatioManger.h"
#import "AllMapNavigatioManger.h"


#import "HouseRentBuniessDetailVcChatApplyViewModel.h"
#import "HouserBuniessChatInfoModel.h"
#import "HouseRentQianYueBeginViewModel.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"

#import "HouseRentDetailVcBuniessShopModelShopModel.h"
#import "HouseRentDetailVcBuniessShopModelUserModel.h"

//
#import "HouseRentDetailBuniessShopTitleViewCell.h"
#import "HouseRentDetailBuniessShopRedTextCell.h"
#import "HouseRentDetailBuniessShopInfoListCell.h"
#import "HouseRentDetailBuniessShopIntroducedCell.h"
#import "HouseRentDetailBuniessShopLocationTableViewCell.h"
#import "HouseRentDetailBuniessShopCallAndChatTableViewCell.h"
#import "HouseRentAllTypeUserInfoTableViewCell.h"

#import "PopViewWithMoreServiceWillBeOpeningUp.h"

#define HouseRentDetailBuniessShopTitleViewCell_Identifier   @"HouseRentDetailBuniessShopTitleViewCell"
#define HouseRentDetailBuniessShopRedTextCell_Identifier     @"HouseRentDetailBuniessShopRedTextCell"
#define HouseRentDetailBuniessShopInfoListCell_Identifier    @"HouseRentDetailBuniessShopInfoListCell"
#define HouseRentDetailBuniessShopIntroducedCell_Identifier  @"HouseRentDetailBuniessShopIntroducedCell"
#define HouseRentDetailBuniessShopLocationTableViewCell_Identifier     @"HouseRentDetailBuniessShopLocationTableViewCell"
#define HouseRentDetailBuniessShopCallAndChatTableViewCell_Identifier  @"HouseRentDetailBuniessShopCallAndChatTableViewCell"
#define HouseRentAllTypeUserInfoTableViewCell_Identifier               @"HouseRentAllTypeUserInfoTableViewCell"

 
//
#define row_num_titleCell 0
#define row_num_readTextCell 1 //3个上下信息
#define row_num_listDetailTextCell 2  //简介list8个
#define row_num_userCell 0  //发布人cell 0902增
#define row_num_introduceMsgCell 0  //介绍
#define row_num_mapLocationCell 1 //房屋位置地图
#define row_num_bottomCallAndOnlineCell 2
//
#define H_tableViewHeaderView 280
#define H_titleCell 100
#define H_shopRedTextCell 75
#define H_listCell 150
#define H_userCell 60
#define H_introduceMsgCell 60
#define H_mapLocationCell (180+80)
#define H_bottomCallAndOnlineCell 65

@interface HouseRentBuniessShopDetailVc ()<UITableViewDelegate,UITableViewDataSource,HouseRentDetailBuniessShopCallAndChatTableViewCellDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) HouseRentDetailVcBuniessShopModelShopModel *buniessShopShopModel;
@property (nonatomic,strong) HouseRentDetailVcBuniessShopModelUserModel *buniessShopUserModel;

//更多服务逐步开发提示
@property (nonatomic,strong) PopViewWithMoreServiceWillBeOpeningUp *popViewMoreServiceWillOpening;
@end

@implementation HouseRentBuniessShopDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"";
    self.buniessShopShopModel = [[HouseRentDetailVcBuniessShopModelShopModel alloc]init];
    self.buniessShopUserModel = [[HouseRentDetailVcBuniessShopModelUserModel alloc]init];
    [self initView];
    [self addRefresh];
    [self initData];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_header.alpha = 0.2;//
}
- (void)initData{
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_Rent_BuniessShop_Detail withParams:@{@"shopId":@(self.IDNum)}.mutableCopy finished:^(id responsObject, NSError *error) {
//    [[ToolOfNetWork sharedTools]YrequestGetURL:URL_Get_Rent_BuniessShop_Detail withParams:@{@"shopId":@(self.id)}.mutableCopy finished:^(id responsObject, NSError *error) {
        DLog(@"HouseRentHouseDetailVc ____ \n responsObject = %@ ,\n error= %@",responsObject,error);
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                if (isNil(Y_ResponsObject_dataDic)) {
                    self.isManagerTypeLastCellIsChange = YES;//下架状态
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [self.tableView reloadData];
                    });
                    return;
                }
                if (self.buniessShopUserModel.deleted==1) {
                    self.isManagerTypeLastCellIsChange = YES;//下架状态 有数据 且最后的chatcell 由此控制 变成已下架状态
                }
                NSDictionary *reDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                self.buniessShopShopModel = [HouseRentDetailVcBuniessShopModelShopModel mj_objectWithKeyValues:reDic[@"shop"]];
                self.buniessShopUserModel = [HouseRentDetailVcBuniessShopModelUserModel mj_objectWithKeyValues:reDic[@"user"]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.cycleScrollView.imageURLStringsGroup = self.buniessShopShopModel.imgPath;
                    [self.tableView reloadData];
                });
               
//                [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y-KNavBarHeight)];
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
          
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
- (void)initView{
//    [self navView];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_tableView.superview).insets(UIEdgeInsetsMake(-KNavBarHeight, 0, 0, 0));
    }];
    [self headerView];
 
}
#pragma mark == nav
- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];//nav的处理 暂不需要引用父类
    [self.navigationController setNavigationBarHidden:NO animated:YES];//chatVc 引起的hidden
    [self setupNavigationBarTransparentStyle];
}

- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];//nav的处理 暂不需要引用父类
    [self setupNavigationBarStyleWithMainColor];
}
- (void)navView{
    [self initRightNavItem];
}
- (void)initRightNavItem{
    UIButton *infoRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    infoRightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    [infoRightBtn setTitle:@"右按钮" forState:UIControlStateNormal];
//    [infoRightBtn setTitleColor:[ThemeManager shareManager].mainTextColor forState:UIControlStateNormal];
    [infoRightBtn newAnBtnWithImg:[UIImage imageNamed:@"Head_Collection"]];
    infoRightBtn.bounds = CGRectMake(0 , 0, 24, 24);
    [infoRightBtn addTarget:self action:@selector(infoRightItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoRightBarItem = [[UIBarButtonItem alloc]initWithCustomView:infoRightBtn];
    [self.navigationItem setRightBarButtonItem:infoRightBarItem animated:YES];
}
- (void)infoRightItemAction:(UIButton *)sender{
    DLog(@"··");
    if ([self shouldShowLoginVcOrBindVcBool]) {
        return;
    }

}
#pragma mark === 签约
- (void)buniessShopRentOfQianYue{
    
    [self showPopViewWithMoreServiceWillBeOpen];
    
//    if ([self shouldShowLoginVcOrBindVcBool]) {
//        return;
//    }//游客手机没绑定
//    //
//    DLog(@"签约");
//    if ([self.buniessShopUserModel.uid isEqualToString:[ShareUserInfo sharedUserInfo].userInfo.uid]) {
//        [SVProgressHUD showInfoCustomHUDWithStatus:@"不能签约自己发起的房屋"];
//        return;
//    }

//    // 租赁签约详情
//    ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc] init];
//    vc.contractId = self.buniessShopShopModel.contractId;
//    vc.identityType = 2;
//    vc.assetId = [NSString stringWithFormat:@"%ld", self.houseModel.id];
//    vc.assetType = 1;
//    vc.isRentDetail = YES;
//    vc.shopDetailModel = self.buniessShopShopModel;
//    [self pushVc:vc];
}
#pragma mark ===
//在线了解
- (void)buniessShopRentOfOnLineChat{
    if ([self shouldShowLoginVcOrBindVcBool]) {
        return;
    }

    [self goToChatVc];

}
- (void)goToChatVc{
    if ( isNil(self.buniessShopUserModel.imId) || self.buniessShopUserModel.imId.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"用户信息 暂无即时通讯ID！");
        return;
    }
    WEAKSELF
    //非好友 房东类型 陌生人

    [ChatVcWillGoOneChatVcTool chatVcPushInfoWithClearnUseID:0 withImIdStr:self.buniessShopUserModel.imId withThisStrangerChatType:ChatVc_Stranger_Chat_Application_houserOrstranger withBlock:^(ZYChatVc * _Nonnull willPushVc, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf pushVc:willPushVc];
            });
        
        }
    }];
    /**
     * //非好友的通信申请
     WEAKSELF
     [HouseRentBuniessDetailVcChatApplyViewModel HouseRentBuniessDetailVcChatApplyWithImIdStr:self.buniessShopUserModel.imId withBlock:^(NSDictionary * dic, BOOL success) {
         if (success) {
  
             NSString *ownHeaderImgUrlStr = [ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId sharedUserInfo].chatUserMyOwn.headImgMaxUrl;
             HouserBuniessChatInfoModel *chatInfoModel = [HouserBuniessChatInfoModel mj_objectWithKeyValues:dic];
             NSString *ownUUID = [TextShowWithModelStr textShowWithModelStr:chatInfoModel.userAccount];
             NSString *toUserHeaderImgUrlStr = [TextShowWithModelStr textShowWithModelStr:chatInfoModel.head_img_max_url];
             NSString *toUserUUID = [TextShowWithModelStr textShowWithModelStr:chatInfoModel.otherAccount];
             NSString *toUserNickName = [TextShowWithModelStr textShowWithModelStr:chatInfoModel.nickName];
             if (ownUUID.length<=0 || toUserUUID.length<=0) {
                 Y_SVP_SHOW_ERR_MES(@"用户信息 暂无即时通讯ID！");
                 return;
             }
 //            NSLog(@" \n ____________  非好友的通信申请 得到数据  \n %@ \n",[chatInfoModel.businessUser mj_keyValues]);
             dispatch_async(dispatch_get_main_queue(), ^{
                 ZYChatVc *vc = [[ZYChatVc alloc] init];
                 vc.thisChatVc_Seesion_type = ChatVc_Seesion_type_Friend;
                 vc.friendNickName = toUserNickName.length>0 ? toUserNickName  : @"房主";// top名字 暂用联系名不用chat昵称
                 vc.friendUUID =  toUserUUID;
                  vc.chatVcWillUseImId = self.buniessShopUserModel.imId;
                 vc.isMoShengRenTypeBoolNotShowRightItem = YES;
                 [weakSelf pushVc:vc];
             });
         }else{
             Y_SVP_SHOW_ERR_MES(@"请求聊天失败。");
             return;
         }
        
     }];
     
     */
   
}
#pragma mark ===
//导航
- (void)popGoToAction{
    /**
     UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"导航" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
 //    __weak typeof(self) weakSelf = self;
     UIAlertAction *oneAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         
     }];
     UIAlertAction *twoAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         
     }];
     UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
     [alertVC addAction:oneAction];
     [alertVC addAction:twoAction];
     [alertVC addAction:cancleAction];
     alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
     [self presentViewController:alertVC animated:YES completion:nil];
     */

    //[SystemMapNavigatioManger goToSystemMapNavigatioWithLat:self.buniessShopShopModel.lat lon:self.buniessShopShopModel.lon title:[TextShowWithModelStr textShowWithModelStr:self.buniessShopShopModel.address]];
    [AllMapNavigatioManger  gotoAddressWithLat:self.buniessShopShopModel.lat lon:self.buniessShopShopModel.lon title:[TextShowWithModelStr textShowWithModelStr:self.buniessShopShopModel.address]  andPresntVC:self];

}
 
#pragma mark == headerView
- (void)headerView{
    self.tableView.tableHeaderView = self.cycleScrollView;
}
#pragma mark ===
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 1;//tableview和顶部图片的距离
    }
    return 10;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }else if(section==1){
        return 1;
    }else if(section==2){
        return 3;
    }
    return 3;
}
 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //和vc同色 可透明
    UIView *sectionHeaderView = [[UIView alloc]init];
    sectionHeaderView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsNotWAndDrayIsDD;
    return sectionHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (indexPath.row==row_num_titleCell) {
            return [self.buniessShopShopModel getBuniessTitleCellAllHeight];
        }else if(indexPath.row==row_num_readTextCell){
            return H_shopRedTextCell;
        }else{
            return H_listCell;
        }
    }else if(indexPath.section==1){
        return H_userCell;
    }else{//房源介绍 位置 底部按钮
        if(indexPath.row==row_num_introduceMsgCell){
            return [self.buniessShopShopModel getBuniessIntroduceCellAllHeight];
        }else if(indexPath.row==row_num_mapLocationCell){
            return H_mapLocationCell;
        }else{
            return H_bottomCallAndOnlineCell;
        }
        
        return 100;
    }
    return 100;
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==row_num_titleCell) {
            HouseRentDetailBuniessShopTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailBuniessShopTitleViewCell_Identifier];
            if (!cell) {
                cell = [[HouseRentDetailBuniessShopTitleViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailBuniessShopTitleViewCell_Identifier];
            }
            cell.model = self.buniessShopShopModel;
            return cell;
            
        }else if(indexPath.row==row_num_readTextCell){
            HouseRentDetailBuniessShopRedTextCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailBuniessShopRedTextCell_Identifier];
            if (!cell) {
                cell = [[HouseRentDetailBuniessShopRedTextCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailBuniessShopRedTextCell_Identifier];
            }
            cell.model = self.buniessShopShopModel;
            return cell;
        }else{
            HouseRentDetailBuniessShopInfoListCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailBuniessShopInfoListCell_Identifier];
            if (!cell) {
                cell = [[HouseRentDetailBuniessShopInfoListCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailBuniessShopInfoListCell_Identifier];
            }
            cell.model = self.buniessShopShopModel;
            return cell;
        }
    }else if(indexPath.section==1){//row_num_userInfo
        HouseRentAllTypeUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentAllTypeUserInfoTableViewCell_Identifier];
        if (!cell) {
            cell = [[HouseRentAllTypeUserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentAllTypeUserInfoTableViewCell_Identifier];
        }
        [cell fillUserInfoWithBuniesShopData:self.buniessShopUserModel];   // 发布人个人信息数据
        return cell;
        
    }else{
        if (indexPath.row==row_num_introduceMsgCell) {
            HouseRentDetailBuniessShopIntroducedCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailBuniessShopIntroducedCell_Identifier];
            if (!cell) {
                cell = [[HouseRentDetailBuniessShopIntroducedCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailBuniessShopIntroducedCell_Identifier];
            }
            cell.model = self.buniessShopShopModel;
            return cell;
        }else if(indexPath.row==row_num_mapLocationCell){
            HouseRentDetailBuniessShopLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailBuniessShopLocationTableViewCell_Identifier];
            if (!cell) {
                cell = [[HouseRentDetailBuniessShopLocationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailBuniessShopLocationTableViewCell_Identifier];
            }
            cell.buniessModel = self.buniessShopShopModel;
            WEAKSELF
            cell.gotoBtnblock = ^{
                [weakSelf popGoToAction]; //DLog(@"导航按钮");
            };
            return cell;
        }else{
            if (self.isManagerTypeLastCellIsChange || self.buniessShopShopModel.deleted) { //下架状态isManagerTypeLastCellIsChange //管理点到的详情 可编辑可下架按钮 +0719浏览记录详情 已经下架状态cell
                return [self tableView:tableView managerVcLastcellForRowAtIndexPath:indexPath];
            }else{
                HouseRentDetailBuniessShopCallAndChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailBuniessShopCallAndChatTableViewCell_Identifier];
                if (!cell) {
                    cell = [[HouseRentDetailBuniessShopCallAndChatTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailBuniessShopCallAndChatTableViewCell_Identifier];
                }
                cell.userModel = self.buniessShopUserModel;//user
                cell.buniessDelegate = self;
                return cell;
            }
           
        }
        
    }
         
}
//用于子类
- (UITableViewCell *)tableView:(UITableView *)tableView managerVcLastcellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
     if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = @"已下架";
    
    return cell;
}
 
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
//        if (indexPath.row==row_num_titleCell) {//title
//            HouseRentDetailHouseTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHouseTitleViewCell_Identifier];
//            if (!cell) {
//                cell = [[HouseRentDetailHouseTitleViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHouseTitleViewCell_Identifier];
//            }
//            cell.model = self.houseModel;
//            return cell;
//
//        }else if(indexPath.row==row_num_houseTypeAndOtherCell){//4个基本信息
//            HouseRentDetailHouseTextCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHouseTextCell_Identifier];
//            if (!cell) {
//                cell = [[HouseRentDetailHouseTextCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHouseTextCell_Identifier];
//            }
//            cell.model = self.houseModel;
//            return cell;
//        }else{//蓝色小标
//            HouseRentDetailHousesBlueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHousesBlueTableViewCell_Identifier];
//            if (!cell) {
//                cell = [[HouseRentDetailHousesBlueTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHousesBlueTableViewCell_Identifier];
//            }
//            cell.model = self.houseModel;
//            return cell;
//        }
//    }else if(indexPath.section==1){//房屋介绍
//        if (indexPath.row == row_num_detailListCell) {
//            HouseRentDetailHousesDetailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHousesDetailListTableViewCell_Identifier];
//            if (!cell) {
//                cell = [[HouseRentDetailHousesDetailListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHousesDetailListTableViewCell_Identifier];
//            }
//            cell.model = self.houseModel;
//            return cell;
//        }
//
//    }else{//indexPath.section==2
//        if (indexPath.row == row_num_detailLocationCell) {
//            HouseRentDetailHousesDetailLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHousesDetailLocationTableViewCell_Identifier];
//            if (!cell) {
//                cell = [[HouseRentDetailHousesDetailLocationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHousesDetailLocationTableViewCell_Identifier];
//            }
//            cell.model = self.houseModel;
//            return cell;
//        }else{
//            HouseRentDetailHousesDetailCallAndChatTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHousesDetailCallAndChatTableViewCell_Identifier];
//            if (!cell) {
//                cell = [[HouseRentDetailHousesDetailCallAndChatTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHousesDetailCallAndChatTableViewCell_Identifier];
//            }
//            cell.model = self.houseModel;
//            return cell;
//        }
//
//    }
//
//    HouseRentDetailHouseTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHouseTitleViewCell_Identifier];
//    if (!cell) {
//        cell = [[HouseRentDetailHouseTitleViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHouseTitleViewCell_Identifier];
//    }
//    cell.model = self.houseModel;
//    return cell;
//}
 
 

#pragma mark ==
- (SDCycleScrollView *)cycleScrollView{
   if (!_cycleScrollView) {
       _cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, H_tableViewHeaderView)];
       _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
       _cycleScrollView.currentPageDotColor = Y_RGBA(37, 95, 255, 1);
       _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
   }
   return _cycleScrollView;
}
- (UITableView *)tableView{
   if (!_tableView) {
       _tableView = [[UITableView alloc]init];
       _tableView.delegate = self;
       _tableView.dataSource = self;
       _tableView.backgroundColor = [ThemeManager shareManager].themeColorVCBackViewColor; 
       _tableView.tableFooterView = [UIView new];
       _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   }
   return _tableView;
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

#pragma mark ==  更多社区服务正在逐步开放中
//更多服务逐步开发提示PopViewWithMoreServiceWillBeOpeningUp
- (PopViewWithMoreServiceWillBeOpeningUp *)popViewMoreServiceWillOpening{
    _popViewMoreServiceWillOpening = [[PopViewWithMoreServiceWillBeOpeningUp alloc]init];
     return _popViewMoreServiceWillOpening;
}

- (void)showPopViewWithMoreServiceWillBeOpen{
    [self.popViewMoreServiceWillOpening showInView:self.view thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
}

@end
