//
//  HealthTemperatureTotalVc.m
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import "HealthTemperatureAndHeartBaseTotalVc.h"



//Height
#define  MainLinesView_Height     (300)
#define  TopViewHeaderView_Height (60)
#define  SectionHeaderView_Height (40)
//
@interface HealthTemperatureAndHeartBaseTotalVc () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@end

@implementation HealthTemperatureAndHeartBaseTotalVc

- (HealthTempAndHeartBaseTotalBrokenLineGraphView *)mainLinesView{
    if (!_mainLinesView) {
        _mainLinesView = [[HealthTempAndHeartBaseTotalBrokenLineGraphView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, MainLinesView_Height)];
    }
    return _mainLinesView;
}
- (HealthTempAndHeartBaseTotalTopView *)topView{
    if (!_topView) {
        _topView = [[HealthTempAndHeartBaseTotalTopView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, TopViewHeaderView_Height)];
    }
    return _topView;
}
//
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}
- (LabelYu *)tableViewHeaderView{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[LabelYu alloc]initWithFrame:CGRectMake(0, 0, Screen_W, (10+50))];//10灰色
        //
        _tableViewHeaderView.backgroundColor = [UIColor whiteColor];
        _tableViewHeaderView.textInsets = UIEdgeInsetsMake(0, 16, 0, 0);
        _tableViewHeaderView.text = @"异常记录";
        /**
         CGSize size = CGSizeMake(Screen_W, 10);
         UIColor *beginColor = Y_ColorWith16FromRGB(0xF0F1F6);
         UIColor *endColor =   Y_ColorWith16FromRGB(0xF0F1F6);
         _tableViewHeaderView.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:endColor];
         */
    }
    return _tableViewHeaderView;
}
//
#pragma mark ==
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"体温";
    self.view.backgroundColor = [UIColor whiteColor];
    self.topViewChooseType = TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisDay;
    [self initView];
    [self emptyInfoInit];
    [self addRefresh];
    [self initData];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarStyleWithSOSColor];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}

#pragma mark ==
- (void)initData{
    [self.tableView reloadData];//有无数据都要先切换界面
    //更新数据
    if (self.topViewChooseType ==  TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisDay) {
        [self getOneDayData];
    }else if (self.topViewChooseType ==  TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisWeak){
        self.weakPageTurnIndexNum = -1;
        [self getOneWeakData];
    }else{
        self.monthPageTurnIndexNum = -1;
        [self getOneMonthData];
    }
}
- (void)getOneDayData{
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView.mj_header endRefreshing];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
    [self reUpMainLinesView];
  
}
- (void)getOneWeakData{
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView.mj_header endRefreshing];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
    [self reUpMainLinesView];
    
}
- (void)getOneMonthData{
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView.mj_header endRefreshing];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
    [self reUpMainLinesView];
}
 
#pragma mark === 周 时间切换
- (void)timeChangeWithLastWeak{
    self.weakPageTurnIndexNum -= 1;
    [self getOneWeakData];
    
}
- (void)timeChangeWithNextWeak{
    if (self.weakPageTurnIndexNum < -1) {
        self.weakPageTurnIndexNum += 1;
        [self getOneWeakData];
    }else{
        Y_SVP_SHOW_INFO_MES(@"没有更多周数据！");
    }
  
}
#pragma mark === 年 时间切换
- (void)timeChangeWithLastYear{
    self.monthPageTurnIndexNum -= 1;
    [self getOneMonthData];
}
- (void)timeChangeWithNextYear{
    if (self.monthPageTurnIndexNum < -1) {
        self.monthPageTurnIndexNum += 1;
        [self getOneMonthData];
    }else{
        Y_SVP_SHOW_INFO_MES(@"没有更多年数据！");
    }
}
#pragma mark ===
- (void)initView{
   
    [self.view addSubview:self.topView];
    [self.view addSubview:self.mainLinesView];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    self.tableView.tableFooterView  = [UIView new];
    WEAKSELF
    self.topView.chooseTypeBlock = ^(TempAndHeartTotalTopView_SubBtn_Choose_Type type) {
        weakSelf.topViewChooseType = type;
        [weakSelf initData]; 
    };
    [self setUI];
}
- (void)setUI{
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_topView.superview);
        make.height.offset(TopViewHeaderView_Height);
    }];
    [_mainLinesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(MainLinesView_Height);
        make.left.right.equalTo(_tableView.superview);
        make.top.equalTo(_topView.mas_bottom);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_tableView.superview);
        make.bottom.equalTo(_tableView.superview).offset(0);
        make.top.equalTo(_mainLinesView.mas_bottom);
    }];
}

#pragma mark == == == == == == == == == ==
- (void)reUpMainLinesView{
    
}
#pragma mark == == == == == == == == == ==
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableViewDataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (NSMutableArray *)tableViewDataSourceArr{
    if (!_tableViewDataSourceArr) {
        _tableViewDataSourceArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _tableViewDataSourceArr;
}
- (NSMutableArray *)saveTableViewDataSourceArrTouchStatus{
    if (!_saveTableViewDataSourceArrTouchStatus) {
        _saveTableViewDataSourceArrTouchStatus = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveTableViewDataSourceArrTouchStatus;
}

#pragma mark ==  无数据占位 协议
- (void)emptyInfoInit{
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
}
#pragma mark - 文字
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *emptyTitle = @"";
    NSDictionary *attributs = @{
        NSFontAttributeName:[UIFont systemFontOfSize:15],
        NSForegroundColorAttributeName:[ThemeManager shareManager].mainTextColor
    };
    return [[NSAttributedString alloc]initWithString:emptyTitle attributes:attributs];
}
#pragma mark - 图片
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.tableViewDataSourceArr.count==0) {//section 组数空 才给占位图，
        return [UIImage imageNamed:@"Nomal_ZeroWidthIcon"];
    }else{
        return [UIImage new];//section 非空。row无论是否为0展开折叠 都不给展位图
    }
 
}
#pragma mark - 中心位置
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return self.tableView.tableHeaderView.height * 0.5;
}
// 是否允许滚动 ｜有数据能正常下拉刷新 空数据时 无法下拉动作 设置yes即可正常
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    
    return YES;
}
#pragma mark -  无数据占位 end@end
@end


