//
//  IssueChooseShopQuYuVc.m
//  Community
//
//  Created by 余莹 on 2021/2/26.
//  商铺 区域

#import "IssueChooseShopQuYuVc.h"
#import "IssBuniessShopQuYuAndAddressViewModel.h"
@interface IssueChooseShopQuYuVc ()
@property (nonatomic,strong) NSMutableArray *searchArr;
@end

@implementation IssueChooseShopQuYuVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择区域";
    self.communityHeaderView.searchBar.placeholder = @"请输入区域进行搜索";
    self.searchTextStr = @"";
}
- (void)initData{//区域list
    [IssBuniessShopQuYuAndAddressViewModel getIssueBuniessShopQuYuWithCityId:self.getQuYuWithUseCityId  getQuYuArr:^(NSArray * arr, BOOL success) {
        if (success) {
            self.shopBuniessQuYuArr = [NSMutableArray arrayWithArray:[IssueShopBuniessQuYuModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}
 
 
- (void)searchInitData{
//
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"name CONTAINS [cd] %@", self.searchTextStr];
    NSArray* tempArr = [self.shopBuniessQuYuArr filteredArrayUsingPredicate:predicate];
    self.searchArr = [NSMutableArray arrayWithArray:tempArr];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    NSLog(@"本地筛 predicate = %@  tempArr = %@",predicate,tempArr);
    
//    searchArr
//    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
//    [IssBuniessShopQuYuViewModel getIssueBuniessShopQuYuWithCityId:self.cityModel.id getQuYuArr:^(NSArray * arr, BOOL success) {
//        if (success) {
//            self.shopBuniessQuYuArr = [NSMutableArray arrayWithArray:[IssueShopBuniessQuYuModel mj_objectArrayWithKeyValuesArray:arr]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        }
//    }];
}
#pragma mark - search bar
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.searchTextStr = searchText;
    if (searchText.length>0) {
        [self searchInitData];
    }else{
        [self initData];
    }
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.searchTextStr = searchBar.text;
    if (self.searchTextStr.length > 0) {
        [self searchInitData];
    }else{
        [self initData];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.searchTextStr = searchBar.text;
    if (self.searchTextStr.length > 0) {
        [self searchInitData];
    }else{
        [self initData];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchTextStr.length <= 0) {
        return self.shopBuniessQuYuArr.count;
    }else{
        return self.searchArr.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];//[UIFont systemFontOfSize:12];
    if (self.searchTextStr.length <= 0) {
        IssueShopBuniessQuYuModel *model = self.shopBuniessQuYuArr[indexPath.row];
        cell.textLabel.text = model.name;
     }else{
        IssueShopBuniessQuYuModel *model = self.searchArr[indexPath.row];
        cell.textLabel.text = model.name;
     
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IssueShopBuniessQuYuModel *model = [[IssueShopBuniessQuYuModel alloc]init];
    if (self.searchTextStr.length <= 0) {
        model = self.shopBuniessQuYuArr[indexPath.row];
    }else{
        model = self.searchArr[indexPath.row];
    }
    BaseListArrBlock block = self.listBlock;
    block(@[model]);
    [self popVC];
}
#pragma mark -
//
- (NSMutableArray *)shopBuniessQuYuArr{
    if (!_shopBuniessQuYuArr) {
        _shopBuniessQuYuArr = [[NSMutableArray alloc]init];
    }
    return _shopBuniessQuYuArr;
}
- (NSMutableArray *)searchArr{
    if (!_searchArr) {
        _searchArr = [[NSMutableArray alloc]init];
    }
    return _searchArr;
}
@end
