//
//  MoneyWalletYuEMingXiDetailVc.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
//

#import "MoneyWalletYuEMingXiDetailVc.h"
#import "YuEMingXiDetailHeaderView.h"
@interface MoneyWalletYuEMingXiDetailVc ()
@property (nonatomic,strong) YuEMingXiDetailHeaderView *headerView;
@property (nonatomic,strong) NSMutableArray *arrWithCellDetailText;
@end

@implementation MoneyWalletYuEMingXiDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易详情";
    [self initView];
    [self initData];
}
- (void)initView{
//    self.view.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)initData{

    self.dataSourceArr = [NSMutableArray arrayWithObjects:@"交易类型",@"交易时间",@"流水单号",@"备注", nil];//
//    //cell__
//    [self.arrWithCellDetailText removeAllObjects];
//    if (self.type==YuEMingXi_Type_ZhiChu) {
//        [self.arrWithCellDetailText addObject:@"支出"];
//    }else if (self.type==YuEMingXi_Type_ShouRu) {
//        [self.arrWithCellDetailText addObject:@"收入"];
//    }else{
//        [self.arrWithCellDetailText addObject:@"未知"];
//    }
//    //
//    [self.arrWithCellDetailText addObject:@"2020-10-20 10:26"];
//    [self.arrWithCellDetailText addObject:@"2660865489645753"];
//    [self.arrWithCellDetailText addObject:@"美食"];
//    //header__
//    if (self.type==YuEMingXi_Type_ZhiChu) {
//        self.headerView.moneyL.text = @"-10";
//        self.headerView.bottomL.text = @"支出";
//    }else if (self.type==YuEMingXi_Type_ShouRu) {
//        self.headerView.moneyL.text = @"+200";
//        self.headerView.bottomL.text = @"收入";
//    }
//   //
    
    //cell__
    [self.arrWithCellDetailText removeAllObjects];
    [self.arrWithCellDetailText addObject:self.detailModel.tradeFromStr];
    //
    [self.arrWithCellDetailText addObject:self.detailModel.createTime];
    [self.arrWithCellDetailText addObject:self.detailModel.idStr];
    [self.arrWithCellDetailText addObject:self.detailModel.comment];
    //header__
    if (self.detailModel.tradeType == 1) {
        self.headerView.moneyL.text = [NSString stringWithFormat:@"+%@", self.detailModel.tradeAmountStr];
    }else if (self.detailModel.tradeType == 2) {
        self.headerView.moneyL.text = [NSString stringWithFormat:@"-%@", self.detailModel.tradeAmountStr];
    }
    if (self.detailModel.tradeType == 1) {
        self.headerView.bottomL.text = @"收入";
    }else if (self.detailModel.tradeType == 2) {
        self.headerView.bottomL.text = @"支出";
    }
   //

    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrWithCellDetailText.count;
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        cell.textLabel.textColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.7];//Color_153GrayColor;
        cell.detailTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
        cell.textLabel.font = FontSize_MoneyWallet_Nomail(13);
        cell.detailTextLabel.font = FontSize_MoneyWallet_Nomail(13);
    }
    cell.textLabel.text = self.dataSourceArr[indexPath.row];
    cell.detailTextLabel.text = self.arrWithCellDetailText[indexPath.row];
    return cell;
}
 
#pragma mark ==
- (YuEMingXiDetailHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YuEMingXiDetailHeaderView alloc]initWithFrame:CGRectZero];
    }
    return _headerView;
}

//
- (NSMutableArray *)arrWithCellDetailText{
    if (!_arrWithCellDetailText) {
        _arrWithCellDetailText = [[NSMutableArray alloc]init];
    }
    return _arrWithCellDetailText;
}
@end
