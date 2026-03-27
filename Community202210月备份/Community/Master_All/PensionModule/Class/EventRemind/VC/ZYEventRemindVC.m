//
//  ZYEventRemindVC.m
//  Community
//
//  Created by ZY on 2021/11/9.
//

#import "ZYEventRemindVC.h"
#import "ZYEditEventVC.h"
#import "ZYEventRemindDetailVC.h"
#import "ZYEventRemindTopView.h"
#import "ZYEventRemindBottomView.h"
#import "ZYEventRemindCell.h"

static NSString * const eventRemindCellID = @"ZYEventRemindCell";
#define kEventRemindTopViewHeight 95
#define kEventRemindBottomViewHeight button_bottom_height+45

@interface ZYEventRemindVC () <UITableViewDataSource, UITableViewDelegate, ZYEventRemindTopViewDelegate, ZYEventRemindBottomViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) ZYEventRemindTopView *topView;

@property (nonatomic, strong) ZYEventRemindBottomView *bottomView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *topDataArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 选择的日期
@property (nonatomic, assign) NSInteger currentWeekNum;

@end

@implementation ZYEventRemindVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"事件提醒";
    [self setUI];
    [self customTableView];
    [self handleDateData];
    [self initTopViewData];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initData];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"PENSION_ADD_EDIT_EVENT_BACK", pensionAddEditEventBack)
    Y_NSNotificationCenter_Creat_NameAction(@"PENSION_DELETE_EVENT_BACK", pensionDeleteEventBack)
}

// 通知回调
- (void)pensionAddEditEventBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.mj_header beginRefreshing];
    });
}

- (void)pensionDeleteEventBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.mj_header beginRefreshing];
    });
}

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"PENSION_ADD_EDIT_EVENT_BACK")
    Y_NSNotificationCenter_RemoveNotice_Name(@"PENSION_DELETE_EVENT_BACK")
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBarStyleWithColor];
}

- (void)setUI {
    [self.view addSubview:self.topView];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(kEventRemindTopViewHeight);
    }];
    [self.view addSubview:self.bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(_bottomView.superview);
        make.height.offset(kEventRemindBottomViewHeight);
    }];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_tableView.superview);
        make.top.equalTo(_topView.mas_bottom).offset(6);
        make.bottom.equalTo(_bottomView.mas_top);
    }];
}

#pragma mark - 懒加载
- (ZYEventRemindTopView *)topView {
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"ZYEventRemindTopView" owner:nil options:nil].lastObject;
        _topView.delegate = self;
    }
    
    return _topView;
}

- (ZYEventRemindBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"ZYEventRemindBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    
    return _bottomView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    
    return _tableView;
}

- (NSMutableArray *)topDataArray {
    if (!_topDataArray) {
        _topDataArray = [NSMutableArray array];
    }
    
    return _topDataArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
// 加载顶部视图数据
- (void)initTopViewData {
    
    self.topView.dataArray = [self.topDataArray copy];
}

// 加载内容数据
- (void)initData {
    NSDictionary *params = @{@"week" : @(self.currentWeekNum)};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:[NSString stringWithFormat:@"%@%@", kPensionBaseUrl, kEventListUrl] withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.dataArray.count > 0) {
                        [self.dataArray removeAllObjects];
                    }
                    NSArray *array = [NSArray yy_modelArrayWithClass:[ZYEventRemindModel class] json:responsObject[@"data"]];
                    [self.dataArray addObjectsFromArray:array];
                    if (!self.dataArray.count) {
                        [self emptyDataDelegate];
                    }
                    [self.tableView reloadData];
                });
            }else {
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - 处理顶部视图日期数据
- (void)handleDateData {
    NSInteger dayCount = [self getInMonthNumberOfDays];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM"];
    NSString *currentDateStr1 = [dateFormatter1 stringFromDate:[NSDate date]];
    NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr2 = [dateFormatter2 stringFromDate:[NSDate date]];
    self.currentWeekNum = [ZYWeekStringTool weekdayNumWithString:[NSDate date].br_weekdayString];
    NSInteger currentDateDay = [NSDate date].br_day;
    for (NSInteger i = 1; i <= dayCount; i++) {
        ZYEventRemindTopModel *model = [[ZYEventRemindTopModel alloc] init];
        model.day = [NSString stringWithFormat:@"%02ld", i];
        NSString *tempDateStr = [NSString stringWithFormat:@"%@-%02ld", currentDateStr1, i];
        model.date = tempDateStr;
        model.weekNum = [ZYWeekStringTool weekdayNumWithString:[dateFormatter2 dateFromString:tempDateStr].br_weekdayString];
        if ([tempDateStr isEqual:currentDateStr2]) {
            model.isSelected = YES;
            model.week = @"今日";
        }else {
            model.isSelected = NO;
            NSDate *tempDate = [dateFormatter2 dateFromString:tempDateStr];
            model.week = tempDate.br_weekdayString;
        }
        if (i >= currentDateDay) {
            model.isPast = NO;
        }else {
            model.isPast = YES;
        }
        [self.topDataArray addObject:model];
    }
}

// 获取当月的天数
- (NSInteger)getInMonthNumberOfDays {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *currentDate = [NSDate date];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    
    return range.length;
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:eventRemindCellID bundle:nil] forCellReuseIdentifier:eventRemindCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZYEventRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:eventRemindCellID forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    ZYEventRemindCell *cell = (ZYEventRemindCell *)currentCell;
    if (indexPath.row == 0) {
        cell.topLineView.hidden = YES;
    }else {
        cell.topLineView.hidden = NO;
    }
    if (indexPath.row == self.dataArray.count - 1) {
        cell.bottomView.hidden = YES;
    }else {
        cell.bottomView.hidden = NO;
    }
    ZYEventRemindModel *model = self.dataArray[indexPath.row];
    cell.model = model;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [tableView fd_heightForCellWithIdentifier:eventRemindCellID cacheByIndexPath:indexPath configuration:^(ZYEventRemindCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"%ld", indexPath.row);
    ZYEventRemindModel *model = self.dataArray[indexPath.row];
    [self.tableView reloadData];
    ZYEventRemindDetailVC *vc = [[ZYEventRemindDetailVC alloc] init];
    vc.eventModel = model;
    [self pushVc:vc];
}

#pragma mark - ZYEventRemindTopViewDelegate
- (void)collectionViewSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYEventRemindTopModel *model = self.topDataArray[indexPath.row];
    NSLog(@"%@", model.date);
    if (!model.isPast) {
        self.currentWeekNum = model.weekNum;
        for (ZYEventRemindTopModel *tempModel in self.topDataArray) {
            if (tempModel == model) {
                tempModel.isSelected = YES;
            }else {
                tempModel.isSelected = NO;
            }
        }
        [self initTopViewData];
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - ZYEventRemindBottomViewDelegate
// 添加事件
- (void)addEventButtonEvent {
    
    NSLog(@"添加提醒事件");
    ZYEditEventVC *vc = [[ZYEditEventVC alloc] init];
    vc.type = @"add";
    [self pushVc:vc];
}

#pragma mark -  无数据占位协议
- (void)emptyDataDelegate {
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}

#pragma mark - DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
// 标题文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *emptyTitle = @"今日没有事件了";
    NSDictionary *attributs = @{
        NSFontAttributeName:[UIFont systemFontOfSize:21],
        NSForegroundColorAttributeName:[UIColor zy_colorWithHexString:@"#2B2C2F"]
    };
    
    return [[NSAttributedString alloc]initWithString:emptyTitle attributes:attributs];
}

// 内容
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *emptyContent = @"点击下方+号添加新事件";
    NSDictionary *attributs = @{
        NSFontAttributeName:[UIFont systemFontOfSize:12],
        NSForegroundColorAttributeName:[UIColor zy_colorWithHexString:@"#333333"]
    };
    
    return [[NSAttributedString alloc]initWithString:emptyContent attributes:attributs];
}

// 图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    
    return nil;
}

// 垂直方向
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{

    return -50;
}

// 各个子控件垂直间距
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    
    return 20;
}

// 是否允许滚动
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}

@end
