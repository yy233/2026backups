//
//  LifeCostPayWillToPayListVC.m
//  Community
//
//  Created by 余莹 on 2022/1/8.
//

#import "LifeCostPayWillToPayListVC.h"

#import "LifeCostPayOrderDetailWithHaveMoneyNumWillToPayDetailVc.h"
#import "LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc.h"

#import "LifeCostPayWillToPayListModel.h"

@interface LifeCostPayWillToPayListVC ()
@property (nonatomic,strong) LabelYu *headerLabel;
@end

@implementation LifeCostPayWillToPayListVC
 
- (LabelYu *)headerLabel{
    if (!_headerLabel) {
        _headerLabel = [[LabelYu alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 30)];
        _headerLabel.backgroundColor = [UIColor clearColor];
        _headerLabel.textInsets = UIEdgeInsetsMake(0, 16, 0, 0);
        _headerLabel.text = @"选择账单";
        _headerLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];
        _headerLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _headerLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生活缴费";
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = self.headerLabel;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDDAndWW];
    self.tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
}
- (void)initData{
    WEAKSELF
    [LifeCostData lifeCostGetWillPayOrderListWithMyAccoundBillKeyStr:[TextShowWithModelStr textShowWithModelStr:self.oneAccountModel.account] withListBlock:^(NSArray * _Nonnull arr, BOOL success) {
        if (success) {
            weakSelf.dataSourceArr = [LifeCostPayWillToPayListModel mj_objectArrayWithKeyValuesArray:arr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"companyCell"  ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"companyCell"];
        cell.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
//        cell.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
        cell.detailTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Settings_arrow"]];
        cell.accessoryView = accessoryImgView;
    }
    LifeCostPayWillToPayListModel *model = self.dataSourceArr[indexPath.row];
    cell.textLabel.text =  [TextShowWithModelStr textShowWithNotNullStr:model.beginDate].length>0 ? [TextShowWithModelStr textShowWithNotNullStr:model.beginDate] : [TextShowWithModelStr textShowWithNotNullStr:model.createTime];
    NSString *moneyNumStr = [TextShowWithModelStr textShowWithNotNullStr:model.billAmount];
    if (moneyNumStr.length>0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"¥ %@",moneyNumStr];
    }else{
        cell.detailTextLabel.text  =  @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DLog(@"");
    LifeCostPayWillToPayListModel *model = self.dataSourceArr[indexPath.row];
    NSString *moneyNumStr = [TextShowWithModelStr textShowWithNotNullStr:model.billAmount]; 
    if (moneyNumStr.length>0) {
      //去缴费 (出了账单) | bf = 0
        LifeCostPayOrderDetailWithHaveMoneyNumWillToPayDetailVc *vc = [[LifeCostPayOrderDetailWithHaveMoneyNumWillToPayDetailVc alloc]init];
        vc.idStr = model.idStr;
        [self pushVc:vc];
    }


    //
    //        //去缴费 (预交)//bf = 1 (本列表是出了账单的情况为大概率,大概率在手机等缴费里出现)
    //        LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc *vc = [[LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc alloc]init];
    //        [self pushVc:vc];
            
    
}

 
@end
