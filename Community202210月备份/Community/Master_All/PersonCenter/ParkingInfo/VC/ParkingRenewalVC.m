//
//  ParkingRenewalVC.m
//  Community
//
//  Created by 余莹 on 2021/8/27.
//   续费界面 新 0827

#import "ParkingRenewalVC.h"
#import "ParkingCarData.h"
#import "ParkingMonthlyTenancyPayRenewaGoPayingVC.h"
#import "MyHouseAddSubPersonTableViewCell.h"
#import "ParkingPayInfoTableViewCell.h"
#import "ParkingPayMonthlyNumBtnTableViewCell.h"
#define MyHouseAddSubPersonTableViewCellTextFeild_Identifier               @"MyHouseAddSubPersonTableViewCellTextFeild"
#define MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn_Identifier  @"MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn"
#define  ParkingPayInfoOnlyTextColorRedTableViewCell_Identifier            @"ParkingPayInfoOnlyTextColorRedTableViewCell"
#define  ParkingPayMonthlyNumBtnTableViewCell_Identifier                   @"ParkingPayMonthlyNumBtnTableViewCell"


#define ParkingAddCarCell_rowNum_MonthNum 0
#define ParkingAddCarCell_rowNum_AllMoney 1
@interface ParkingRenewalVC ()

@end

@implementation ParkingRenewalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"续费";
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDIsCountBlueAndWW];
}
 
- (void)initData{
    self.cellTitleArr = [[NSMutableArray alloc]initWithObjects:@"包月时长",@"付费金额", nil];
    self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:@"",@"", nil];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if(indexPath.row == ParkingAddCarCell_rowNum_MonthNum){
        ParkingPayMonthlyNumBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ParkingPayMonthlyNumBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[ParkingPayMonthlyNumBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ParkingPayMonthlyNumBtnTableViewCell_Identifier];
 
        }
        cell.titleL.text = self.cellTitleArr[indexPath.row];
//        cell.textF.text = @"";//@"包月 月份数据
        cell.monthlyNumChangeBlock = ^(NSInteger monthlyNum) {
            [self changeMoneyWithMonthlyNum:monthlyNum];
        };
         //月份数据
         if ( [self.dataSourceArr[indexPath.row] floatValue] == 0 ) {
             cell.textF.text = @"0";
             cell.monthlyN  = 0;//刷新后数据量不对的问题
         }else{
             cell.textF.text = self.dataSourceArr[indexPath.row];
             cell.monthlyN  = [self.dataSourceArr[indexPath.row] integerValue];
         }
         return cell;
     }else{//ParkingAddCarCell_rowNum_AllMoney
         BaseShowRedRightTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseShowRedRightTextTableViewCell"];
         if (!cell) {
             cell = [[BaseShowRedRightTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BaseShowRedRightTextTableViewCell"];
         }
         cell.titleL.text = self.cellTitleArr[indexPath.row];
         //
         if ( [self.dataSourceArr[indexPath.row] floatValue] == 0 ) {
             cell.textField.text = @"¥0";
         }else{
             cell.textField.text = [@"¥" stringByAppendingString:self.dataSourceArr[indexPath.row]];
         }
         return cell;
    }
}
 
#pragma mark ===
//更新月份
//更新金额
- (void)changeMoneyWithMonthlyNum:(NSInteger)monthlyNum{
    //
    double allMoney = ( self.saveDanJiaOfMonthly * monthlyNum);
    //没有单价时获取单价
    if (monthlyNum>0 && self.saveDanJiaOfMonthly == 0.0) {
        [self reqDanJiaWithOneMoney];
        return;
    }
    //
    [self.dataSourceArr  replaceObjectAtIndex:ParkingAddCarCell_rowNum_MonthNum withObject:[NSString stringWithFormat:@"%ld",monthlyNum]];
    [self.dataSourceArr  replaceObjectAtIndex:ParkingAddCarCell_rowNum_AllMoney withObject:[NSString stringWithFormat:@"%0.2f",allMoney]];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self reloadRowNum:ParkingAddCarCell_rowNum_MonthNum];
//        [self reloadRowNum:ParkingAddCarCell_rowNum_AllMoney];
        [self.tableView reloadData];
    });
}


- (void)footerBtnAction{
    DLog(@"去续费");
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
//    self.model;
    NSNumber *allMoney =  [self.dataSourceArr.lastObject numberValue];
    NSInteger month =  [self.dataSourceArr.firstObject intValue];
//    NSString *carPlateStr = self.model.carPlate;

    if ([allMoney isEqual:0] || month == 0) {
        Y_SVP_SHOW_ERR_MES(@"不能0个月！");
        return;
    }

    [parms setValue:allMoney forKey:@"money"];
    [parms setValue:@(month) forKey:@"month"];
    [parms setValue:@(self.model.ID) forKey:@"id"];//月租缴费列表的ID 用来续费
    WEAKSELF
    [ParkingCarData parkingRenewMonthCarWithParkCarInfoDic:parms withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            Y_SVP_SHOW_SUCCESS_MES(@"续费车辆需要进行缴费，等待缴费信息");
            NSString *dataOrderIdStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"OrderIdStr"]];
            DLog(@"parkingbindingMonthCarWithParkCarInfoDic %@ \n %@",dic,dataOrderIdStr);
            dispatch_async(dispatch_get_main_queue(), ^{
            //支付跳转
                ParkingMonthlyTenancyPayRenewaGoPayingVC *vc = [[ParkingMonthlyTenancyPayRenewaGoPayingVC alloc]init];
                vc.title = @"续费"; 
                vc.dataOrderIdStr = dataOrderIdStr;
                vc.moneyNum = [allMoney doubleValue];
                [weakSelf pushVc:vc];
            });
        }
    }];
}

@end
