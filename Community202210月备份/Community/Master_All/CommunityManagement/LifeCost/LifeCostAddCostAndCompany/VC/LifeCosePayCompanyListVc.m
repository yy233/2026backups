//
//  LifeCosePayCompanyListVc.m
//  Community
//
//  Created by 余莹 on 2021/1/12.
//

#import "LifeCosePayCompanyListVc.h"
#import "LifeCostAddNewCostViewModel.h"
@interface LifeCosePayCompanyListVc () <UISearchBarDelegate>
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UIButton *changeCityBtn;
//@property (nonatomic,assign) NSInteger pageNum;
//微信支付 1.充值提现2.商城购物3.水电缴费4.物业管理5.房屋租金6.红包
// 支付宝   1.充值提现2.商城购物3.水电缴费4.物业管理5.房屋租金6.红包7.红包退回
@end

@implementation LifeCosePayCompanyListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择缴费单位";
//    self.pageNum = 1;
    [self initHeaderViewSubviews];
}
#pragma mark ===
- (void)changeCityBtnAction{
    NSLog(@"changeCityBtnAction");
    [_changeCityBtn setTitle:@"重庆庆庆庆庆" forState:UIControlStateNormal];//切换城市
//    self.cityId = //换城市
    [self initData];
}


#pragma mark ===

- (void)initData{
    [LifeCostAddNewCostViewModel getAddNewCostCompanyArrWithTypeId:self.typeId withCityId:self.cityId withSearchStr:self.searchBar.text with:^(NSArray * arr, BOOL success) {
        if (success) {
            self.dataSourceArr = [NSMutableArray arrayWithArray:[LifeCostAddNewCompanyModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark ==
#pragma mark --- search 
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self initData];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self initData];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self initData];
}
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *userInfo = @{Notice_UserInfo_Key:self.dataSourceArr[indexPath.row]};
    Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(LifeCostPayChooseCompany_Notice_Name, userInfo);
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArr.count;
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.textColor = [ThemeManager shareManager].mainTextColor;
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    LifeCostAddNewCompanyModel *model = self.dataSourceArr[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

#pragma mark==
- (void)initHeaderViewSubviews{
   self.tableView.tableHeaderView = self.headerView;
    [self.headerView addSubview:self.searchBar];
    [self.headerView addSubview:self.changeCityBtn];
   
    [_changeCityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_searchBar.superview.mas_centerY);
        make.right.equalTo(_searchBar.superview.mas_right).offset(-16);
        make.height.equalTo(_searchBar.superview.mas_height);
    }];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_searchBar.superview.mas_centerY);
        make.left.equalTo(_searchBar.superview.mas_left).offset(16);
        make.right.equalTo(_changeCityBtn.mas_left).offset(5);
        make.height.equalTo(_searchBar.superview.mas_height);
    }];
    [self setSearchFieldColorAndCornerRadius];
}

- (void)setSearchFieldColorAndCornerRadius {
        UITextField *searchField;
        UIView  *textFieldBackView;
        UIImageView *searchBarBackgroundImg;
         
        if (@available(iOS 13.0, *)) {
            _searchBar.tintColor = [ThemeManager shareManager].mainSearchBarTextColor;;//光标
             _searchBar.searchTextField.textColor = [ThemeManager shareManager].mainSearchBarTextColor;
            _searchBar.searchTextField.font = [UIFont systemFontOfSize:14];
             _searchBar.searchTextField.layer.masksToBounds = YES;
            _searchBar.searchTextField.clipsToBounds = YES;
            _searchBar.backgroundImage = [UIImage new];
            
        } else {
            _searchBar.tintColor = [ThemeManager shareManager].mainSearchBarTextColor;;//光标
            searchField = [_searchBar valueForKey:@"searchField"];
            textFieldBackView = [_searchBar subViewOfClassName:@"_UISearchBarSearchFieldBackgroundView"];
            searchBarBackgroundImg = (UIImageView *)[_searchBar.subviews.firstObject subViewOfClassName:@"UISearchBarBackground"];
            if (searchField) {
                searchField.backgroundColor = [ThemeManager shareManager].mainSearchBarTextFieldBackGroundColor;//框内色
                [searchField setTextColor:[ThemeManager shareManager].mainSearchBarTextColor];
                searchField.font = [UIFont systemFontOfSize:14];
            }
            if (textFieldBackView) {
                 textFieldBackView.layer.masksToBounds = YES;
                textFieldBackView.clipsToBounds = YES;
            }
            if (searchBarBackgroundImg) {
                searchBarBackgroundImg.image = [UIImage new];
            }
        }
     
}
#pragma mark ==
- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 50)];
    }
    return _headerView;
}
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.placeholder = @"搜索缴费单位";
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.tintColor = [ThemeManager shareManager].mainTextColor;
        _searchBar.delegate = self;
    }
    return _searchBar;
}
- (UIButton *)changeCityBtn{
    if (!_changeCityBtn) {
        _changeCityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeCityBtn setTitle:@"重庆" forState:UIControlStateNormal];
        _changeCityBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_changeCityBtn addTarget:self action:@selector(changeCityBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeCityBtn;
}
@end
