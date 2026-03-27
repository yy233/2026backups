//
//  RedCardListVC.m
//  Community
//
//  Created by 余莹 on 2021/2/4.
//

#import "RedCardListVC.h"
#import "RedCardListHeaderView.h"
#import "RedCardListVcTableViewCell.h"
#define  RedCardListVcTableViewCell_Identifier                   @"RedCardListVcTableViewCell"

@interface RedCardListVC () <RedCardListHeaderViewDelegate>
@property (nonatomic,strong) RedCardListHeaderView *headerVeiw;
@property (nonatomic,assign) RedCardListHeaderView_subType thisListShowType;
@end

@implementation RedCardListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红包卡券";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = Y_RGBA(245, 245, 245, 1);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = self.headerVeiw;
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle]; 
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self setupNavigationBarTextColor:[UIColor clearColor] andBarItemsColor:[UIColor clearColor]  andBackViewCustomColor:[UIColor clearColor]];
}
- (void)initData{
    self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:@"配送商家券：菜大全",@"医学美容：10元红包",@"配送每日好券：配送商家券：曼味轻食·沙拉·健身 餐抵用券", nil];
    [self.headerVeiw fillData:@{}.mutableCopy];
    [self.tableView reloadData];
}
- (RedCardListHeaderView *)headerVeiw{
    if (!_headerVeiw) {
        _headerVeiw = [[RedCardListHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 60)];
        _headerVeiw.delegate = self;
    }
    return _headerVeiw;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return   self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;//145
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
//    switch (self.thisListShowType) {
//        case RedCardListHeaderView_subType_All:
//        {
//        }
//            break;
//        default:
//        {
//        }
//            break;
//    }
    //
    RedCardListVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RedCardListVcTableViewCell_Identifier];
    if (!cell) {
        cell = [[RedCardListVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:RedCardListVcTableViewCell_Identifier];
    }
    cell.bttomL.text = @"满25.0元可用。可与其他活动优惠同时享受。在线支付专享。仅门店新客可用";
    cell.moneyL.text = @"¥15";
    cell.typeL.text = @"优惠券";
    cell.titleL.text = self.dataSourceArr[indexPath.section];
    cell.deadLineTimeL.text = @"2021-08-31 23:00";
    return cell;
}
 
- (void)headerViewChangeTypeWith:(RedCardListHeaderView_subType)type{
    NSString *str = [NSString stringWithFormat:@"theaderViewChangeTypeWith    ype =%d",type];
//    Y_SVP_SHOW_INFO_MES(str)
    DLog(@"%@",str);
    switch (type) {
        case RedCardListHeaderView_subType_All:
        {
            self.thisListShowType  = RedCardListHeaderView_subType_All;
            [self.tableView reloadData];
        }
            break;
        case RedCardListHeaderView_subType_YouhuiQuan:
        {
            self.thisListShowType  = RedCardListHeaderView_subType_YouhuiQuan;
            [self.tableView reloadData];
        }
            break;
        case RedCardListHeaderView_subType_KaQuan:
        {
            self.thisListShowType  = RedCardListHeaderView_subType_KaQuan;
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
 
}
 
@end
