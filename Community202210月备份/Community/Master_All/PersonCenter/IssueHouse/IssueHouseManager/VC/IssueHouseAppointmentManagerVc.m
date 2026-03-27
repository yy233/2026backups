//
//  IssueHouseAppointmentManager.m
//  Community
//
//  Created by 余莹 on 2021/4/1.
// 住房 预约管理

#import "IssueHouseAppointmentManagerVc.h"
//
#import "IssueHouseAppointmentManagerHeaderView.h"
//
#import "IssueHouseAppointmentManagerVcBaseTableViewCell.h"
#define  IssueHouseAppointmentManagerVcWillDealTableViewCell_Identifier             @"IssueHouseAppointmentManagerVcWillDealTableViewCell"
#define  IssueHouseAppointmentManagerVcWillLookHouseTableViewCell_Identifier        @"IssueHouseAppointmentManagerVcWillLookHouseTableViewCell"
#define  IssueHouseAppointmentManagerVcIsCancelledHouseTableViewCell_Identifier     @"IssueHouseAppointmentManagerVcIsCancelledTableViewCell"
#define  IssueHouseAppointmentManagerVcEndTableViewCell_Identifier                  @"IssueHouseAppointmentManagerVcEndTableViewCell"

//
#import "IssueHouseAppointmentManagerVcViewModel.h"
//
#import "IssueHouseAppointmentManagerVcModel.h"

#define H_WillCell  190
#define H_edCell    150
@interface IssueHouseAppointmentManagerVc () <IssueHouseAppointmentManagerHeaderViewDelegate,IssueHouseAppointmentManagerVcBaseTableViewCellDelegate>
//
@property (nonatomic,strong) UIButton *rightBtn;
//
@property (nonatomic,assign) IssueHouseAppointment_TopView_Type thisListType;// reserveStatus:预约状态
@property (nonatomic,strong) IssueHouseAppointmentManagerHeaderView *headerView;

@end

@implementation IssueHouseAppointmentManagerVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"租房管理";
    self.thisListType = IssueHouseAppointment_TopView_Type_All;
    [self addRefresh];
    [self initView];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle];
}
#pragma mark === addRefresh
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)initData{
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithObject:@(self.thisListType) forKey:@"reserveStatus"];
    WEAKSELF
    if (self.myIdentityType==IssueHouseManagerVC_MyType_FangDong) {
        [IssueHouseAppointmentManagerVcViewModel getIsFangDongTypeAppointmentListWithParms:parms withListBlocl:^(NSArray * arr, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_header endRefreshing];
            });
            if (success) {
                self.dataSourceArr = [NSMutableArray arrayWithArray:[IssueHouseAppointmentManagerVcModel mj_objectArrayWithKeyValuesArray:arr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }];
    }
    if (self.myIdentityType==IssueHouseManagerVC_MyType_ZuKe) {
        [IssueHouseAppointmentManagerVcViewModel getIsZuHuTypeAppointmentListWithParms:parms withListBlocl:^(NSArray * arr, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_header endRefreshing];
            });
            if (success) {
                self.dataSourceArr = [NSMutableArray arrayWithArray:[IssueHouseAppointmentManagerVcModel mj_objectArrayWithKeyValuesArray:arr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }];
    }
  
}
#pragma mark == action
- (void)headerViewChooseType:(IssueHouseAppointment_TopView_Type)type{
    DLog(@"%lu",(unsigned long)type);
    self.thisListType = type;
    [self initData];
    [self.tableView reloadData];
}

#pragma mark == delegate
//接受
- (void)cellTouchAcceptBtnWithModel:(IssueHouseAppointmentManagerVcModel *)model{
    WEAKSELF
    [IssueHouseAppointmentManagerVcViewModel acceptHouseAppintmentFangDongTypeWithThisAppintmentId:model.ID withDicBlock:^(NSDictionary * dic , BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"已接受");
            });
            [weakSelf initData];
        }
    }];
}
//取消
- (void)cellTouchCancelBtnWithModle:(IssueHouseAppointmentManagerVcModel *)model{
    if (self.myIdentityType==IssueHouseManagerVC_MyType_ZuKe) {//租客取消预约
        WEAKSELF
        [IssueHouseAppointmentManagerVcViewModel cancelHouseAppintmentZuKeTypeWithThisAppintmentId:model.ID withDicBlock:^(NSDictionary * dic , BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(@"已取消");
                });
                [weakSelf initData];
            }
        }];
    }
    if (self.myIdentityType==IssueHouseManagerVC_MyType_FangDong) {//房东取消预约
        WEAKSELF
        [IssueHouseAppointmentManagerVcViewModel cancelHouseAppintmentFangDongTypeWithThisAppintmentId:model.ID withDicBlock:^(NSDictionary * dic , BOOL success) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    Y_SVP_SHOW_SUCCESS_MES(@"已取消");
                });
                [weakSelf initData];
            }
        }];
    }
}
//看房结束
- (void)cellTouchFinishLookHouseBtnWithModle:(IssueHouseAppointmentManagerVcModel *)model{
    WEAKSELF
    [IssueHouseAppointmentManagerVcViewModel finishOkHouseAppintmentZuKeTypeWithThisAppintmentId:model.ID withDicBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(@"已完成本次看房");
            });
            [weakSelf initData];
        }
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.thisListType) {
        case IssueHouseAppointment_TopView_Type_WillDeal:
        {
            return H_WillCell;
        }
            break;
        case IssueHouseAppointment_TopView_Type_WillLookHouse:
        {
            return H_WillCell;
        }
            break;
        case IssueHouseAppointment_TopView_Type_Cancelled:
        {
            return H_edCell;
        }
            break;
        case IssueHouseAppointment_TopView_Type_End:
        {
            return H_edCell;
        }
            break;
        default: //all——list
        {
            IssueHouseAppointmentManagerVcModel *model =  self.dataSourceArr[indexPath.row];
            switch (model.reserveStatus) {//预约状态
                case IssueHouseAppointment_TopView_Type_WillDeal:
                {
                    return H_WillCell;
                }
                    break;
                case IssueHouseAppointment_TopView_Type_WillLookHouse:
                {
                    return H_WillCell;
                }
                    break;
                case IssueHouseAppointment_TopView_Type_Cancelled:
                {
                    return H_edCell;
                }
                    break;
                default:
                    // case IssueHouseAppointment_TopView_Type_End:
                {
                    return H_edCell;
                }
                    break;
            }
        }
            break;
    }
    return H_WillCell;
   
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (self.thisListType) {
        case IssueHouseAppointment_TopView_Type_WillDeal:
        {
            return [self tableView:tableView willDealCellForRowAtIndexPath:indexPath];
        }
            break;
        case IssueHouseAppointment_TopView_Type_WillLookHouse:
        {
            return [self tableView:tableView willLookHouseCellForRowAtIndexPath:indexPath];
        }
            break;
        case IssueHouseAppointment_TopView_Type_Cancelled:
        {
            return [self tableView:tableView isCancelledCellForRowAtIndexPath:indexPath];
        }
            break;
        case IssueHouseAppointment_TopView_Type_End:
        {
            return [self tableView:tableView isFinishedCellForRowAtIndexPath:indexPath];
        }
            break;
        default://all——list
        {
            IssueHouseAppointmentManagerVcModel *model =  self.dataSourceArr[indexPath.row];
            switch (model.reserveStatus) {//预约状态
                case IssueHouseAppointment_TopView_Type_WillDeal:
                {
                    return [self tableView:tableView willDealCellForRowAtIndexPath:indexPath];
                }
                    break;
                case IssueHouseAppointment_TopView_Type_WillLookHouse:
                {
                    return [self tableView:tableView willLookHouseCellForRowAtIndexPath:indexPath];
                }
                    break;
                case IssueHouseAppointment_TopView_Type_Cancelled:
                {
                    return [self tableView:tableView isCancelledCellForRowAtIndexPath:indexPath];
                }
                    break;
                default:
                    // case IssueHouseAppointment_TopView_Type_End:
                {
                    return [self tableView:tableView isFinishedCellForRowAtIndexPath:indexPath];
                }
                    break;
            }
        }
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView willDealCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IssueHouseAppointmentManagerVcWillDealTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueHouseAppointmentManagerVcWillDealTableViewCell_Identifier];
    if (!cell) {
        cell = [[IssueHouseAppointmentManagerVcWillDealTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHouseAppointmentManagerVcWillDealTableViewCell_Identifier];
    }
    IssueHouseAppointmentManagerVcModel *model = self.dataSourceArr[indexPath.row];
    [cell fillDataWithModle:model];
    if (self.myIdentityType==IssueHouseManagerVC_MyType_ZuKe) {
        [cell zuKeIsShowCancelBtn];
    }
    if(self.myIdentityType==IssueHouseManagerVC_MyType_FangDong){
        [cell fangDngIsShowAcceptBtn];
    }
    cell.delegate = self;
    return cell;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView willLookHouseCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IssueHouseAppointmentManagerVcWillLookHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueHouseAppointmentManagerVcWillLookHouseTableViewCell_Identifier];
    if (!cell) {
        cell = [[IssueHouseAppointmentManagerVcWillLookHouseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHouseAppointmentManagerVcWillLookHouseTableViewCell_Identifier];
    }
    IssueHouseAppointmentManagerVcModel *model = self.dataSourceArr[indexPath.row];
    [cell fillDataWithModle:model];
    if (self.myIdentityType==IssueHouseManagerVC_MyType_ZuKe) {
        [cell zuKeIsShowFinishLookHouseOkBtn];
    }
    if(self.myIdentityType==IssueHouseManagerVC_MyType_FangDong){
        [cell fangDngIsShowCancelBtn];
    }
    cell.delegate = self;
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView isCancelledCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IssueHouseAppointmentManagerVcIsCancelledTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueHouseAppointmentManagerVcIsCancelledHouseTableViewCell_Identifier];
    if (!cell) {
        cell = [[IssueHouseAppointmentManagerVcIsCancelledTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHouseAppointmentManagerVcIsCancelledHouseTableViewCell_Identifier];
    }
    IssueHouseAppointmentManagerVcModel *model = self.dataSourceArr[indexPath.row];
    [cell fillDataWithModle:model];
    return cell;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView isFinishedCellForRowAtIndexPath:(NSIndexPath *)indexPath {
    IssueHouseAppointmentManagerVcEndTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IssueHouseAppointmentManagerVcEndTableViewCell_Identifier];
    if (!cell) {
        cell = [[IssueHouseAppointmentManagerVcEndTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IssueHouseAppointmentManagerVcEndTableViewCell_Identifier];
    }
    IssueHouseAppointmentManagerVcModel *model = self.dataSourceArr[indexPath.row];
    [cell fillDataWithModle:model];
    return cell;
}


#pragma mark ==
- (void)initView{
    [self initNavRightItem];
    self.tableView.backgroundColor = Color_245Gray;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
}
- (void)initNavRightItem{
    NSString *titleStr = @"切换为房东";
    if (self.myIdentityType==IssueHouseManagerVC_MyType_ZuKe) {
        titleStr = @"切换为房东";
    }
    if (self.myIdentityType==IssueHouseManagerVC_MyType_FangDong) {
        titleStr = @"切换为租客";
    }
    [self.rightBtn setTitle:titleStr forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    [self.navigationItem setRightBarButtonItems:@[rightItem]];
}
- (void)rightBtnAction:(UIButton *)sender{
    if (self.myIdentityType==IssueHouseManagerVC_MyType_ZuKe) {
        self.myIdentityType = IssueHouseManagerVC_MyType_FangDong;
        [self.rightBtn newAnBtnWithTextStr:@"切换为租客"];
        //换列表数据
        [self initData];
        return;
    }
    if (self.myIdentityType==IssueHouseManagerVC_MyType_FangDong) {
        self.myIdentityType = IssueHouseManagerVC_MyType_ZuKe;
        [self.rightBtn newAnBtnWithTextStr:@"切换为房东"];
        //换列表数据
        [self initData];
        return;
    }
  
}
#pragma mark==
- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}
- (IssueHouseAppointmentManagerHeaderView *)headerView{ 
    if (!_headerView) {
        _headerView = [[IssueHouseAppointmentManagerHeaderView alloc]initWithFrame:CGRectZero];
        _headerView.delegate = self;
    }
    return _headerView;
}
@end
