//
//  BuyRecordVc.m
//  Community
//
//  Created by 余莹 on 2021/2/4.
//

#import "BuyRecordVc.h"
#import "BuyRecordVcTableViewCell.h"
#define  BuyRecordVcTableViewCell_Identifier                    @"BuyRecordVcTableViewCell"
@interface BuyRecordVc ()

@end

@implementation BuyRecordVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买记录";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = Y_RGBA(245, 245, 245, 1);
    self.tableView.tableFooterView = [UIView new];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle];
}
- (void)initData{
    self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:@"续费干饭会员：月卡",@"会员加量包：（2张x5元）",@"开通干饭会员：月卡", nil];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return  self.dataSourceArr .count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuyRecordVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BuyRecordVcTableViewCell_Identifier];
    if (!cell) {
        cell = [[BuyRecordVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BuyRecordVcTableViewCell_Identifier];
    }
    cell.titleL.text =  self.dataSourceArr[indexPath.section];
    cell.detailL.text = @"充值时间：2020-12-10";
    cell.rightL.text = @"￥15";
    return cell;
}
 
 

@end
