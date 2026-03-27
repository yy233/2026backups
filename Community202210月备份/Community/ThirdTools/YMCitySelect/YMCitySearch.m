//代码地址：https://github.com/iosdeveloperSVIP/YMCitySelect
//原创：iosdeveloper赵依民
//邮箱：iosdeveloper@vip.163.com
//
//  YMCitySearch.m
//  YMCitySelect
//
//  Created by mac on 16/4/23.
//  Copyright © 2016年 YiMin. All rights reserved.
//

#import "YMCitySearch.h"
#import "YMCityModel.h"
#import "ZYCityCell.h"

static NSString * const cityCellID = @"ZYCityCell";

@interface YMCitySearch ()

@end

@implementation YMCitySearch{
    NSMutableArray *_ym_cityArray;
    NSMutableArray *_ym_resultArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_D001534;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 注册单元格
    [self.tableView registerClass:[ZYCityCell class] forCellReuseIdentifier:cityCellID];
    _ym_resultArray = [NSMutableArray array];
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_White) {
        
        return UIStatusBarStyleDarkContent;
    }else {
        
        return UIStatusBarStyleLightContent;
    }
}

- (void)setCitysArr:(NSArray<YMCityModel *> *)citysArr {
    _citysArr = citysArr;

    _ym_cityArray = [_citysArr mutableCopy];
}

-(void)setYm_searchText:(NSString *)ym_searchText{
    _ym_searchText = ym_searchText;
    ym_searchText = [ym_searchText copy];
    ym_searchText = ym_searchText.lowercaseString;
    [_ym_resultArray removeAllObjects];
    for (YMCityModel *cityModel in _ym_cityArray) {
        if ([cityModel.name containsString:ym_searchText] || [cityModel.pinYin containsString:ym_searchText] || [cityModel.pinYinHead containsString:ym_searchText]) {
            [_ym_resultArray addObject:cityModel];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _ym_resultArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYCityCell *cell = [tableView dequeueReusableCellWithIdentifier:cityCellID forIndexPath:indexPath];
    YMCityModel *cityModel = _ym_resultArray[indexPath.row];
    cell.titleLabel.text = cityModel.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor_D001534;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kScreenW - 32, 30)];
    label.text = [NSString stringWithFormat:@"有%zd个搜索结果",_ym_resultArray.count];
    label.textColor = [ZYThemeManager shareManager].titleThemeColor;
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YMCityModel *cityModel = _ym_resultArray[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ym_searchCityResult" object:nil userInfo:@{@"ym_searchCityResultKey": cityModel.name}];
}

@end
