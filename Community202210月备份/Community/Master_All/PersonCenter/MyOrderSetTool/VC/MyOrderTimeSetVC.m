//
//  MyOrderTimeSetVC.m
//  Community
//
//  Created by 余莹 on 2021/2/18.
// 点餐提醒

#import "MyOrderTimeSetVC.h"
#import "PopViewMyOrderTimeSet.h"
#import "MyOrderTimeSetTableViewCell.h"
#define MyOrderTimeSetTableViewCell_Identifier          @"MyOrderTimeSetTableViewCell"
@interface MyOrderTimeSetVC () <PopViewMyOrderTimeSetDelegate>
@property (nonatomic,strong) UIImageView *headerView;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@property (nonatomic,strong) PopViewMyOrderTimeSet *popViewMyOrderTimeSet;
//
@property (nonatomic,strong) NSMutableArray *repetitionArr;
@end

@implementation MyOrderTimeSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarWhiteStyle];
}
- (void)initView{
    self.title = @"点餐提醒";
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self.footerView.footerBtn newAnBtnWithBackColor:[UIColor whiteColor]];
    self.tableView.backgroundColor = Color_245Gray;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)initData{
    self.repetitionArr = [NSMutableArray arrayWithObjects:@"每天",@"周末",nil];
    self.dataSourceArr = [NSMutableArray arrayWithObjects:@"10:50",@"18:00", nil];
    [self.tableView reloadData];
}
#pragma mark ==
//add
- (void)popViewTouchSaveWithTimeHStr:(NSString *)hStr withMStr:(NSString *)mStr withDayStr:(NSString *)dStr{
    DLog(@"");
    [self.dataSourceArr addObject:[NSString stringWithFormat:@"%@:%@",hStr,mStr]];
    [self.repetitionArr addObject:dStr];
    [self.tableView reloadData];
}
//edit
- (void)popViewTouchSaveEditCellIndex:(NSInteger)index withTimeHStr:(NSString *)hStr withMStr:(NSString *)mStr withDayStr:(NSString *)dStr{
    [self.dataSourceArr replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%@:%@",hStr,mStr]];
    [self.repetitionArr replaceObjectAtIndex:index withObject:dStr];
    [self.tableView reloadData];
}
#pragma mark ==
- (void)footerAddAction{
    [self.popViewMyOrderTimeSet showInView:self.view thePopViewSubViewHeight:0 WithArray:@[].mutableCopy];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderTimeSetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderTimeSetTableViewCell_Identifier];
    if (!cell) {
        cell = [[MyOrderTimeSetTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderTimeSetTableViewCell_Identifier];
    }
    cell.timeL.text = [NSString stringWithFormat:@"%@",self.dataSourceArr[indexPath.row]];
    cell.detailTextL.text = [NSString stringWithFormat:@"%@",self.repetitionArr[indexPath.row]];
    cell.openSwith.on = YES;
    //
//    cell.openSwith addTarget:self action:<#(nonnull SEL)#> forControlEvents:<#(UIControlEvents)#>
    [cell.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.editBtn.tag = indexPath.row+300;
    return cell;
}
- (void)editBtnAction:(UIButton *)sender{
    NSInteger index = sender.tag-300;
    NSMutableArray *timeArr = [NSMutableArray arrayWithArray:[self.dataSourceArr[index] componentsSeparatedByString:@":"]];
    NSString *d = self.repetitionArr[index];
    [timeArr addObject:d];
    [self.popViewMyOrderTimeSet showInViewEditCellIndex:index andWithArray:timeArr];
}
 
//cell删除相关
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataSourceArr removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
#pragma mark ==
- (UIImageView *)headerView{
    if (!_headerView) {
        _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 150)];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.image = [UIImage imageNamed:@"Orderreminder_poster"];
    }
    return _headerView;
}
 
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
        [_footerView.footerBtn newAnBtnWithBackColor:[UIColor whiteColor]];
        [_footerView.footerBtn newAnBtnWithTextColor:[UIColor blackColor]];
        [_footerView.footerBtn newAnBtnWithTextStr:@"+ 添加提醒"];
        [_footerView.footerBtn addTarget:self action:@selector(footerAddAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}
- (PopViewMyOrderTimeSet *)popViewMyOrderTimeSet{
    _popViewMyOrderTimeSet = [[PopViewMyOrderTimeSet alloc]init];
    _popViewMyOrderTimeSet.delegate = self;
    return _popViewMyOrderTimeSet;
}
@end
