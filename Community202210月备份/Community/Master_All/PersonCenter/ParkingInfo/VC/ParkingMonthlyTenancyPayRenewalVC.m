//
//  ParkingMonthlyTenancyPayRenewalVC.m
//  Community
//
//  Created by 余莹 on 2021/8/6.
//

#import "ParkingMonthlyTenancyPayRenewalVC.h"
//#import "ParkingMonthlyTenancyPayRenewalPopDatePickView.h"
#import "ParkingMonthlyTenancyPayRenewaGoPayingVC.h"

#import "MyHouseAddSubPersonTableViewCell.h"

#define MyHouseAddSubPersonTableViewCellTextFeild_Identifier  @"MyHouseAddSubPersonTableViewCellTextFeild"
#define MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn_Identifier  @"MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn"

#define RowNum_TitleNameShow 0
#define RowNum_BeginTime   1
#define RowNum_EndTime     2
#define RowNum_PayMoney    3
@interface ParkingMonthlyTenancyPayRenewalVC ()

@property (nonatomic,strong) NSMutableArray *cellTitleArr;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

@implementation ParkingMonthlyTenancyPayRenewalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"续费";
    self.tableView.tableFooterView = self.footerView;
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDIsCountBlueAndWW];
}
 
- (void)initData{
    self.cellTitleArr = [[NSMutableArray alloc]initWithObjects:@"续费项目:",@"开始时间",@"结束时间",@"付款金额",nil];
    self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:@"月租续费",@"",@"",@"", nil];
    //
    [self.dataSourceArr replaceObjectAtIndex:RowNum_PayMoney withObject:@"¥201"];
    [self.tableView reloadData];
}
#pragma mark ==
- (void)textFieldTopBtnActionWithRowNum:(NSInteger)rowNum{
        DLog(@"%ld",rowNum);
    switch (rowNum) {
        case RowNum_BeginTime:
        {
            [self showTimeChoosePickViewWithRowNum:rowNum];
        }
            break;
        case RowNum_EndTime:
        {
            [self showTimeChoosePickViewWithRowNum:rowNum];
        }
            break;
            
        default:
            break;
    }
}

- (void)showTimeChoosePickViewWithRowNum:(NSInteger)rowNum{
    DLog();
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"]; 
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    WEAKSELF
    [BRDatePickerView showDatePickerWithMode:BRDatePickerModeYMD title:@"" selectValue:dateStr resultBlock:^(NSDate * _Nullable selectDate, NSString * _Nullable selectValue) {
        if (rowNum == RowNum_BeginTime) {
            [weakSelf.dataSourceArr replaceObjectAtIndex:RowNum_BeginTime withObject:selectValue];
        }
        if (rowNum == RowNum_EndTime) {
//            if (weakSelf.dataSourceArr[RowNum_BeginTime]) {
//                Y_SVP_SHOW_ERR_MES(@"");
//            }
            [weakSelf.dataSourceArr replaceObjectAtIndex:RowNum_EndTime withObject:selectValue];
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNum inSection:0];
        [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return  self.cellTitleArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == RowNum_TitleNameShow ) {
        MyHouseAddSubPersonTableViewCellTextFeild *cell  = [tableView dequeueReusableCellWithIdentifier:@"titleCell"];
        if (!cell) {
            cell = [[MyHouseAddSubPersonTableViewCellTextFeild alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"titleCell"];
            [cell setTextShowBeginLeft];
        }
        cell.titleL.text = self.cellTitleArr[indexPath.row];
        cell.textField.userInteractionEnabled = NO;
        cell.textField.textColor = [ThemeManager shareManager].mainTextColor;
        cell.titleL.font = [UIFont boldSystemFontOfSize:15];
        cell.textField.font = [UIFont boldSystemFontOfSize:15];
        //
        cell.textField.text = self.dataSourceArr[indexPath.row];
        return cell;
    }else   if ( indexPath.row == RowNum_PayMoney ) {
        MyHouseAddSubPersonTableViewCellTextFeild *cell  = [tableView dequeueReusableCellWithIdentifier:MyHouseAddSubPersonTableViewCellTextFeild_Identifier];
        if (!cell) {
            cell = [[MyHouseAddSubPersonTableViewCellTextFeild alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseAddSubPersonTableViewCellTextFeild_Identifier];
            [cell setTextShowBeginLeft];
        }
        cell.titleL.text = self.cellTitleArr[indexPath.row];
        cell.textField.userInteractionEnabled = YES;
        cell.textField.textColor = Y_ColorWith16FromRGB(0xF12727);
        //
        cell.textField.text = self.dataSourceArr[indexPath.row];
        return cell;
  
    } else {
        MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn *cell  = [tableView dequeueReusableCellWithIdentifier:MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn_Identifier];
        if (!cell) {
            cell = [[MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn_Identifier];
            [cell setTextShowBeginLeft];
        }
        WEAKSELF
        cell.touchBtnBlock = ^{
            [weakSelf textFieldTopBtnActionWithRowNum:indexPath.row];
        };
        cell.titleL.text = self.cellTitleArr[indexPath.row];
        cell.textField.text = self.dataSourceArr[indexPath.row];
     
        return cell;
    }
}
 

#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 120)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"去支付"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W-32, 50)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:20 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];

    }
    return _footerView;
}
 
- (void)footerBtnAction{
    DLog(@"去支付");
    ParkingMonthlyTenancyPayRenewaGoPayingVC *vc = [[ParkingMonthlyTenancyPayRenewaGoPayingVC alloc]init];
//    dataOrderIdStr
    [self pushVc:vc];
}

@end
