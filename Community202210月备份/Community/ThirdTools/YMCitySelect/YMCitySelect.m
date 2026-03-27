//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMCitySelect.m
//  YMCitySelect
//
//  Created by mac on 16/4/23.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import "YMCitySelect.h"
#import "YMCitySearch.h"
#import "ZYSearchBar.h"
#import "UIView+ym_extension.h"
#import "YMCityGroupsModel.h"
#import "YMCityModel.h"
#import "ZYCityModel.h"
#import "YMTableViewCell.h"
#import "ZYCityCell.h"
#import <CoreLocation/CoreLocation.h>
#import "LifeCostData.h"
#import "TQLocationConverter.h"

static NSString *reuseIdentifier = @"ym_cellTwo";
static NSString * const cityCellID = @"ZYCityCell";
// 城市名字转换后续可用的城市名字 (通过名称获取完整城市名称)
#define kCityNameChangeCityNameUrl @"proprietor/common/v2/getRegionName"

@interface YMCitySelect ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate,YMTableViewCellDelegate,UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSMutableArray *ym_cityNames;

@property (nonatomic,strong) YMCitySearch *ym_citySearch;

@property (nonatomic, strong) NSMutableArray<YMCityModel *> *citysArray;

@end

@implementation YMCitySelect{
    ZYSearchBar *_searchBar;
    UITableView *_ym_tableView;
    UIButton *_ym_cover;
    UILabel *_ym_selectCity;
    UIView *_ym_navView;
    NSMutableArray *_ym_ctiyGroups;
    NSUserDefaults *_ym_userDefaults;
    CLLocationManager *_ym_locationManager;
    UIButton *_ym_locationCityName;
    NSMutableArray *_ym_locationcityArry;
}

-(NSMutableArray *)ym_cityNames{
    if (!_ym_cityNames) {
        _ym_cityNames = [NSMutableArray array];
    }
    return _ym_cityNames;
}

-(YMCitySearch *)ym_citySearch{
    if (!_ym_citySearch) {
        _ym_citySearch = [[YMCitySearch alloc] init];
        [self addChildViewController:_ym_citySearch];
        [self.view addSubview:_ym_citySearch.view];
        _ym_citySearch.view.frame = CGRectMake(0, 44 + status_height + 20, self.view.ym_width, self.view.ym_height - 44 - status_height - 20);
    }
    
    return _ym_citySearch;
}

-(instancetype)initWithDelegate:(id)targe{
    self = [super init];
    if (self) {
        self.ymDelegate = targe;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_D001534;
    [self ym_setSearchBar];
    [self ym_setNavView];
    [self ym_setCityGroups];
    [self ym_setTableView];
    [self ym_setLocationManager];
    [self ym_setcationCityName];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ym_setLocationManager) name:@"ym_updateLocation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ym_setSearchCityResult:) name:@"ym_searchCityResult" object:nil];
    
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加载中..."];
    if (self.type == City_Select_Type_Weather) {
        [self initHotCityData];
    }else if (self.type == City_Select_Type_LifeCost) {
        [self initLifeCostCityData];
    }
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        if (@available(iOS 14.0, *)) {
            self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        }
        [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    }else {
        if (@available(iOS 14.0, *)) {
            self.navigationController.navigationBar.overrideUserInterfaceStyle = UIUserInterfaceStyleDark;
        }
        [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    }
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        
        return UIStatusBarStyleDarkContent;
    }else {
        
        return UIStatusBarStyleLightContent;
    }
}

- (NSMutableArray<YMCityModel *> *)citysArray {
    if (!_citysArray) {
        _citysArray = [NSMutableArray array];
    }
    
    return _citysArray;
}

// 加载生活缴费城市数据
- (void)initLifeCostCityData {
    NSDictionary *params = @{@"deviceType" : @"2"};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:[NSString stringWithFormat:@"%@%@", BASE_URL_OnlyAsOfPort, kLifeCostCityUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ZYCityModel *cityModel = [ZYCityModel yy_modelWithJSON:responsObject[@"data"]];
                    ZYCityListModel *hotListModel = [cityModel.cityHotCategoryModelList firstObject];
                    NSMutableArray *hotCityNameArray = [NSMutableArray array];
                    for (ZYCityListDataModel *tempModel in hotListModel.cityModelList) {
                        [hotCityNameArray addObject:tempModel.cityName];
                    }
                    YMCityGroupsModel *cityGroupsModel = [[YMCityGroupsModel alloc] init];
                    cityGroupsModel.title = @"热门";
                    cityGroupsModel.cities = [hotCityNameArray copy];
                    [self->_ym_ctiyGroups addObject:cityGroupsModel];
                    
                    NSMutableArray<ZYCityListDataModel *> *dataArray = [NSMutableArray array];
                    for (ZYCityListModel *listTempModel in cityModel.cityCategoryModelList) {
                        for (ZYCityListDataModel *tempModel in listTempModel.cityModelList) {
                            [dataArray addObject:tempModel];
                        }
                    }
                    NSMutableArray<ZYCityListModel *> *sectionArray = [NSMutableArray array];
                    for (char ch='A'; ch <= 'Z'; ch++) {
                        ZYCityListModel *model = [ZYCityListModel alloc];
                        model.section = [NSString stringWithFormat:@"%c", ch];
                        NSMutableArray<ZYCityListDataModel *> *tempArray = [NSMutableArray array];
                        for (ZYCityListDataModel *tempModel in dataArray) {
                            if ([model.section isEqual:[tempModel.cityFlag uppercaseString]]) {
                                [tempArray addObject:tempModel];
                            }
                        }
                        model.cityModelList = [tempArray copy];
                        [sectionArray addObject:model];
                    }
                    for (ZYCityListModel *tempModel in sectionArray) {
                        if (tempModel.cityModelList.count > 0) {
                            YMCityGroupsModel *cityGroupsModel = [[YMCityGroupsModel alloc] init];
                            cityGroupsModel.title = tempModel.section;
                            NSMutableArray *mCityNameArr = [NSMutableArray array];
                            for (ZYCityListDataModel *dataModel in tempModel.cityModelList) {
                                [mCityNameArr addObject:dataModel.cityName];
                                YMCityModel *cityModel = [[YMCityModel alloc] init];
                                cityModel.name = dataModel.cityName;
                                cityModel.pinYin = @"";
                                cityModel.pinYinHead = dataModel.cityFlag;
                                [self.citysArray addObject:cityModel];
                            }
                            cityGroupsModel.cities = [mCityNameArr copy];
                            [self->_ym_ctiyGroups addObject:cityGroupsModel];
                        }
                    }
                    [self->_ym_tableView reloadData];
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载热门城市数据
- (void)initHotCityData {
    NSDictionary *params = @{@"queryType" : @"3"};
    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_Get_Weather_City_List withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSArray *array = [NSArray yy_modelArrayWithClass:[YMCityModel class] json:responsObject[@"data"]];
                NSMutableArray *cityNameArray = [NSMutableArray array];
                for (YMCityModel *cityModel in array) {
                    [cityNameArray addObject:cityModel.name];
                }
                YMCityGroupsModel *cityGroupsModel = [[YMCityGroupsModel alloc] init];
                cityGroupsModel.title = @"热门";
                cityGroupsModel.cities = [cityNameArray copy];
                [self->_ym_ctiyGroups addObject:cityGroupsModel];
                [self initCityListData];
            }else {
                Y_SVP_DISMISS
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_DISMISS
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

// 加载城市列表数据
- (void)initCityListData {
    NSDictionary *params = @{@"queryType" : @"2"};
    [[ToolOfNetWork sharedTools] YrequestGetURL:URL_Get_Weather_City_List withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                for (char ch='A'; ch <= 'Z'; ch++) {
                    NSString *chStr = [NSString stringWithFormat:@"%c", ch];
                    NSArray *cityArr = responsObject[@"data"][chStr];
                    if (cityArr.count > 0) {
                        YMCityGroupsModel *cityGroupsModel = [[YMCityGroupsModel alloc] init];
                        cityGroupsModel.title = chStr;
                        NSMutableArray *mCityNameArr = [NSMutableArray array];
                        for (NSDictionary *tempDict in cityArr) {
                            [mCityNameArr addObject:tempDict[@"name"]];
                            YMCityModel *cityModel = [[YMCityModel alloc] init];
                            cityModel.name = tempDict[@"name"];
                            cityModel.pinYin = tempDict[@"pinyin"];
                            cityModel.pinYinHead = tempDict[@"pinyin"];
                            [self.citysArray addObject:cityModel];
                        }
                        cityGroupsModel.cities = [mCityNameArr copy];
                        [self->_ym_ctiyGroups addObject:cityGroupsModel];
                    }
                }
                [self->_ym_tableView reloadData];
            }else {
                
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
      
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

-(void)ym_setSearchBar{
    _searchBar = [[ZYSearchBar alloc] initWithFrame:CGRectMake(0, 44 + status_height, self.view.ym_width, 64)];
    _searchBar.searchTF.delegate = self;
    [self.view addSubview:_searchBar];
}

-(void)ym_setNavView{
    _ym_navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44 + status_height)];
    _ym_navView.backgroundColor = [ZYThemeManager shareManager].navigationBarBackgroundThemeColor_D001534;
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[[ZYThemeManager shareManager] themeImageNamed:@"ic_navi_return"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn sizeToFit];
    closeBtn.ym_x = 10;
    closeBtn.ym_centerY = _ym_navView.ym_centerY + 10 + (status_height - 20) / 2;
    [_ym_navView addSubview:closeBtn];
    _ym_selectCity = [[UILabel alloc] init];
    _ym_selectCity.text = @"切换城市";
    _ym_selectCity.font = [UIFont systemFontOfSize:18];
    _ym_selectCity.textColor = [ZYThemeManager shareManager].navigationItemThemeColor;
    [_ym_selectCity sizeToFit];
    _ym_selectCity.ym_centerX = _ym_navView.ym_centerX;
    _ym_selectCity.ym_centerY = _ym_navView.ym_centerY + 10 + (status_height - 20) / 2;
    [_ym_navView addSubview:_ym_selectCity];
    [self.view addSubview:_ym_navView];
}

-(void)closeBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ym_setCityGroups{

    _ym_ctiyGroups = [NSMutableArray array];
}

-(void)ym_setTableView{
    _ym_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame), self.view.ym_width, self.view.ym_height - CGRectGetMaxY(_searchBar.frame)) style:UITableViewStyleGrouped];
    _ym_tableView.delegate = self;
    _ym_tableView.dataSource = self;
    _ym_tableView.tintColor = [UIColor blackColor];
    _ym_tableView.backgroundColor = [UIColor clearColor];
    _ym_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_ym_tableView registerClass:[YMTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    _ym_tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_ym_tableView];
    if([_ym_tableView respondsToSelector:@selector(setSectionIndexColor:)]) {
        _ym_tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _ym_tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    }
    // 注册单元格
    [_ym_tableView registerClass:[ZYCityCell class] forCellReuseIdentifier:cityCellID];
}

-(void)ym_setLocationManager{
    _ym_locationManager = [CLLocationManager new];
    if ([_ym_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_ym_locationManager requestWhenInUseAuthorization];
    }
    _ym_locationManager.delegate = self;
    [_ym_locationManager startUpdatingLocation];
}

-(void)ym_setcationCityName{
    YMCityGroupsModel *ymcityGroupsModel = [[YMCityGroupsModel alloc] init];
    ymcityGroupsModel.title = @"定位";
    _ym_locationcityArry = [NSMutableArray array];
    [_ym_locationcityArry addObject:@"正在定位中..."];
    ymcityGroupsModel.cities = _ym_locationcityArry;
    [_ym_ctiyGroups insertObject:ymcityGroupsModel atIndex:0];
}

-(void)ym_setCover{
    if (!_ym_cover) {
        _ym_cover = [[UIButton alloc] init];
        _ym_cover.backgroundColor = [UIColor blackColor];
        [_ym_cover addTarget:self action:@selector(ym_coverClick) forControlEvents:UIControlEventTouchUpInside];
        _ym_cover.frame = _ym_tableView.frame;
        [self.view addSubview:_ym_cover];
    }
    _ym_cover.hidden = NO;
    _ym_cover.alpha = 0.5;
}

-(void)ym_coverClick{
    [self ym_cancelBtnClick];
}

-(void)ym_cancelBtnClick{
    _ym_navView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self->_ym_cover.hidden = YES;
        self->_ym_navView.ym_y = 0;
        self->_searchBar.ym_y = 44 + status_height;
        self->_ym_tableView.ym_y = CGRectGetMaxY(self->_searchBar.frame);
        self->_ym_tableView.ym_height = self.view.ym_height - self->_ym_tableView.ym_y;
        self->_ym_cover.frame = self->_ym_tableView.frame;
    }completion:^(BOOL finished) {
        self->_ym_cover.hidden = YES;
    }];
    [_searchBar.searchTF resignFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_ym_cover) {
        _ym_cover.alpha = 0;
    }
    [self ym_setCover];
    _ym_navView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self->_ym_navView.ym_y = -44;
        self->_searchBar.ym_y = 0 + status_height;
        self->_ym_tableView.ym_y = 64 + status_height;
        self->_ym_tableView.ym_height = self.view.ym_height - 64 - status_height;
        self->_ym_cover.frame = self->_ym_tableView.frame;
    } completion:nil];
    
    return YES;
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    if (textField.text.length) {
        self.ym_citySearch.view.hidden = NO;
        self.ym_citySearch.citysArr = [self.citysArray copy];
        self.ym_citySearch.ym_searchText = textField.text;
    } else {
        self.ym_citySearch.view.hidden = YES;
    }
}

#pragma mark - UITableView的数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _ym_ctiyGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    YMCityGroupsModel *cityGroupModel = _ym_ctiyGroups[section];
    if (cityGroupModel.title.length > 1) {
        return 1;
    }
    return cityGroupModel.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMCityGroupsModel *cityGroupModel = _ym_ctiyGroups[indexPath.section];
    if (cityGroupModel.title.length > 1) {
        YMTableViewCell *ym_cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        ym_cell.citys = cityGroupModel.cities;
        ym_cell.ym_cellHeight = [self ym_setcellHeightForRowAtIndexPath:indexPath];
        ym_cell.ym_cellDelegate = self;
        return ym_cell;
    }else{
        ZYCityCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellID forIndexPath:indexPath];
        cell.titleLabel.text = cityGroupModel.cities[indexPath.row];
        
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    YMCityGroupsModel *model = _ym_ctiyGroups[section];
    return model.title;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    NSMutableArray *titleArray = [NSMutableArray array];
    for (YMCityGroupsModel *model in _ym_ctiyGroups) {
        if ([model.title isEqual:@"定位"] || [model.title isEqual:@"热门"]) {
            [titleArray addObject:@""];
        }else {
            [titleArray addObject:model.title];
        }
    }
    // 设置右侧索引字体颜色
    tableView.sectionIndexColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    
    return [titleArray copy];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *ym_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    ym_view.backgroundColor = [UIColor clearColor];
    UILabel *ym_label = [[UILabel alloc] initWithFrame:CGRectMake(16, 12, kScreenW - 32, 18)];
    ym_label.textAlignment = NSTextAlignmentLeft;
    ym_label.textColor = [ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4;
    ym_label.font = [UIFont systemFontOfSize:15];
    YMCityGroupsModel *cityGroupModel = _ym_ctiyGroups[section];
    NSString *ym_title = cityGroupModel.title;
    if ([cityGroupModel.title isEqualToString:@"热门"]) {
        ym_title = @"热门城市";
    }
    if ([cityGroupModel.title isEqualToString:@"定位"]) {
        ym_title = @"你所在地区";
    }
    ym_label.text = ym_title;
    [ym_view addSubview:ym_label];
    return ym_view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == (_ym_ctiyGroups.count - 1)) {
        
        return 30;
    }
    
    return 0;
}

#pragma mark - 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YMCityGroupsModel *model = _ym_ctiyGroups[indexPath.section];
    NSString *cityName =  model.cities[indexPath.row];
    [self ym_setSelectCityName:cityName];
}

#pragma mark YMTableViewCell自定义的代理方法
-(void)ymcollectionView:(UICollectionView *)collectionView didSelectItemAtCityName:(NSString *)cityName {
    [self ym_setSelectCityName:cityName];
}

#pragma mark 搜索城市的结果返回
-(void)ym_setSearchCityResult:(NSNotification *)noti {
    NSString *cityName = noti.userInfo[@"ym_searchCityResultKey"];
    [self ym_setSelectCityName:cityName];
}

#pragma mark 选中的城市
-(void)ym_setSelectCityName:(NSString *)cityName{
    if ([self.ymDelegate respondsToSelector:@selector(ym_ymCitySelectCityName:)]) {
        [self.ymDelegate ym_ymCitySelectCityName:cityName];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableView的代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self ym_setcellHeightForRowAtIndexPath:indexPath];
}

-(CGFloat)ym_setcellHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat ym_height = 50;
    YMCityGroupsModel *cityGroupModel = _ym_ctiyGroups[indexPath.section];
    CGFloat ym_w = ([UIScreen mainScreen].bounds.size.width - 55) / 3.0;
    CGFloat ym_h = ym_w / 3.0;
    if (cityGroupModel.title.length > 1) {
        NSInteger count = cityGroupModel.cities.count;
        ym_height = (count / 3 + (count % 3 == 0 ? 0 : 1)) * (ym_h + 10) + 10;
    }
    return ym_height;
}

#pragma mark 获取最近城市
-(void)setUpCityNames {
    if (!_ym_userDefaults) {
        _ym_userDefaults = [NSUserDefaults standardUserDefaults];
    }
    self.ym_cityNames = [[_ym_userDefaults objectForKey:@"ym_cityNames"] mutableCopy];
}

#pragma mark 城市定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [_ym_locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [CLGeocoder new];
    CLLocationCoordinate2D coordinate2D = locations.lastObject.coordinate;
    if (![TQLocationConverter isLocationOutOfChina:coordinate2D]) {
        coordinate2D = [TQLocationConverter transformFromWGSToGCJ:coordinate2D];
    }
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate2D.latitude longitude:coordinate2D.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count == 0 || error) {
            self->_ym_locationcityArry[0] = @"定位失败，请点击重试";
        }else {
            CLPlacemark *placemark = placemarks.lastObject;
            if (placemark.locality) {
                NSString *cityName = placemark.locality;
                if (self.type != City_Select_Type_LifeCost) {
                    self->_ym_locationcityArry[0] = cityName;
                }else {
                    [self useCityNameStr:cityName];
                }
            }
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ym_locationReloadData" object:nil];
    }];
}

#pragma mark == 城市名字转换 用定位的城市数据 拿到后台能用的城市数据
- (void)useCityNameStr:(NSString *)cityNameStr {
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:cityNameStr forKey:@"regionName"];
    [[ToolOfNetWork sharedTools] YrequestGetURLNotMainQueue:kCityNameChangeCityNameUrl withParams:parms finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    NSString *saveNowCityName  = Y_ResponsObject_dataStr;
                    self->_ym_locationcityArry[0] = saveNowCityName;
                }else{
                    self->_ym_locationcityArry[0] = cityNameStr;
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else{
                self->_ym_locationcityArry[0] = cityNameStr;
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ym_locationReloadData" object:nil];
        });
    }];
}

@end
