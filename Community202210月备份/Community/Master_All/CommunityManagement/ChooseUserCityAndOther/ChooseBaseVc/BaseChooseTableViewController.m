//
//  BaseChooseTableViewController.m
//  Community
//
//  Created by 余莹 on 2020/11/20.
//

#import "BaseChooseTableViewController.h"

#define CerTableViewCell_Height_cell_HeaderView 30
@interface BaseChooseTableViewController () <UISearchBarDelegate>

@end

@implementation BaseChooseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self initNav];
    [self setupNavigationBarWithBackNoTitle];
    //    [self initHeaderView];
    [self resetSearchPlaceholder];
    [self headerSearchViewHiden:NO];
    [self initData];
}

//重写
- (void)setupNavigationBarStyleWithMainColor{
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
        NSFontAttributeName:[UIFont systemFontOfSize:18.0f],
        NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor
    }];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[ThemeManager shareManager].chooseUserCityAndOtherVcBackgroundColor] forBarMetrics:UIBarMetricsDefault];//
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[ThemeManager shareManager].mainTextColor];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self chanVcBackColor];
}
- (void)chanVcBackColor{
    self.view.backgroundColor = [ThemeManager shareManager].chooseUserCityAndOtherVcBackgroundColor;
}
- (void)initNav{
    self.title = @"选择";
}
- (void)setupNavigationBarWithBackNoTitle{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"";
    [self.navigationItem setBackBarButtonItem:backBtn];
    self.navigationController.navigationBarHidden = NO;
    //    self.navigationController.navigationBar.backgroundColor = [UIColor redColor];
}

- (void)initHeaderView{
    self.tableView.tableHeaderView = self.headerView;
}
- (void)headerSearchViewHiden:(BOOL)isHiden{
    if (isHiden) {
        self.tableView.tableHeaderView = [UIView new];
    }else{
        self.tableView.tableHeaderView = self.headerView;
    }
    
}
- (void)resetSearchPlaceholder{
    self.headerView.searchBar.placeholder = @"请输入...";
}
- (void)initData{
    
}

//
- (void)popUserCertificationVcWithName:(NSString *)nameStr And:(NSInteger)Id{
    //pop
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[UserCertificationViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
    
    NSString *idstr  =  [NSString stringWithFormat:@"%ld",(long)Id];
    NSArray *arr = @[nameStr,idstr];
    Y_NSNotificationCenter_PostNotice_HaveObject_Name(@"noticeActionWithDetailedAddressInfo", arr)
    //    Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(@"noticeActionWithDetailedAddressInfo", (@{@"name":nameStr,@"id":@(Id)}))
}
#pragma mark ---search

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidBeginEditing");
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"textDidChange");
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    NSLog(@"searchBarTextDidEndEditing");
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataSourceArr.count;;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"您可以直接选择";
}
//- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
//    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
//    headerView.textLabel.font = [UIFont systemFontOfSize:16];
//    headerView.textLabel.textColor = [UIColor grayColor];
//    headerView.textLabel.textAlignment = NSTextAlignmentLeft;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CerTableViewCell_Height_cell_HeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SectionHeaderViewWithTextLabel *headerView = [[SectionHeaderViewWithTextLabel alloc]initWithFrame:CGRectZero];
    headerView.titleLabel.text = @"您可以直接选择";
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    return cell;
}

#pragma mark == headerView
- (ChooseBaseHeaderViewOfSearchBar *)headerView{
    if (!_headerView) {
        _headerView = [[ChooseBaseHeaderViewOfSearchBar alloc]initWithFrame:CGRectMake(0 , 0, Screen_W, 40)];
        _headerView.searchBar.delegate = self;
        _headerView.searchBar.placeholder = @"输入城市名、拼音或者首字母查询";
    }
    return _headerView;
}
- (ChooseBaseHeaderViewOfRightAndSearchBar *)communityHeaderView{
    if (!_communityHeaderView) {
        _communityHeaderView = [[ChooseBaseHeaderViewOfRightAndSearchBar alloc]initWithFrame:CGRectMake(0 , 0, Screen_W, 40)];
        _communityHeaderView.searchBar.delegate = self;
        _communityHeaderView.searchBar.placeholder = @"输入小区名称进行搜索";
    }
    return _communityHeaderView;
}
#pragma mark ==serarch 弃用
//-(UISearchBar *)searchBar{
//    if (!_searchBar) {
//        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 60)];
//        _searchBar.placeholder = @"请输入";
//        _searchBar.barTintColor = [UIColor whiteColor];
//        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
//        _searchBar.delegate = self;
//    }
//    return _searchBar;
//}

#pragma mark == 父类有
//- (NSMutableArray *)dataSourceArr{
//    if (!_dataSourceArr) {
//        _dataSourceArr = [NSMutableArray array];
//    }
//    return _dataSourceArr;
//}

@end
