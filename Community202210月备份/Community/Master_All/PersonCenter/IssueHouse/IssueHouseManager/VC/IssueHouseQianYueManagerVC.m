//
//  IssueHouseQianYueManagerVC.m
//  Community
//
//  Created by 余莹 on 2021/8/26.
//

#import "IssueHouseQianYueManagerVC.h"
#import "ZYLandlordPendingListVc.h"
#import "ZYSigningDetailVC.h"
#import "ZYRentContractDetailVC.h"

#import "IssueHouseManagerVcLate.h"
#import "IssueHouseManagerHeaderView.h"
#import "IssueHouseManagerVcTopAddTableViewCell.h"
//#define  IssueHouseManagerVcTopAddTableViewCell_Identifier          @"IssueHouseManagerVcTopAddTableViewCell"
#import "IssueHouseManagerVcTopTwoBtnsTableViewCell.h"
#define  IssueHouseManagerVcTopTwoBtnsTableViewCell_Identifier      @"IssueHouseManagerVcTopTwoBtnsTableViewCell"
//#import "IssueHouseManagerVcHouseTableViewCell.h"
//#define  IssueHouseManagerVcHouseTableViewCell_Identifier      @"IssueHouseManagerVcHouseTableViewCell"

#import "IssueHouseManagerVcHouseTableViewCellLate.h"
#define  IssueHouseManagerVcHouseTableViewCellLate_Identifier      @"IssueHouseManagerVcHouseTableViewCellLate"

#import "IssuHouseQianYueManagerVcHouseTableViewCell.h"
#define  IssuHouseQianYueManagerVcHouseTableViewCell_Identifier     @"IssuHouseQianYueManagerVcHouseTableViewCell"


//
#import "IssueHouseAppointmentManagerVc.h"
//
#import "IssueManagerViewModel.h"// 房东身份时 发布的列表数据 (商铺 房屋)
//
#import "IssHouseManagerDetailVC.h"

//0710增 自己发布的商铺
#import "IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderView.h" //
#import "IssBuniessShopManagerDetailVC.h"
#import "IssueHouseMainVc.h"

#import "IssuHouseQianYueManagerVcModel.h"
#import "IssuBuniessQianYueManagerVcModel.h"


#define   Color_2Green    Y_RGBA(2, 195, 168, 1)
#define   Tag_Buniess_Btn 200
#define   Tag_Btn         300

//#define  Section_Num_AddNew                         0
#define  Section_Num_YuyueQianyue                   0
#define  Section_Num_BuniessCellOrHouseCell         1

@interface IssueHouseQianYueManagerVC ()<IssueHouseManagerHeaderViewDelegate,IssueHouseManagerVcTopAddTableViewCellDelegate,IssueHouseManagerVcTopTwoBtnsTableViewCellDelegate,IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderViewDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) IssueHouseManagerHeaderView *headerView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderView *houseOrBuniessSectionHeaderView;
@property (nonatomic,strong) NSMutableArray *buniessShopArr;
@property (nonatomic,assign) BOOL isShowHouseList;//房屋 商铺切换
@property (nonatomic,strong) NSMutableArray *sectionKeyArr;//组键值
@property (nonatomic,strong) NSMutableDictionary *allDataSourceDic;//全部数据
@property (nonatomic,strong) PopViewWithMoreServiceWillBeOpeningUp *popViewMoreServiceWillOpening;
@end

@implementation IssueHouseQianYueManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sectionKeyArr = [[NSMutableArray alloc]init];
    self.allDataSourceDic = [[NSMutableDictionary alloc]init];
    self.buniessShopArr = [[NSMutableArray alloc]init];
    self.isShowHouseList = YES;
    [self initView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarStyleWithMainColorWhenWitheNavIsWwBackIsCountViewBackBulue];
   
//    [self setupNavigationBarTextColor:[UIColor whiteColor] andBarItemsColor:[UIColor whiteColor] andBackViewCustomColor: [ThemeManager shareManager].themeContentBackGroundColor];
    [self initBottomNowTypeAllListData];//取消某发布成功时需要 新增后返回到本页 需要
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setupNavigationBarStyleWithMainColorWhenWitheNavIsWwBackIsCountViewBackBulue];// setupNavigationBarStyleWithMainColorWhenWitheTypeNavBackgroundViewIsWw];
}

- (void)chooseHouseOrBuniessSectionHeaderViewWithIsShowBuniessListBool:(BOOL)isShowBuniessListBool{
    self.isShowHouseList = !isShowBuniessListBool;
    if (isShowBuniessListBool) {
       // Y_SVP_SHOW_ERR_MES(@"商铺暂未开放");
        self.isShowHouseList = YES;
        [self showPopViewWithMoreServiceWillBeOpen];
        return;
    }
    [self initBottomNowTypeAllListData];//商铺 房屋 切换时 需要
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
#pragma mark === view
- (void)initView{
    self.title = @"我的租赁";
    [self initNavRightItem];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    self.tableView.tableHeaderView = self.headerView;
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_footerView.superview);
        make.bottom.equalTo(_footerView.superview).offset(-KIndicatorHeight);
        make.height.offset(50);
    }];
//
    self.headerView.nameL.text = [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.realName];
    self.headerView.phoneL.text =  [TextShowWithModelStr textShowWithModelStr:[ShareUserInfo sharedUserInfo].userInfo.mobile];
  
    //
    if (self.myType == IssueHouseManagerVC_MyType_ZuKe || self.myType == IssueHouseManagerVC_MyType_FangDong) {
        self.headerView.changeBtn.hidden = NO;
        if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 1) {//业主权限1
            self.headerView.changeBtn.hidden = YES;//保持租客身份 不显示切换按钮
        }
    }else{
        self.headerView.changeBtn.hidden = YES;
    }
    [self changeManagerVcMyType:self.myType];
}
- (void)initNavRightItem{
    if ([UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel > 1 ) {
        return;//最高权限为业主时 才可以有房屋管理按钮
    }
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn newAnBtnWithFont:[UIFont systemFontOfSize:13]];
    [rightBtn newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
    [rightBtn newAnBtnWithTextStr:@"房屋管理"];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItems:@[rightItem]];
}
- (void)rightBtnAction{
    DLog(@"");
//    Y_SVP_SHOW_INFO_MES(@"rightBtnAction");
    IssueHouseManagerVcLate *vc = [[IssueHouseManagerVcLate alloc]init];
    vc.myType = IssueHouseManagerVC_MyType_FangDong;
    [self pushVc:vc];
}
#pragma mark ==
- (void)changeManagerVcMyType:(IssueHouseManagerVC_MyType)type{
    self.myType = type;
    DLog(@"");
    switch (self.myType) {
        case IssueHouseManagerVC_MyType_ZuKe:
            self.headerView.changeBtn.selected = NO;
//            [self.tableView setSeparatorColor:[UIColor lightGrayColor]];
            self.footerView.hidden = YES;//租客状态不能发布房源
            break;
        case IssueHouseManagerVC_MyType_FangDong:
            self.headerView.changeBtn.selected = YES;
//            [self.tableView setSeparatorColor:[UIColor clearColor]];//使之有颜色
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.footerView.hidden = NO;
            break;
        default:
            [self.tableView setSeparatorColor:[UIColor clearColor]];
            break;
    }
    [self.tableView reloadData];
    [self initBottomNowTypeAllListData];
}
//0901数据待改
- (void)initBottomNowTypeAllListData{
    WEAKSELF
    //身份类型;1:房东;2:租客
    NSInteger identityTypeNum = 0; 
    if (self.myType == IssueHouseManagerVC_MyType_FangDong){ //房东身份 发布过的house 列表
        identityTypeNum = 1;
    }
    if (self.myType == IssueHouseManagerVC_MyType_ZuKe) {//
        identityTypeNum = 2;
    }
     
    if (self.isShowHouseList) {//房屋
        [IssueManagerViewModel qianYueHouseListWithFangDongOrZuKe:identityTypeNum initWithBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                DLog(@"");
                weakSelf.sectionKeyArr = [NSMutableArray arrayWithArray:[dic allKeys]];
                weakSelf.allDataSourceDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
//                    if (  weakSelf.sectionKeyArr.count == 0) {
//                        [weakSelf titleForEmptyDataSet:weakSelf.tableView];
//                        [weakSelf imageForEmptyDataSet:weakSelf.tableView];
//                        [weakSelf verticalOffsetForEmptyDataSet:weakSelf.tableView];//没效果
//                    }else{
//                    }
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }];
        
    }else{//商铺
        [IssueManagerViewModel qianYueBuniessListWithFangDongOrZuKe:identityTypeNum initWithBlock:^(NSDictionary * dic, BOOL success) {
            if (success) {
                DLog(@"");
                weakSelf.sectionKeyArr = [NSMutableArray arrayWithArray:[dic allKeys]];
                weakSelf.allDataSourceDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }];
        
    }
}
#pragma mark == action新增发布

- (void)cellTouchBtnWithAddAction{   //新增发布
    
    //20211020 需要实名才能发布
    //是否实名
    if (ZY_IsRealName) {
        //已经实名 可继续后面的判定
    }else {
        //没有实名 跳转去实名
        ZYElectronicRealNameAuthenticationVc *vc = [[ZYElectronicRealNameAuthenticationVc alloc]init];
        vc.otherShowDetailStr = nomalGotoRealNameShowStr;
        vc.hidesBottomBarWhenPushed = YES;
        [self pushVc:vc];
        return;
    }
    DLog(@"");
    //add 发布房源
    IssueHouseMainVc *issueHouse = [[IssueHouseMainVc alloc]init];
    issueHouse.hidesBottomBarWhenPushed = YES;
    [self pushVc:issueHouse];
}

#pragma mark == action预约
- (void)cellTouchYuyueAction{
//    [self goYuyueManagerVc];
}


#pragma mark == action签章
- (void)cellTouchQianyueAction{
    Y_SVP_SHOW_INFO_MES(@"当前功能暂未开放");//test
    DLog(@"");
}
#pragma mark ==
- (void)editBtnAction:(UIButton *)sender{
    if (!self.isShowHouseList) {
        return;
    }
    NSInteger index = sender.tag-Tag_Btn;
    HouseRentListVcHouseCellModel *model =  self.dataSourceArr[index];
    IssHouseManagerDetailVC *vc = [[IssHouseManagerDetailVC alloc]init];
    vc.IDNum = model.ID;
    vc.isManagerTypeLastCellIsChange = YES;
    [self pushVc:vc];
}
- (void)editBuniessBtnAction:(UIButton *)sender{
    if (self.isShowHouseList) {
        return;
    }
    NSInteger indx = sender.tag-Tag_Buniess_Btn;
    IssueBuniessShopManagerListUseModel *model = self.buniessShopArr[indx];
    IssBuniessShopManagerDetailVC *vc = [[IssBuniessShopManagerDetailVC alloc]init];
    vc.IDNum = model.ID;
    vc.isManagerTypeLastCellIsChange = YES;
    [self pushVc:vc];

}

#pragma mark ===预约
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.myType == IssueHouseManagerVC_MyType_ZuKe) {//租客身份 简单两行cell
//        if (indexPath.row==0) {//预约管理
//            [self goYuyueManagerVc];
//
//        }
//        if (indexPath.row==1) {
//            DLog(@"");
//        }
//
//    }
//}
//- (void)goYuyueManagerVc{
//    IssueHouseAppointmentManagerVc *vc = [[IssueHouseAppointmentManagerVc alloc]init];
//    vc.myIdentityType = self.myType;
//    [self pushVc:vc];
//
//}

 


#pragma mark - Table view data source
//0901 租客房东都改为拥有不同签约类型的组层级UI
/**
 已签约 未签约 签约中
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return (self.sectionKeyArr.count+1);// 已签约 未签约 签约中+(topTwoBtn的headerV 所需的cellview占位)
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        return 1;
    }else{
        NSString *sectionKey = self.sectionKeyArr[section-1];//0=twoBtn
        NSArray *anSectionArr = [self.allDataSourceDic objectForKey:sectionKey];
        return (anSectionArr.count+1);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 0.1;
    }else{
        if (indexPath.row==0) {
            return 40;//类型文本cell
        }else{
            return 120;//房屋显示cell
        }
    }
}

 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    if (section==0) {
        return 60;
    }else{
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
     
    if (section==0) {
        if (self.isShowHouseList) {
            self.houseOrBuniessSectionHeaderView.buniessBtn.selected = NO;
            self.houseOrBuniessSectionHeaderView.houseBtn.selected = YES;
            [self.houseOrBuniessSectionHeaderView.buniessBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
            [self.houseOrBuniessSectionHeaderView.houseBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15]];
        }else{
            self.houseOrBuniessSectionHeaderView.buniessBtn.selected = YES;
            self.houseOrBuniessSectionHeaderView.houseBtn.selected = NO;
            [self.houseOrBuniessSectionHeaderView.houseBtn newAnBtnWithFont:[UIFont systemFontOfSize:15]];
            [self.houseOrBuniessSectionHeaderView.buniessBtn newAnBtnWithFont:[UIFont boldSystemFontOfSize:15]];
        }
        return self.houseOrBuniessSectionHeaderView;
    }else{
        return [UIView new];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0) {
        UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"n"];
        if (!cell) {
            cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"n"];
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else{
        if (indexPath.row==0) {//类型文本cell
            UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if (!cell) {
                cell =  [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
                cell.backgroundColor = [UIColor clearColor];
                cell.contentView.backgroundColor = [UIColor clearColor];
                cell.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
            }
           
            NSString *sectionKey = self.sectionKeyArr[indexPath.section-1];//0=twoBtn
            if ([sectionKey isEqualToString: @"notContracted"]) {
                cell.textLabel.text = @"  未签约";
            }
            if ([sectionKey isEqualToString: @"underContract"]) {
                cell.textLabel.text = @"  签约中";
            }
            if ([sectionKey isEqualToString: @"contracted"]) {
                cell.textLabel.text = @"  已签约";
            }
            if ([sectionKey isEqualToString: @"expiredContracted"]) {
                cell.textLabel.text = @"  已过期";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
            cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
            return cell;
        }else{//房屋商铺展示cell
            
            if (self.isShowHouseList) {
                IssuHouseQianYueManagerVcHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssuHouseQianYueManagerVcHouseTableViewCell_Identifier];
                if (!cell) {
                    cell = [[IssuHouseQianYueManagerVcHouseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssuHouseQianYueManagerVcHouseTableViewCell_Identifier];
                }
                NSString *sectionKey = self.sectionKeyArr[indexPath.section-1];//0=twoBtn
                NSArray *thisSectionAllArr = [self.allDataSourceDic objectForKey:sectionKey];
                IssuHouseQianYueManagerVcModel *model = [IssuHouseQianYueManagerVcModel mj_objectWithKeyValues:thisSectionAllArr[indexPath.row-1]];//0=sectionTitleCell
                //
                cell.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.title];//title 新增时的描述
                cell.mongyL.text = [NSString stringWithFormat:@"¥%0.f",model.price];
                NSString *tagFirst = [model.houseAdvantageCode allKeys].firstObject;
                cell.typeL.text = [TextShowWithModelStr textShowWithModelStr:tagFirst];
                cell.detailTipL.text = [TextShowWithModelStr textShowWithModelStr:model.houseType];
                NSString *urlStr = [NSString stringWithFormat:@"%@",model.imageUrl];
                if (urlStr.length>0) {
                    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:urlStr]];
                }
                cell.editBtn.tag = indexPath.row + Tag_Btn;
                [cell.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                //红色数量和红点
                if (self.myType ==  IssueHouseManagerVC_MyType_ZuKe) {
                    //租客
                    cell.redNumL.hidden = YES;
                    if (model.readMark == 1) {
                        cell.redShowPoint.hidden = YES;
                    }else {
                        cell.redShowPoint.hidden = NO;
                    }
                }else {
                    //房东
                    if ([self.sectionKeyArr[indexPath.section-1] isEqual:@"notContracted"]) {//未签约 状态 才有红色数量
                        if (model.contractNumber >0) {
                            cell.redNumL.hidden = NO;
                            cell.redNumL.text = [NSString stringWithFormat:@"%ld", model.contractNumber];//房东该资产签约条数
                        }else{
                            cell.redNumL.hidden = YES;//为0则隐藏红色数量label
                        }
                    }else {
                        cell.redNumL.hidden = YES;
                    }
                    cell.redShowPoint.hidden = YES;
                }
                //蓝色tag
                [cell setTypeBackViewSubViews:model.houseAdvantageCode];
                return cell;
            }else{ //商铺列表数据
                IssuHouseQianYueManagerVcHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssuHouseQianYueManagerVcHouseTableViewCell_Identifier];
                if (!cell) {
                    cell = [[IssuHouseQianYueManagerVcHouseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssuHouseQianYueManagerVcHouseTableViewCell_Identifier];
                }
                
                NSString *sectionKey = self.sectionKeyArr[indexPath.section-1];//0=twoBtn
                NSArray *thisSectionAllArr = [self.allDataSourceDic objectForKey:sectionKey];
                IssuBuniessQianYueManagerVcModel *model = [IssuBuniessQianYueManagerVcModel mj_objectWithKeyValues:thisSectionAllArr[indexPath.row-1]];//0=sectionTitleCell
                //
                cell.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.title];//title 新增时的描述
                cell.mongyL.text = [NSString stringWithFormat:@"¥%0.f",model.price];
                NSString *tagFirst = [model.houseAdvantageCode allKeys].firstObject;
                cell.typeL.text = [TextShowWithModelStr textShowWithModelStr:tagFirst];
                cell.detailTipL.text = [TextShowWithModelStr textShowWithModelStr:model.summarize];//商铺描述文本
                NSString *urlStr = [NSString stringWithFormat:@"%@",model.imageUrl];
                if (urlStr.length>0) {
                    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:urlStr]];
                }
                cell.editBtn.tag = indexPath.row + Tag_Btn;
                [cell.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                //
                if (self.myType ==  IssueHouseManagerVC_MyType_ZuKe) {
                    cell.redNumL.hidden = YES;//暂时显示 簪没有键值控制
                    cell.redShowPoint.hidden = NO;
                }else{
                    cell.redNumL.text = [NSString stringWithFormat:@"%ld", model.contractNumber];//房东该资产签约条数____暂时
                    cell.redShowPoint.hidden = YES;
                }
                //蓝色tag
                [cell setTypeBackViewSubViews:model.houseAdvantageCode];
                return cell;
            }
           
        }
    }
    
}
#pragma mark --------------------- 去签约相关流程
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return;
    }else{
        if (indexPath.row==0) {
            return;
        }else{
            // 签约状态
            NSInteger contractStatus = 0;
            NSString *sectionKey = self.sectionKeyArr[indexPath.section-1];//0=twoBtn
            if ([sectionKey isEqualToString: @"notContracted"]) {
                contractStatus = 1; //未签约
            }else if ([sectionKey isEqualToString: @"underContract"]) {
                contractStatus = 2; //签约中
            }else if ([sectionKey isEqualToString: @"contracted"]) {
                contractStatus = 3; //已签约
            }else if ([sectionKey isEqualToString: @"expiredContracted"]) {
                contractStatus = 4; //已过期
            }
            NSArray *thisSectionAllArr = [self.allDataSourceDic objectForKey:sectionKey];
            IssuHouseQianYueManagerVcModel *model = [IssuHouseQianYueManagerVcModel mj_objectWithKeyValues:thisSectionAllArr[indexPath.row-1]];//0=sectionTitleCell
            //身份类型;1:房东;2:租客
            if (self.myType == IssueHouseManagerVC_MyType_ZuKe) {//租客身份
                NSLog(@"租客身份");
                if (model.operation == 6) {
                    ZYRentContractDetailVC *vc = [[ZYRentContractDetailVC alloc] init];
                    vc.contractId = [NSString stringWithFormat:@"%ld", model.ID];
                    vc.identityType = 2;
                    [self pushVc:vc];
                }else {
                    // 租赁签约详情
                    ZYSigningDetailVC *vc = [[ZYSigningDetailVC alloc] init];
                    vc.contractId = [NSString stringWithFormat:@"%ld", model.ID];
                    vc.identityType = 2;
                    vc.assetId = [NSString stringWithFormat:@"%ld", model.assetId];
                    vc.assetType = model.assetType;
                    vc.isRentDetail = NO;
                    [self pushVc:vc];
                }
            }else{//房东身份
                NSLog(@"房东身份");
                ZYLandlordPendingListVc *vc = [[ZYLandlordPendingListVc alloc] init];
                vc.assetType = model.assetType;
                vc.assetId = [NSString stringWithFormat:@"%ld", model.assetId];
                vc.contractStatus = contractStatus;
                [self pushVc:vc];
            }
        }
    
    }
  
}

#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return;//0为房屋商铺headerv按钮占位的组
    }
    if ([cell respondsToSelector:@selector(tintColor)]) {
        UIColor *separatoColor = [ThemeManager shareManager].themeLineColor ;//分割线颜色
        CGFloat cornerRadius = 7.0f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
            separatoColor =  [ThemeManager shareManager].themeLineColor ;//分割线颜色
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
            separatoColor = [UIColor clearColor];
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
//        layer.fillColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
//        layer.strokeColor=[ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
        layer.fillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
        layer.strokeColor=[ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
            lineLayer.backgroundColor = separatoColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}
//- (UITableViewCell *)fangDongTypeTableView:(UITableView *)tableView fangDongCellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (indexPath.section== Section_Num_YuyueQianyue){
//        IssueHouseManagerVcTopTwoBtnsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueHouseManagerVcTopTwoBtnsTableViewCell_Identifier];
//        if (!cell) {
//            cell = [[IssueHouseManagerVcTopTwoBtnsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHouseManagerVcTopTwoBtnsTableViewCell_Identifier];
//        }
//        //_______预约签章按钮 暂时隐藏
//        cell.yuyueBtn.hidden = YES;
//        cell.qianyueBtn.hidden = YES;
//        //_______
//        cell.delegate = self;
//        return cell;
//    }else{
//
//        //cell_model 仅用于商铺_ 商铺 走子类数据 ｜｜ 0710 合并房屋商铺
//        if (self.myType == IssueHouseManagerVC_MyType_FangDong){ //房东身份 发布过的house 列表 房屋列表数据
//
//            if (self.isShowHouseList) {
//                IssueHouseManagerVcHouseTableViewCellLate *cell = [tableView dequeueReusableCellWithIdentifier:IssueHouseManagerVcHouseTableViewCellLate_Identifier];
//                if (!cell) {
//                    cell = [[IssueHouseManagerVcHouseTableViewCellLate alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHouseManagerVcHouseTableViewCellLate_Identifier];
//                }
//                HouseRentListVcHouseCellModel *model = self.dataSourceArr[indexPath.row];
//                cell.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.houseTitle];//title 新增时的描述
//                cell.mongyL.text = [NSString stringWithFormat:@"¥%0.f",model.housePrice];
//                cell.typeL.text = [TextShowWithModelStr textShowWithModelStr:model.houseLeaseMode];
//                cell.detailTipL.text = [TextShowWithModelStr textShowWithModelStr:model.houseLeaseDeposit];
//                NSString *urlStr = [NSString stringWithFormat:@"%@",model.houseImage.firstObject];
//                if (urlStr.length>0) {
//                    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:urlStr]];
//                }
//                cell.editBtn.tag = indexPath.row + Tag_Btn;
//                [cell.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//                return cell;
//            }else{ //商铺列表数据
//                IssueHouseManagerVcHouseTableViewCellLate *cell = [tableView dequeueReusableCellWithIdentifier:IssueHouseManagerVcHouseTableViewCellLate_Identifier];
//                if (!cell) {
//                    cell = [[IssueHouseManagerVcHouseTableViewCellLate alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHouseManagerVcHouseTableViewCellLate_Identifier];
//                }
//                IssueBuniessShopManagerListUseModel *model = self.buniessShopArr[indexPath.row];
////                cell.model = model;//没啥用 此数据少 model键值多
//                cell.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.address];//本接口 文本 只有这个address可用于展示
//                cell.mongyL.text = [NSString stringWithFormat:@"¥%0.f",model.monthMoney];
//                cell.typeL.text = [TextShowWithModelStr textShowWithModelStr:model.statusString];
//                cell.detailTipL.text = [TextShowWithModelStr textShowWithModelStr:model.defrayType];
//                NSString *urlStr = [NSString stringWithFormat:@"%@",model.shopShowImg];
//                if (urlStr.length>0) {
//                    [cell.imgV sd_setImageWithURL:[NSURL URLWithString:urlStr]];
//                }
//                cell.editBtn.tag = indexPath.row + Tag_Buniess_Btn;
//                [cell.editBtn addTarget:self action:@selector(editBuniessBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//                return cell;
//            }
//
//        }else{
//            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
//            return cell;
//        }
//    }
//}
//
#pragma mark ==
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H-kNavBarHeight-50-KIndicatorHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}
#pragma mark - 无数据占位 本数据按钮切换占了一个section0cell不能自动调用 手动调
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *emptyTitle = @"暂无数据";
    NSDictionary *attributs = @{
        NSFontAttributeName:[UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor
    };
    return [[NSAttributedString alloc]initWithString:emptyTitle attributes:attributs];
}
//无数据占位
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
  return [UIImage imageNamed:@"Nomal_ZeroLongIcon"];//Nomal_ZeroWidthIcon
}
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return self.tableView.tableHeaderView.height * 0.5;
}
#pragma mark - 
- (IssueHouseManagerHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[IssueHouseManagerHeaderView alloc]initWithFrame:CGRectZero];
        _headerView.delegate = self;
    }
    return _headerView;
}
- (BaseTableViewFooterView *)footerView{
    if (!_footerView ) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, Screen_H -kNavBarHeight -50-KIndicatorHeight, Screen_W, 50)];//KIndicatorHeight底部高度
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W, 50)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"发布房源"];
        _footerView.footerBtn.layer.cornerRadius = 0.01;
        [_footerView.footerBtn addTarget:self action:@selector(cellTouchBtnWithAddAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderView *)houseOrBuniessSectionHeaderView{
    if (!_houseOrBuniessSectionHeaderView) {
        _houseOrBuniessSectionHeaderView = [[IssueHouseManagerVcChooseHouseOrBuniessSectionHeaderView alloc]initWithFrame:CGRectZero];
        _houseOrBuniessSectionHeaderView.delegate = self;
    }
    return _houseOrBuniessSectionHeaderView;
}

- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}
 
@end
