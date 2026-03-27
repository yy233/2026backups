//
//  EIntergralMallOrderVC.m
//  Community
//
//  Created by 余莹 on 2021/2/22.
//

#import "EIntergralMallOrderVC.h"

#import "EIntergralMallOrderVcTableViewCell.h"
#define  EIntergralMallOrderVcTableViewCell_Identifier    @"EIntergralMallOrderVcTableViewCell"
//
#import "EIntergralMallOrderDetailVC.h"

@interface EIntergralMallOrderVC ()

@end

@implementation EIntergralMallOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    self.tableView.backgroundColor = Color_245Gray;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle];
}
- (void)initData{
    self.dataSourceArr = [NSMutableArray arrayWithObjects:@"", nil];
    [self.tableView reloadData];
}
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EIntergralMallOrderDetailVC *vc = [[EIntergralMallOrderDetailVC alloc]init];
    [self pushVc:vc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return 5;//dataSourceArr.c
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
        return 10;
 
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EIntergralMallOrderVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:EIntergralMallOrderVcTableViewCell_Identifier];
    if (!cell) {
        cell = [[EIntergralMallOrderVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:EIntergralMallOrderVcTableViewCell_Identifier];
    }
    cell.orderNumL.text = @"订单号：6758272758966433651";
    cell.goodsNameL.text = @"Beats头戴试耳机抽奖";
    cell.goodsNumL.text = @"x1";
    cell.outLineL.text = @"4天后过期";
    cell.eNumL.attributedText  =  [self getEnumLTextWithStr:@"实付: 200E币"];
    cell.imgV.image = [UIImage imageNamed:@"Ecoin_Product_one"];
    //
     return cell;
}
#pragma mark ==
- (NSMutableAttributedString *)getEnumLTextWithStr:(NSString *)str{
  
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
    NSUInteger length = [str length];
    //设置字体
    UIFont *baseFont =  FontSize_MoneyWallet_Nomail(14);// FontSize_MoneyWallet_Bold(15);
    [attrString addAttribute:NSFontAttributeName value:baseFont range:NSMakeRange(0, length)];//设置所有的字体
    // 设置颜色
    UIColor *colorRed = COlor_Red255;
    UIColor *colorGray =  [UIColor blackColor];//Color_138GrayColor;
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:colorGray
                       range:[str rangeOfString:@"实付: "]];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:colorRed
                       range:[str rangeOfString:@"200"]];
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:colorGray
                       range:[str rangeOfString:@"E币"]];
    return attrString;
}
 
@end
