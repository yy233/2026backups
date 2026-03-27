//
//  ParkingMonthlyTenancyVC.m
//  Community
//
//  Created by 余莹 on 2021/8/6.
//

#import "ParkingMonthlyTenancyVC.h"
#import "ParkingMonthlyTenancyAddNewCarVC.h"
#import "ParkingMonthlyTenancyPayRenewalVC.h"

#import "ParkingMonthlyTenancyTableViewCell.h"
#define  ParkingMonthlyTenancyTableViewCell_Identifier  @"ParkingMonthlyTenancyTableViewCell"

#import "ParkingRenewalVC.h"
#import "ParkingCarBaseModel.h"
#import "ParkingCarData.h"
@interface ParkingMonthlyTenancyVC ()
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

@implementation ParkingMonthlyTenancyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"月租缴费";
    [self initView];
    [self addRefresh];
 
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDIsCountBlueAndWW];
    [self initData];
    
}
- (void)initView{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = self.footerView;
}
#pragma mark ==
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)initData{
    WEAKSELF
    [ParkingCarData parkingMonthlyTypeCarListWithBlock:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            weakSelf.dataSourceArr = [ParkingCarBaseModel mj_objectArrayWithKeyValuesArray:arr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
#pragma mark ==
//移除
- (void)deletActionWithRowNum:(NSInteger)rowNum{
    DLog();
    ParkingCarBaseModel *model = self.dataSourceArr[rowNum];
    WEAKSELF
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [ParkingCarData parkingDeletMonthCarWithParkCarInfoDic:@{@"id":@(model.ID)}.mutableCopy withBlock:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            Y_SVP_SHOW_SUCCESS_MES(@"删除成功");
            [weakSelf.dataSourceArr removeObjectAtIndex:rowNum];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
#pragma mark ==
//续费
- (void)renewWithRowNum:(NSInteger)rowNum{
    DLog();
//    ParkingMonthlyTenancyPayRenewalVC *vc = [[ParkingMonthlyTenancyPayRenewalVC alloc]init];
//    [self pushVc:vc];
    ParkingRenewalVC *vc = [[ParkingRenewalVC alloc]init];
    vc.model = self.dataSourceArr[rowNum];
    [self pushVc:vc];
}
- (void)deletWithRowNum:(NSInteger)rowNum{
    ParkingCarBaseModel *model = self.dataSourceArr[rowNum];
    NSString *carNameStr =  [TextShowWithModelStr textShowWithModelStr:model.carPlate];
    UIAlertController *rightSetAlertC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确认移除车辆%@吗？",carNameStr] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    WEAKSELF
    UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deletActionWithRowNum:rowNum];
    }];
    [rightSetAlertC addAction:alertActionCancel];
    [rightSetAlertC addAction:alertActionOk];
    [self presentViewController:rightSetAlertC animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ParkingMonthlyTenancyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ParkingMonthlyTenancyTableViewCell_Identifier];
    if (!cell) {
        cell = [[ParkingMonthlyTenancyTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ParkingMonthlyTenancyTableViewCell_Identifier];
    }
    //
    WEAKSELF
    cell.renewBlock = ^{
        [weakSelf renewWithRowNum:indexPath.row];
    };
    cell.deletBlock = ^{
        [weakSelf deletWithRowNum:indexPath.row];
    };
    ParkingCarBaseModel *model = self.dataSourceArr[indexPath.row];
    cell.nameL.text =  [TextShowWithModelStr textShowWithModelStr:model.carPlate];//@"渝D32R21";
    cell.carParkingAddressShowL.text =  [TextShowWithModelStr textShowWithModelStr:model.carPositionText]; //@"北站车库北站车";
    cell.remainingDayNumL.text = [NSString stringWithFormat:@"剩余天数：%ld天",model.remainingDays];
    NSString *bangDingTimeStr = [TextShowWithModelStr textShowWithModelStr:model.beginTime];
    cell.bangDingBeginTimeL.text =  [@"绑定时间："stringByAppendingString:( (bangDingTimeStr.length>11) ? [bangDingTimeStr substringToIndex:10] : bangDingTimeStr )];
    
    return cell;
}
 
#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 120)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"绑定月租车辆"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W-32, 50)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:20 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];

    }
    return _footerView;
}
- (void)footerBtnAction{
 
     ParkingMonthlyTenancyAddNewCarVC *vc = [[ParkingMonthlyTenancyAddNewCarVC alloc]init];
    [self pushVc:vc];
}
@end
