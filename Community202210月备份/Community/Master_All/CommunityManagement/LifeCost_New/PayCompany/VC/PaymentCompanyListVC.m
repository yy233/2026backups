//
//  PaymentCompanyListVC.m
//  Community
//
//  Created by 余莹 on 2022/1/7.
// 缴费单位 公司列表

#import "PaymentCompanyListVC.h"
#import "LifeCostData.h"

#import "PaymentCompanyListHeaderSearchAndCityChooseView.h"
#import "PaymentCompanyUseShowModel.h"

// 切换城市
#import "YMCitySelect.h"

// 绑定户号web
#import "ZYLifeCostBindHouseholdWebVC.h"

@interface PaymentCompanyListVC () <UISearchBarDelegate,YMCitySelectDelegate>

@property (nonatomic,strong) PaymentCompanyListHeaderSearchAndCityChooseView *headerV;

@property (nonatomic,strong) NSString *saveSearchTextStr;

@property (nonatomic,strong) NSMutableArray *searchDataArr;
@end

@implementation PaymentCompanyListVC
- (NSMutableArray *)searchDataArr{
    if (!_searchDataArr) {
        _searchDataArr = [[NSMutableArray alloc]init];
    }
    return _searchDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择缴费单位"; 
    self.tableView.tableHeaderView = self.headerV;
    [self addRefresh];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDDAndWW];
    self.navigationController.navigationBarHidden = NO;
    self.tableView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
}
- (void)initData{
    [self.headerV fillHeaderCellCityNameWithStr:self.saveNowCityTextStr];
    if (isNil(self.payTypeIdStr)) {
        self.payTypeIdStr = @"";
    }
    if (isNil(self.saveSearchTextStr)) {
        self.saveSearchTextStr = @"";
    }
    if (self.saveNowCityTextStr.length==0) {
        self.saveNowCityTextStr = [LifeCostSaveCityInfoModel share].cityName;
    }
    
    //0416筛选文本 后台给不了接口 做本地筛选
    
    if (self.saveSearchTextStr.length<=0) {
        WEAKSELF
        [LifeCostData lifeCostGetPayCompanyListWithTypeIdStr:self.payTypeIdStr andCityNameStr:self.saveNowCityTextStr andSearchTextStr:self.saveSearchTextStr  withCompanyListBlock:^(NSArray * _Nonnull arr, BOOL success) {
            [self.tableView.mj_header endRefreshing];
            if (success) {
                weakSelf.dataSourceArr = [PaymentCompanyUseShowModel mj_objectArrayWithKeyValuesArray:arr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
            
        }];
    }else{//本地筛
        /**
         PaymentCompanyUseShowModel *model = self.dataSourceArr[indexPath.row];
         cell.textLabel.text = [TextShowWithModelStr textShowWithModelStr:model.companyName];
        */
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"companyName CONTAINS [cd] %@", self.saveSearchTextStr];
        NSArray* tempArr = [self.dataSourceArr filteredArrayUsingPredicate:predicate];
        self.searchDataArr = [NSMutableArray arrayWithArray:tempArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        NSLog(@"本地筛 predicate = %@  tempArr = %@",predicate,tempArr);

    }
  

}
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PaymentCompanyUseShowModel *model = [[PaymentCompanyUseShowModel alloc]init];
    if (self.saveSearchTextStr.length<=0) {
        model = self.dataSourceArr[indexPath.row];
    }else{
        model = self.searchDataArr[indexPath.row];
    }
  
    DLog(@"%@,%@",model.companyName,model.companyId);
    DLog(@"公司all %@",[model mj_keyValues]);
    
    BOOL isHaveHouseholdWebVC = NO;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ZYLifeCostBindHouseholdWebVC class]]) {
            isHaveHouseholdWebVC = YES;
            ZYLifeCostBindHouseholdWebVC *webVC = (ZYLifeCostBindHouseholdWebVC *)vc;
            webVC.cityName = self.saveNowCityTextStr;
        }
    }
    if (isHaveHouseholdWebVC) {
        Y_NSNotificationCenter_PostNotice_HaveObject_Name(@"LIFE_COST_SELSECT_COMPANY_BACK", model)
        [self popVC];
    }else {
        ZYLifeCostBindHouseholdWebVC *vc = [[ZYLifeCostBindHouseholdWebVC alloc] init];
        vc.cityName = self.saveNowCityTextStr;
        vc.typeModel = self.typeModel;
        vc.companyModel = model;
        [self pushVc:vc];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.saveSearchTextStr.length<=0) {
        return self.dataSourceArr.count;
    }else{
        return self.searchDataArr.count;
    }
  
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"companyCell"  ];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"companyCell"];
        cell.contentView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
    }
    
    if (self.saveSearchTextStr.length<=0) {
        PaymentCompanyUseShowModel *model = self.dataSourceArr[indexPath.row];
        cell.textLabel.text = [TextShowWithModelStr textShowWithModelStr:model.companyName];
    }else{
        PaymentCompanyUseShowModel *model = self.searchDataArr[indexPath.row];
        cell.textLabel.text = [TextShowWithModelStr textShowWithModelStr:model.companyName];
    }
  

    return cell;
}
 

 
#pragma mark ==
 
- (PaymentCompanyListHeaderSearchAndCityChooseView *)headerV{
    if (!_headerV) {
        _headerV = [[PaymentCompanyListHeaderSearchAndCityChooseView alloc]initWithFrame:CGRectZero];
        _headerV.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_WhiteIsWwAndDrayIsDD;
        [_headerV.cityChangeBtn addTarget:self action:@selector(cityChangeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _headerV.searchBar.delegate = self;
    }
    return _headerV;
}

- (void)cityChangeBtnAction{
    DLog(@"");
    YMCitySelect *citySelect = [[YMCitySelect alloc] initWithDelegate:self];
    citySelect.type = City_Select_Type_LifeCost;
    [self pushVc:citySelect];
}
#pragma mark - YMCitySelectDelegate
- (void)ym_ymCitySelectCityName:(NSString *)cityName {
    NSLog(@"ym_ymCitySelectCityName %@", cityName);
    [self.headerV fillHeaderCellCityNameWithStr:cityName];//UI
    //data
    self.saveNowCityTextStr = cityName;
    [self initData];
}

#pragma mark --- search
//QueryType_CitySearchText
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.saveSearchTextStr = searchText;
    [self initData];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.saveSearchTextStr = searchBar.text;
    [self initData];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.saveSearchTextStr =  searchBar.text;
    [self initData];
}
@end
