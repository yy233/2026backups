//
//  BankCardVC.m
//  Community
//
//  Created by 余莹 on 2021/2/4.
//

#import "BankCardVC.h"
#import "BankCardVcFooterView.h"
#import "BankCardVcTableViewCell.h"
#define  BankCardVcTableViewCell_Identifier             @"BankCardVcTableViewCell"

#import "MoneyWalletAddBankCard.h"

@interface BankCardVC ()
@property (nonatomic,strong) BankCardVcFooterView *foooterWhiteView;
@end

@implementation BankCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的银行卡";
    self.view.backgroundColor = Color_245Gray;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; 
    self.tableView.tableFooterView = self.foooterWhiteView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setupNavigationBarWhiteStyle];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self setupNavigationBarTextColor:[UIColor clearColor] andBarItemsColor:[UIColor clearColor]  andBackViewCustomColor:[UIColor clearColor]];
}

- (void)footerBtnAddAction{
//    Y_SVP_SHOW_INFO_MES(@"footerBtnAddAction");
    MoneyWalletAddBankCard *vc = [[MoneyWalletAddBankCard alloc]init];
    [self pushVc:vc];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
//    return  self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 BankCardVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BankCardVcTableViewCell_Identifier];
    if (!cell) {
        cell = [[BankCardVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BankCardVcTableViewCell_Identifier];
    }
    cell.titleL.text = @"中国建设银行";
    cell.typeL.text = @"储蓄卡";
    cell.lastNumL.text = @"3580";
    cell.imgV.image = [UIImage imageNamed:@"My_Bankcard_ccb"];
    return cell;
}
 
 
//
- (BankCardVcFooterView *)foooterWhiteView{
    if (!_foooterWhiteView) {
        _foooterWhiteView = [[BankCardVcFooterView alloc]initWithFrame:CGRectZero];
        [_foooterWhiteView.footerBtnView.footerBtn addTarget:self action:@selector(footerBtnAddAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _foooterWhiteView;
}
@end
