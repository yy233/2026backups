//
//  HouseRepairVC.m
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import "HouseRepairListVC.h"
#import "HouseRepairEditVC.h"
#import "HouseRepairShowDismissResonVC.h"
//
#import "HouseRepairListBaseTableViewCell.h"
#define HouseRepairListWillDetailTableViewCell_Identifier     @"HouseRepairListWillDetailTableViewCell"
#define HouseRepairListDetailingTableViewCell_Identifier      @"HouseRepairListDetailingTableViewCell"
#define HouseRepairListEndDetailTableViewCell_Identifier      @"HouseRepairListEndDetailTableViewCell"
#define HouseRepairListDismissDetailTableViewCell_Identifier  @"HouseRepairListDismissDetailTableViewCell"

#define Cell_H 170
#define Cell_H_Ing 130
@interface HouseRepairListVC () <HouseRepairListVCHeaderViewDelegate,HouseRepairListBaseTableViewCellDelegate>
@property (nonatomic,strong) HouseRepairListVCHeaderView *headerView;
@property (nonatomic,strong) HouseRepairListVcFooterView *footerView;
@property (nonatomic,strong) NSMutableArray *allTypeDataSourceArr;
@property (nonatomic,strong) NSMutableArray *allStatusSaveArr;
@property (nonatomic,strong) NSMutableArray *willDealTypeDataSourceArr;
@property (nonatomic,strong) NSMutableArray *dealingTypeDataSourceArr;
@property (nonatomic,strong) NSMutableArray *endDealTypeDataSourceArr;
@property (nonatomic,strong) NSMutableArray *dismissTypeDataSourceArr;
@end

@implementation HouseRepairListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    self.nowListType = HouseRepair_List_DealType_All;
    [self addRefresh];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}
- (void)initView{
    self.title = @"报修单";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMoreData)];//暂无
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = KIndicatorHeight;
}
- (void)initData{//是全部数据 不分页
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_House_RepairList withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
           Y_SVP_DISMISS
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
         
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                    self.allTypeDataSourceArr = [NSMutableArray arrayWithArray:[HouseRepairListModel mj_objectArrayWithKeyValuesArray:Y_ResponsObject_dataArr]];
                    if (self.allTypeDataSourceArr.count==0) {
                        Y_SVP_SHOW_INFO_MES(@"当前暂无报修单");
                        return;
                    }
                    self.willDealTypeDataSourceArr  = [NSMutableArray array];
                    self.dealingTypeDataSourceArr  = [NSMutableArray array];
                    self.endDealTypeDataSourceArr  = [NSMutableArray array];
        
                    for (int i = 0 ;i < self.allTypeDataSourceArr.count; i++) {
                        if (i==0) {
                            self.allStatusSaveArr = [NSMutableArray array];
                        }
                        HouseRepairListModel *model = self.allTypeDataSourceArr[i];
                        [self.allStatusSaveArr addObject:@(model.status)];
                        if (model.status==HouseRepair_Status_Will) {
                            [self.willDealTypeDataSourceArr addObject:model];
                        }else if (model.status==HouseRepair_Status_Ing){
                            [self.dealingTypeDataSourceArr addObject:model];
                        }else if (model.status==HouseRepair_Status_End){
                            [self.endDealTypeDataSourceArr addObject:model];
                        }else if (model.status==HouseRepair_Status_Dismiss){
                            [self.dismissTypeDataSourceArr addObject:model];
                        }else{
                        }
                    }
    //                [self.allTypeDataSourceArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                      
    //                }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                });
               
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
- (void)footerLoadMoreData{//暂不用
}
#pragma mark === header footer
- (void)chooseHouseRepairListType:(HouseRepair_List_DealType)type{
    self.nowListType = type;
    [self.tableView reloadData];
}
- (void)footerBtnAction:(UIButton *)sender{
    NSLog(@"footerBtnAction---保修");
    HouseRepairEditVC *editVC = [[HouseRepairEditVC alloc]init];
    [self pushVc:editVC];
}
#pragma mark === cell sub btn delegate
//取消
- (void)removeThisRepairWithModel:(HouseRepairListModel *)model{
    NSLog(@"取消");
    WEAKSELF
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Post_House_Repari_cancelRepair withParams:@{@"id":@(model.ID)}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                Y_SVP_SHOW_SUCCESS_MES(@"已申请取消本次报修");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView.mj_header beginRefreshing];
                });
               
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
//评价
- (void)evaluatThisRepairWithModel:(HouseRepairListModel *)model{
    NSLog(@"评价");
    AdviceVc *vc = [[AdviceVc alloc]init];
    vc.houseRepairId =  model.ID;
    [self pushVc:vc];
}
//驳回原因
- (void)showDismissReasonWithModel:(HouseRepairListModel *)model{
    NSLog(@"展示驳回原因");
    HouseRepairShowDismissResonVC *vc = [[HouseRepairShowDismissResonVC alloc]init];
    vc.IDNum = model.ID;
    [self pushVc:vc];
    
}
#pragma mark === tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HouseRepairDetailShowVC *showVc = [[HouseRepairDetailShowVC alloc]init];
    switch (self.nowListType) {
        case HouseRepair_List_DealType_All:
        {
            HouseRepairListModel *mdoel = self.allTypeDataSourceArr[indexPath.row];
            showVc.IDNum =  mdoel.ID;
        }
            break;
        case HouseRepair_List_DealType_Will:
        {
            HouseRepairListModel *mdoel = self.willDealTypeDataSourceArr[indexPath.row];
            showVc.IDNum =  mdoel.ID;
        }
            break;
        case HouseRepair_List_DealType_Ing:
        {
            HouseRepairListModel *mdoel = self.dealingTypeDataSourceArr[indexPath.row];
            showVc.IDNum =  mdoel.ID;
        }
            break;
        case HouseRepair_List_DealType_End:
        {
            HouseRepairListModel *mdoel = self.endDealTypeDataSourceArr[indexPath.row];
            showVc.IDNum =  mdoel.ID;
        }
            break;
        case HouseRepair_List_DealType_Dismiss:
        {//驳回 详情页 增
            HouseRepairListModel *mdoel = self.dismissTypeDataSourceArr[indexPath.row];
            showVc.IDNum =  mdoel.ID;
        }
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:showVc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.nowListType) {
        case HouseRepair_List_DealType_All:
        {
            NSInteger st = [self.allStatusSaveArr[indexPath.row] intValue];
            switch (st) {
                    
                case HouseRepair_Status_Ing:
                    return Cell_H_Ing;
                    break;
                default:
                    return Cell_H;;
                    break;
            }
            return Cell_H;
            break;
        }
           
            break;
         
        case HouseRepair_List_DealType_Ing:
            return Cell_H_Ing;;
            break;
        default:
            return Cell_H;
            break;
    }
    return Cell_H;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (self.nowListType) {
        case HouseRepair_List_DealType_All:
        {
            return self.allTypeDataSourceArr.count;
        }
            break;
        case HouseRepair_List_DealType_Will:
        {
            return self.willDealTypeDataSourceArr.count;
        }
            break;
        case HouseRepair_List_DealType_Ing:
        {
            return self.dealingTypeDataSourceArr.count;
        }
            break;
        case HouseRepair_List_DealType_End:
        {
            return self.endDealTypeDataSourceArr.count;
        }
            break;
        case HouseRepair_List_DealType_Dismiss:
        {
            return self.dismissTypeDataSourceArr.count;
        }
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HouseRepairListModel *model = [[HouseRepairListModel alloc]init];
    switch (self.nowListType) {
        case HouseRepair_List_DealType_All:
        {
            model = self.allTypeDataSourceArr[indexPath.row];
            NSInteger st = [self.allStatusSaveArr[indexPath.row] intValue];
            switch (st) {
                case HouseRepair_Status_Will:
                {
                    return [self tableView:tableView willDetailCellForRowAtIndexPath:indexPath withModel:model];
                }
                    break;
                case HouseRepair_Status_Ing:
                {
                    return [self tableView:tableView detailIngCellForRowAtIndexPath:indexPath withModel:model];
                }
                    break;
                case HouseRepair_Status_End:
                {
                    return [self tableView:tableView endDetailCellForRowAtIndexPath:indexPath withModel:model];
                }
                    break;
                case HouseRepair_Status_Dismiss:
                {
                    return [self tableView:tableView dismissDetailCellForRowAtIndexPath:indexPath withModel:model];
                }
                    break;
            }
        }
            break;
        case HouseRepair_List_DealType_Will:
        {
 
            model = self.willDealTypeDataSourceArr[indexPath.row];
            return [self tableView:tableView willDetailCellForRowAtIndexPath:indexPath withModel:model];
        }
            break;
        case HouseRepair_List_DealType_Ing:
        {
            model = self.dealingTypeDataSourceArr[indexPath.row];
            return [self tableView:tableView detailIngCellForRowAtIndexPath:indexPath withModel:model];

        }
            break;
        case HouseRepair_List_DealType_End:
        {
            model = self.endDealTypeDataSourceArr[indexPath.row];
            return [self tableView:tableView endDetailCellForRowAtIndexPath:indexPath withModel:model];

        }
            break;
        case HouseRepair_List_DealType_Dismiss:
        {
            model = self.dismissTypeDataSourceArr[indexPath.row];
            return [self tableView:tableView dismissDetailCellForRowAtIndexPath:indexPath withModel:model];
        }
            break;
    }
    return [self tableView:tableView endDetailCellForRowAtIndexPath:indexPath withModel:model];//
}
- (UITableViewCell *)tableView:(UITableView *)tableView  willDetailCellForRowAtIndexPath:(NSIndexPath *)indexPath withModel:(HouseRepairListModel*)model{
    HouseRepairListWillDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairListWillDetailTableViewCell_Identifier];
    if (!cell) {
        cell = [[HouseRepairListWillDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairListWillDetailTableViewCell_Identifier];
    }
    cell.model = model;
    cell.delegate = self;
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView  detailIngCellForRowAtIndexPath:(NSIndexPath *)indexPath withModel:(HouseRepairListModel*)model{
    HouseRepairListDetailingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairListDetailingTableViewCell_Identifier];
    if (!cell) {
        cell = [[HouseRepairListDetailingTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairListDetailingTableViewCell_Identifier];
    }
    cell.model = model;
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView  endDetailCellForRowAtIndexPath:(NSIndexPath *)indexPath withModel:(HouseRepairListModel*)model{
    HouseRepairListEndDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairListEndDetailTableViewCell_Identifier];
    if (!cell) {
        cell = [[HouseRepairListEndDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairListEndDetailTableViewCell_Identifier];
    }
    cell.model = model;
    cell.delegate = self;
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView  dismissDetailCellForRowAtIndexPath:(NSIndexPath *)indexPath withModel:(HouseRepairListModel*)model{
    HouseRepairListDismissDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairListDismissDetailTableViewCell_Identifier];
    if (!cell) {
        cell = [[HouseRepairListDismissDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HouseRepairListDismissDetailTableViewCell_Identifier];
    }
    cell.model = model;
    cell.delegate = self;
    return cell;
}
#pragma mark === getter
#pragma mark ==
- (NSMutableArray *)allStatusSaveArr{
    if (!_allStatusSaveArr) {
        _allStatusSaveArr = [[NSMutableArray alloc]init];
    }
    return _allStatusSaveArr;
}
- (NSMutableArray *)allTypeDataSourceArr{
    if (!_allTypeDataSourceArr) {
        _allTypeDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _allTypeDataSourceArr;
}
- (NSMutableArray *)willDealTypeDataSourceArr{
    if (!_willDealTypeDataSourceArr) {
        _willDealTypeDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _willDealTypeDataSourceArr;
}
- (NSMutableArray *)dealingTypeDataSourceArr{
    if (!_dealingTypeDataSourceArr) {
        _dealingTypeDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dealingTypeDataSourceArr;
}
- (NSMutableArray *)endDealTypeDataSourceArr{
    if (!_endDealTypeDataSourceArr) {
        _endDealTypeDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _endDealTypeDataSourceArr;
}
- (NSMutableArray *)dismissTypeDataSourceArr{
    if (!_dismissTypeDataSourceArr) {
        _dismissTypeDataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dismissTypeDataSourceArr;
}
#pragma mark ==
- (HouseRepairListVCHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HouseRepairListVCHeaderView alloc]initWithFrame:CGRectZero];
        _headerView.delegate = self;
    }
    return _headerView;
}
- (HouseRepairListVcFooterView *)footerView{
    if (!_footerView) {
//        _footerView = [[HouseRepairListVcFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 44)];
//        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction:) forControlEvents:UIControlEventTouchUpInside];//父类有
        _footerView = [[HouseRepairListVcFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 80)];
        [_footerView.footerBtn setTitle:@"我要报修" forState:UIControlStateNormal];
    }
    return _footerView;
}
@end
