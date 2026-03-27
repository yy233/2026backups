//
//  HouseRentHouseDetailVc.m
//  Community
//
//  Created by 余莹 on 2020/12/30.
//

#import "HouseRentHouseDetailVc.h"
#import "HouseRentOfHouseAppointmentVC.h" //预约
#import "ZYChatVc.h"
#import "ZYSigningDetailVC.h"
#import "SystemMapNavigatioManger.h"//系统自导导航
#import "AllMapNavigatioManger.h"//众多导航



#import "HouseRentBuniessDetailVcChatApplyViewModel.h"
#import "HouserBuniessChatInfoModel.h"
#import "HouseRentDetailVcHouseUserModel.h"   //发布人信息model"
#import "HouseRentQianYueBeginViewModel.h"
#import "ShareSaveChatInfoWithAesKeyIvTcpIpPostUserTokenUUId.h"

#import "HouseRentDetailHouseTitleViewCell.h"
#import "HouseRentDetailHouseTextCell.h"
#import "HouseRentDetailHousesBlueTableViewCell.h"
#import "HouseRentDetailHousesDetailListTableViewCell.h"
#import "HouseRentDetailHousesDetailLocationTableViewCell.h"
#import "HouseRentDetailHousesDetailCallAndChatTableViewCell.h"
#import "HouseRentAllTypeUserInfoTableViewCell.h"
#define HouseRentDetailHouseTitleViewCell_Identifier                     @"HouseRentDetailHouseTitleViewCell"
#define HouseRentDetailHouseTextCell_Identifier                          @"HouseRentDetailHouseTextCell"
#define HouseRentDetailHousesBlueTableViewCell_Identifier                @"HouseRentDetailHousesBlueTableViewCell"
#define HouseRentDetailHousesDetailListTableViewCell_Identifier          @"HouseRentDetailHousesDetailListTableViewCell"
#define HouseRentDetailHousesDetailLocationTableViewCell_Identifier      @"HouseRentDetailHousesDetailLocationTableViewCell"
#define HouseRentDetailHousesDetailCallAndChatTableViewCell_Identifier   @"HouseRentDetailHousesDetailCallAndChatTableViewCell"
#define HouseRentUserInfoTableViewCell_Identifier                        @"HouseRentUserInfoTableViewCell"

//
#import "HouseRentDetailBuniessShopTitleViewCell.h"
#import "HouseRentDetailBuniessShopRedTextCell.h"
#define HouseRentDetailBuniessShopTitleViewCell_Identifier   @"HouseRentDetailBuniessShopTitleViewCell"
#define HouseRentDetailBuniessShopRedTextCell_Identifier     @"HouseRentDetailBuniessShopRedTextCell"
//
#import "HouseRentDemandListTipTableViewCell.h"
#define HouseRentDemandListTipTableViewCell_Identifier     @"HouseRentDemandListTipTableViewCell"
//
#import "HouseRentDetailHousesDetailListDanJianTypeTableViewCell.h"
#define HouseRentDetailHousesDetailListDanJianTypeTableViewCell_Identifier     @"HouseRentDetailHousesDetailListDanJianTypeTableViewCell"
 
//
#define row_num_titleCell 0
#define row_num_houseTypeAndOtherCell 1 //房屋类型等4个信息
#define row_num_advantageCell 2  //小蓝标label
#define row_num_detailListCell 0 //房屋简介
#define row_num_detailLocationCell 0 //房屋位置
#define row_num_detailBottomCallAndOnlineCell
#define row_num_userInfo 0 //用户实名否 展示cell
//
#define H_tableViewHeaderView 280
#define H_titleCell 100
#define H_houseTypeAndOtherCell 70
#define H_houseAdvantageCell 40
#define H_houseDetailListCell 200
#define H_houseDetailLocationCell (180+80)
#define H_houseDetailBottomCallAndOnlineCell 65
 
typedef enum : NSUInteger {
    HouseLeasemodeId_TypeEnum_ZhengZu , //整租
    HouseLeasemodeId_TypeEnum_DanJian , //单间
} HouseLeasemodeId_TypeEnum;

@interface HouseRentHouseDetailVc () <UITableViewDelegate,UITableViewDataSource,HouseRentDetailHousesDetailCallAndChatTableViewCellDelegate>
@property (nonatomic,strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) HouseRentDetailVcHouseUserModel *houseUserInfoModel; //发起人信息
@property (nonatomic,assign) HouseLeasemodeId_TypeEnum houseLeasemodeId_TypeEnum;
@end

@implementation HouseRentHouseDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title  = @"";
    
    self.houseUserInfoModel = [[HouseRentDetailVcHouseUserModel alloc]init];
    self.houseLeasemodeId_TypeEnum = 0;
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
    DLog(@"HouseRentHouseDetailVc ____ ");
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_Rent_House_Detail withParams:@{@"houseId":@(self.IDNum)}.mutableCopy finished:^(id responsObject, NSError *error) {
//    [[ToolOfNetWork sharedTools]YrequestGetURL:URL_Get_Rent_House_Detail withParams:@{@"houseId":@(self.id)}.mutableCopy finished:^(id responsObject, NSError *error) {
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
                NSDictionary *detailDic = [NSDictionary dictionaryWithDictionary:Y_ResponsObject_dataDic];
                self.houseModel = [HouseRentDetailVcHouseModel mj_objectWithKeyValues:detailDic];
                NSDictionary *userDic = ([[detailDic allKeys] containsObject:@"user"]) ? [detailDic objectForKey:@"user"] : [NSDictionary dictionary];
                self.houseUserInfoModel = [HouseRentDetailVcHouseUserModel mj_objectWithKeyValues:userDic];
                //1不限(默认) 2整租，4合租
                //房屋出租方式id  1不限(默认) 2整租，4合租
                if (self.houseModel.houseLeasemodeId == 2) {
                    self.houseLeasemodeId_TypeEnum = HouseLeasemodeId_TypeEnum_ZhengZu;
                }else if (self.houseModel.houseLeasemodeId == 8){
                    self.houseLeasemodeId_TypeEnum = HouseLeasemodeId_TypeEnum_DanJian;
                }else{//默认展示状态
                    self.houseLeasemodeId_TypeEnum = HouseLeasemodeId_TypeEnum_ZhengZu;
                }
//                if (self.houseModel.delete) {
//                    self.isManagerTypeLastCellIsChange = YES;//下架状态
//                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.cycleScrollView.imageURLStringsGroup = [[NSArray alloc]initWithArray:self.houseModel.houseImage];
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
    DLog(@"右按钮 收藏");
    if ([self shouldShowLoginVcOrBindVcBool]) {
        return;
    }

}
#pragma mark ===
//在线了解
- (void)houseRentOfOnLineChatWithModel:(HouseRentDetailVcHouseModel *)model{
    if ([self shouldShowLoginVcOrBindVcBool]) {
        return;
    }
    [self goToChatVc];
  
}
- (void)goToChatVc{
    //判定业主家属租客身份 游客等
    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 4) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
        [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
        return;;
    }
    if (isNil( self.houseModel.user)) {
        Y_SVP_SHOW_ERR_MES(@"用户信息 暂无即时通讯ID！");
        return;
    }
    NSString *imidStr = [[self.houseModel.user allKeys] containsObject:@"imId"] ? [self.houseModel.user objectForKey:@"imId"] : @"";
    if (imidStr.length<=0) {
        Y_SVP_SHOW_ERR_MES(@"用户信息 暂无即时通讯ID！");
        return;
    }
    WEAKSELF
    //非好友 房东类型 陌生人
    [ChatVcWillGoOneChatVcTool chatVcPushInfoWithClearnUseID:0  withImIdStr:imidStr withThisStrangerChatType:ChatVc_Stranger_Chat_Application_houserOrstranger withBlock:^(ZYChatVc * _Nonnull willPushVc, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf pushVc:willPushVc];
            });
        
        }
    }];
    
    /**
     //非好友的通信申请
     WEAKSELF
     [HouseRentBuniessDetailVcChatApplyViewModel HouseRentBuniessDetailVcChatApplyWithImIdStr:imidStr withBlock:^(NSDictionary * dic, BOOL success) {
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
                  vc.chatVcWillUseImId = imidStr;
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
//签约
- (void)houseRentOfQianYueActionWithModel:(HouseRentDetailVcHouseModel *)model{
    if ([self shouldShowLoginVcOrBindVcBool]) {
        return;
    }
    //同一用户提示
    if ([self.houseUserInfoModel.uid isEqualToString:[ShareUserInfo sharedUserInfo].userInfo.uid]) {
        [SVProgressHUD showInfoCustomHUDWithStatus:@"不能签约自己发起的房屋"];
        return;
    }
    //判定业主家属租客身份 游客等
    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 4) { //“accessLevel”：当前小区最高权限   1业主，2家属，3租客，4注册用户，5游客
        [SVProgressHUD showInfoCustomHUDWithStatus:@"暂无权限"];
        return;;
    }
    //
    // 租赁签约详情
    ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc] init];
    vc.contractId = self.houseModel.contractId;
    vc.identityType = 2;
    vc.assetId = [NSString stringWithFormat:@"%ld", self.houseModel.ID];
    vc.assetType = 2;
    vc.isRentDetail = YES;
    vc.houseDetailModel = self.houseModel;
    [self pushVc:vc];
    
//    // 发起签约申请
//    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
//    [parms setValue:@(self.houseModel.id) forKey:@"assetId"];//资产ID(房屋或商铺)
//    [parms setValue:@(2) forKey:@"assetType"];//资产类型;1:商铺;2:房屋
//    WEAKSELF
//    [HouseRentQianYueBeginViewModel  initiateQianYueWithHouseOrBuniessInfoDic:parms Block:^(NSDictionary * dic, BOOL success) {
//        if (success) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc]init];
//                [weakSelf pushVc:vc];
//            });
//        }
//    }];
}
#pragma mark ===
//预约
- (void)houseRentOfAppointmentActionWithModel:(HouseRentDetailVcHouseModel *)model{
    if ([self shouldShowLoginVcOrBindVcBool]) {
        return;
    }
    
    HouseRentOfHouseAppointmentVC *vc = [[HouseRentOfHouseAppointmentVC alloc]init];
    vc.houseRentId = model.ID;
    [self pushVc:vc];
}


#pragma mark ===
//导航
- (void)popGoToAction{
//    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"导航" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
////    __weak typeof(self) weakSelf = self;
//    UIAlertAction *oneAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    UIAlertAction *twoAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alertVC addAction:oneAction];
//    [alertVC addAction:twoAction];
//    [alertVC addAction:cancleAction];
//    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
//    [self presentViewController:alertVC animated:YES completion:nil];

    
//    [SystemMapNavigatioManger goToSystemMapNavigatioWithLat:self.houseModel.houseLat lon:self.houseModel.houseLon title:[TextShowWithModelStr textShowWithModelStr:self.houseModel.houseAddress]];
    [AllMapNavigatioManger  gotoAddressWithLat:self.houseModel.houseLat lon:self.houseModel.houseLon title:[TextShowWithModelStr textShowWithModelStr:self.houseModel.houseAddress]  andPresntVC:self];
}


#pragma mark == headerView
- (void)headerView{
    self.tableView.tableHeaderView = self.cycleScrollView;
}
#pragma mark ===
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 2;//
//    return 3;
//    return 4;
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }else if(section==1 || section==2 || section==3){
        return 1;
    }else{//位置 电话
        return 2;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 1;
    }
    return 20;
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
//            return H_titleCell;
            return [self.houseModel getHouseTitleCellAllHeight];
        }else if (indexPath.row==row_num_houseTypeAndOtherCell){
            return H_houseTypeAndOtherCell;
        }else{
            return H_houseAdvantageCell;
        }
    }else if (indexPath.section==1){//发布人信息
        return 90;
    }else if(indexPath.section==2){//出租要求
        CGFloat houseYqHeight  = [self.houseModel getLeaseRequireMapHeightAllHeight];
        if (houseYqHeight < 90) {
            houseYqHeight = 90;
        }
        return houseYqHeight;
    }else if(indexPath.section==3){
        if (indexPath.row==row_num_detailListCell) {//房屋介绍
            CGFloat houseIntroduceAll = 0.0;
            if (self.houseLeasemodeId_TypeEnum == HouseLeasemodeId_TypeEnum_ZhengZu) {
               houseIntroduceAll = [self.houseModel getHouseIntroduceHeightAllHeight];//整租
            }else{
                houseIntroduceAll = [self.houseModel getNotZhengZuIntroduceHeightAllHeight];//单间
            }
            if (houseIntroduceAll < 40) {
                houseIntroduceAll = 40;
            }
            return houseIntroduceAll;
        }
        return H_houseDetailListCell;
    }else{
        if (indexPath.row==row_num_detailLocationCell) {
            return H_houseDetailLocationCell;
        }else{
            return H_houseDetailBottomCallAndOnlineCell;
        }
        return H_houseDetailLocationCell;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row==row_num_titleCell) {//title
            HouseRentDetailHouseTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHouseTitleViewCell_Identifier];
            if (!cell) {
                cell = [[HouseRentDetailHouseTitleViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHouseTitleViewCell_Identifier];
            }
            cell.model = self.houseModel;
            return cell;
        
        }else if(indexPath.row==row_num_houseTypeAndOtherCell){//4个基本信息
            HouseRentDetailHouseTextCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHouseTextCell_Identifier];
            if (!cell) {
                cell = [[HouseRentDetailHouseTextCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHouseTextCell_Identifier];
            }
            cell.model = self.houseModel;
            return cell;
        }else{//蓝色小标
            HouseRentDetailHousesBlueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHousesBlueTableViewCell_Identifier];
            if (!cell) {
                cell = [[HouseRentDetailHousesBlueTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHousesBlueTableViewCell_Identifier];
            }
            cell.model = self.houseModel;
            return cell;
        }
    }else if(indexPath.section==1){//row_num_userInfo
        HouseRentAllTypeUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentUserInfoTableViewCell_Identifier];
        if (!cell) {
            cell = [[HouseRentAllTypeUserInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentUserInfoTableViewCell_Identifier];
        }
        [cell fillUserInfoWithHouseData: self.houseUserInfoModel];// 发布人个人信息数据 
        return cell;
    }else if (indexPath.section == 2){//出租要求
        HouseRentDemandListTipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDemandListTipTableViewCell_Identifier];
        if (!cell) {
            cell = [[HouseRentDemandListTipTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDemandListTipTableViewCell_Identifier];
        }
        cell.model = self.houseModel;
        return cell;
    }else if(indexPath.section==3){//房屋介绍   self.houseLeasemodeId_TypeEnum = HouseLeasemodeId_TypeEnum_DanJian;
        
        if (self.houseLeasemodeId_TypeEnum == HouseLeasemodeId_TypeEnum_ZhengZu) {
            HouseRentDetailHousesDetailListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHousesDetailListTableViewCell_Identifier];
            if (!cell) {
                cell = [[HouseRentDetailHousesDetailListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHousesDetailListTableViewCell_Identifier];
            }
            cell.model = self.houseModel;
            return cell;
        }else{//公共+房间设施
            
            HouseRentDetailHousesDetailListDanJianTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHousesDetailListDanJianTypeTableViewCell_Identifier];
            if (!cell) {
                cell = [[HouseRentDetailHousesDetailListDanJianTypeTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHousesDetailListDanJianTypeTableViewCell_Identifier];
            }
            cell.model = self.houseModel;
            return cell;
        }
        
    }else{//indexPath.section==2
        if (indexPath.row == row_num_detailLocationCell) {   //经纬度的地图cell
            HouseRentDetailHousesDetailLocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHousesDetailLocationTableViewCell_Identifier];
            if (!cell) {
                cell = [[HouseRentDetailHousesDetailLocationTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHousesDetailLocationTableViewCell_Identifier];
            }
            cell.model = self.houseModel;
            WEAKSELF
            cell.gotoBtnblock = ^{
                [weakSelf popGoToAction]; //DLog(@"导航按钮");
            };
            return cell;
        }else{
            if (self.isManagerTypeLastCellIsChange || self.houseModel.deleted) {//下架状态isManagerTypeLastCellIsChange //管理点到的详情 可编辑可下架按钮 +0719浏览记录详情 已经下架状态cell
                return [self tableView:tableView managerVcLastcellForRowAtIndexPath:indexPath];
            }else{//非管理点过去的。普通列表 浏览列表 点过去的 走数据
                HouseRentDetailHousesDetailCallAndChatTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:HouseRentDetailHousesDetailCallAndChatTableViewCell_Identifier];
                if (!cell) {
                    cell = [[HouseRentDetailHousesDetailCallAndChatTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRentDetailHousesDetailCallAndChatTableViewCell_Identifier];
                }
                cell.model = self.houseModel;
                cell.delegate = self;
                return cell;
            }
           
        }
        
    }
}
//用于子类 用于本类已经下架
- (UITableViewCell *)tableView:(UITableView *)tableView managerVcLastcellForRowAtIndexPath:(NSIndexPath *)indexPath{
     UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
     if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
         cell.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    }
    cell.textLabel.text = @"已下架";
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
 
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

@end
