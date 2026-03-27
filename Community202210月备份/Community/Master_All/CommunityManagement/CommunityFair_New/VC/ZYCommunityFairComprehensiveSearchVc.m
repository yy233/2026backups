//
//  ZYCommunityFairComprehensiveSearchVc.m
//  Community
//
//  Created by ZY on 2022/6/10.
//

#import "ZYCommunityFairComprehensiveSearchVc.h"
#import "ZYCommunityFairSearchRecordsTopView.h"
#import "ZYCommunityFairComprehensiveSearchView.h"
#import "ZYCommunityFairComprehensiveSearchCell.h"
#import "ZYCommunityFairComprehensiveSearchSelectPopView.h"
#import "ZYCommunityFairComprehensiveSearchFiltratePopView.h"

typedef enum : NSUInteger {
    ZYSelectPopView_Type_None = 0,          //未选择
    ZYSelectPopView_Type_Composite = 1,     //综合选择
    ZYSelectPopView_Type_Region = 2,        //区域选择
} ZYSelectPopView_Type;

static NSString * const ZYCommunityFairComprehensiveSearchCellID = @"ZYCommunityFairComprehensiveSearchCell";
#define kZYCommunityFairSearchRecordsTopViewHeight status_height+45
#define kZYCommunityFairComprehensiveSearchViewHeight 45
#define kZYCommunityFairComprehensiveSearchCellHeight 140

@interface ZYCommunityFairComprehensiveSearchVc () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, ZYCommunityFairSearchRecordsTopViewDelegate, ZYCommunityFairComprehensiveSearchViewDelegate, ZYCommunityFairComprehensiveSearchSelectPopViewDelegate, ZYCommunityFairComprehensiveSearchFiltratePopViewDelegate>

@property (nonatomic, strong) ZYCommunityFairSearchRecordsTopView *topView;

@property (nonatomic, strong) ZYCommunityFairComprehensiveSearchView *comprehensiveSearchView;

@property (nonatomic, strong) ZYEmptyDataTableView *tableView;

@property (nonatomic, strong) ZYCommunityFairComprehensiveSearchSelectPopView *selectPopView;

@property (nonatomic, strong) ZYCommunityFairComprehensiveSearchFiltratePopView *filtratePopView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) ZYSelectPopView_Type type;

@end

@implementation ZYCommunityFairComprehensiveSearchVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self setUI];
    [self customTableView];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self hiddenNavigationBar];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kZYCommunityFairSearchRecordsTopViewHeight);
    }];
    [self.view addSubview:self.comprehensiveSearchView];
    [_comprehensiveSearchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(10);
        make.left.right.equalTo(_comprehensiveSearchView.superview);
        make.height.offset(kZYCommunityFairComprehensiveSearchViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_comprehensiveSearchView.mas_bottom);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYCommunityFairSearchRecordsTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYCommunityFairSearchRecordsTopView" owner:nil options:nil].lastObject;
        _topView.searchTF.userInteractionEnabled = YES;
        _topView.searchTF.clearButtonMode = UITextFieldViewModeAlways;
        _topView.searchTF.delegate = self;
        _topView.delegate = self;
    }
    
    return _topView;
}

- (ZYCommunityFairComprehensiveSearchView *)comprehensiveSearchView {
    if (!_comprehensiveSearchView) {
        _comprehensiveSearchView = [[NSBundle mainBundle] loadNibNamed:@"ZYCommunityFairComprehensiveSearchView" owner:nil options:nil].lastObject;
        _comprehensiveSearchView.delegate = self;
    }
    
    return _comprehensiveSearchView;
}

- (ZYEmptyDataTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ZYEmptyDataTableView alloc] init];
    }
    
    return _tableView;
}

- (ZYCommunityFairComprehensiveSearchSelectPopView *)selectPopView {
    if (!_selectPopView) {
        _selectPopView = [[NSBundle mainBundle] loadNibNamed:@"ZYCommunityFairComprehensiveSearchSelectPopView" owner:nil options:nil].lastObject;
        _selectPopView.delegate = self;
    }
    
    return _selectPopView;
}

- (ZYCommunityFairComprehensiveSearchFiltratePopView *)filtratePopView {
    if (!_filtratePopView) {
        _filtratePopView = [[NSBundle mainBundle] loadNibNamed:@"ZYCommunityFairComprehensiveSearchFiltratePopView" owner:nil options:nil].lastObject;
        _filtratePopView.delegate = self;
    }
    
    return _filtratePopView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
- (void)initData {
    self.type = ZYSelectPopView_Type_None;
    [self.dataArray addObjectsFromArray:@[@"", @"", @"", @"", @"", @"", @"", @"", @""]];
    if (!self.dataArray.count) {
        [self.tableView emptyDataDelegate];
    }
    [self.tableView reloadData];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [ZYThemeManager shareManager].separatorLineBackgroundThemeColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYCommunityFairComprehensiveSearchCellID bundle:nil] forCellReuseIdentifier:ZYCommunityFairComprehensiveSearchCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYCommunityFairComprehensiveSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYCommunityFairComprehensiveSearchCellID forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kZYCommunityFairComprehensiveSearchCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.type = ZYSelectPopView_Type_None;
    [self.comprehensiveSearchView.compositeButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
    [self.comprehensiveSearchView.compositeButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
    [self.comprehensiveSearchView.regionButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
    [self.comprehensiveSearchView.regionButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
    [self.selectPopView hiddenCommunityFairComprehensiveSearchSelectPopView];
}

- (void)textFieldDidChangeSelection:(UITextField *)textField {
    
}

#pragma mark - ZYCommunityFairSearchRecordsTopViewDelegate
- (void)backButtonEvent {
    [self popVC];
}

- (void)searchButtonEvent {
    NSLog(@"搜索");
    [self.view endEditing:YES];
    self.type = ZYSelectPopView_Type_None;
    [self.comprehensiveSearchView.compositeButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
    [self.comprehensiveSearchView.compositeButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
    [self.comprehensiveSearchView.regionButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
    [self.comprehensiveSearchView.regionButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
    [self.selectPopView hiddenCommunityFairComprehensiveSearchSelectPopView];
}

#pragma mark - ZYCommunityFairComprehensiveSearchViewDelegate
// 综合选择
- (void)compositeButtonEvent {
    NSLog(@"综合选择");
    [self.view endEditing:YES];
    if (self.type != ZYSelectPopView_Type_Composite) {
        self.type = ZYSelectPopView_Type_Composite;
        [self.comprehensiveSearchView.compositeButton setTitleColor:[UIColor zy_colorWithHexString:@"#2672F9"] forState:UIControlStateNormal];
        [self.comprehensiveSearchView.compositeButton setImage:[UIImage imageNamed:@"sj_jsskip_down_select_icon"] forState:UIControlStateNormal];
        [self.comprehensiveSearchView.regionButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
        [self.comprehensiveSearchView.regionButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
        self.selectPopView.title = @"综合选择";
        self.selectPopView.dataArray = @[@"最新发布", @"价格从低到高", @"价格从高到低"];
        [self.selectPopView showCommunityFairComprehensiveSearchSelectPopViewWithSuperView:self.view];
    }else {
        self.type = ZYSelectPopView_Type_None;
        [self.comprehensiveSearchView.compositeButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
        [self.comprehensiveSearchView.compositeButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
        [self.comprehensiveSearchView.regionButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
        [self.comprehensiveSearchView.regionButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
        [self.selectPopView hiddenCommunityFairComprehensiveSearchSelectPopView];
    }
}

// 区域选择
- (void)regionButtonEvent {
    NSLog(@"区域选择");
    [self.view endEditing:YES];
    if (self.type != ZYSelectPopView_Type_Region) {
        self.type = ZYSelectPopView_Type_Region;
        [self.comprehensiveSearchView.regionButton setTitleColor:[UIColor zy_colorWithHexString:@"#2672F9"] forState:UIControlStateNormal];
        [self.comprehensiveSearchView.regionButton setImage:[UIImage imageNamed:@"sj_jsskip_down_select_icon"] forState:UIControlStateNormal];
        [self.comprehensiveSearchView.compositeButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
        [self.comprehensiveSearchView.compositeButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
        self.selectPopView.title = @"区域选择";
        self.selectPopView.dataArray = @[@"当前小区", @"所有小区"];
        [self.selectPopView showCommunityFairComprehensiveSearchSelectPopViewWithSuperView:self.view];
    }else {
        self.type = ZYSelectPopView_Type_None;
        [self.comprehensiveSearchView.compositeButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
        [self.comprehensiveSearchView.compositeButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
        [self.comprehensiveSearchView.regionButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
        [self.comprehensiveSearchView.regionButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
        [self.selectPopView hiddenCommunityFairComprehensiveSearchSelectPopView];
    }
}

// 筛选
- (void)filtrateButtonEvent {
    NSLog(@"筛选");
    [self.view endEditing:YES];
    [self.filtratePopView showCommunityFairComprehensiveSearchFiltratePopView];
    self.type = ZYSelectPopView_Type_None;
    [self.comprehensiveSearchView.compositeButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
    [self.comprehensiveSearchView.compositeButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
    [self.comprehensiveSearchView.regionButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
    [self.comprehensiveSearchView.regionButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
    [self.selectPopView hiddenCommunityFairComprehensiveSearchSelectPopView];
}

#pragma mark - ZYCommunityFairComprehensiveSearchSelectPopViewDelegate
- (void)popTableViewEvent {
    self.type = ZYSelectPopView_Type_None;
    [self.comprehensiveSearchView.compositeButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
    [self.comprehensiveSearchView.compositeButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
    [self.comprehensiveSearchView.regionButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
    [self.comprehensiveSearchView.regionButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
    [self.selectPopView hiddenCommunityFairComprehensiveSearchSelectPopView];
}

- (void)popViewContentViewEventWithIndex:(NSInteger)index {
    NSLog(@"%ld", index);
    self.type = ZYSelectPopView_Type_None;
    [self.comprehensiveSearchView.compositeButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
    [self.comprehensiveSearchView.compositeButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
    [self.comprehensiveSearchView.regionButton setTitleColor:[ZYThemeManager shareManager].subTitleThemeColor_Dc5c9d4 forState:UIControlStateNormal];
    [self.comprehensiveSearchView.regionButton setImage:[UIImage imageNamed:@"sj_jsskip_down_normal_icon"] forState:UIControlStateNormal];
    [self.selectPopView hiddenCommunityFairComprehensiveSearchSelectPopView];
    if (self.type == ZYSelectPopView_Type_Composite) {
        
    }else if (self.type == ZYSelectPopView_Type_Region) {
        
    }
}

#pragma mark - ZYCommunityFairComprehensiveSearchFiltratePopViewDelegate
// 关闭
- (void)closeButtonEvent {
    [self.filtratePopView hiddenCommunityFairComprehensiveSearchFiltratePopView];
}

// 重置
- (void)resetButtonEvent {
    NSLog(@"重置");
}

// 确认
- (void)okButtonEvent {
    NSLog(@"确认");
    [self.filtratePopView hiddenCommunityFairComprehensiveSearchFiltratePopView];
}

@end
