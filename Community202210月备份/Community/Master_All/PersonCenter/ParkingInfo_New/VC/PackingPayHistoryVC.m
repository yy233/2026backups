//
//  PackingPayHistoryVC.m
//  Community
//
//  Created by 余莹 on 2022/5/9.
//

#import "PackingPayHistoryVC.h"
#import "PackingPayHistoryVcTableViewCell.h"
#import "ChooseYearPopView.h"
#import "PackingPayHistoryDetailVC.h"
#import "MyCarInfoOrParkingOrPayHistoryData.h"

@interface PackingPayHistoryVC () <BasePopTableViewChooseDelegate>
@property (nonatomic,strong) UIButton *headerBtnView;
@property (nonatomic,strong) ChooseYearPopView *chooseYearPopView;
@property (nonatomic,strong) NSMutableArray *dataSourceOfPopViewUseYearInfoArr;
@property (nonatomic,strong) NSString *thisDataWithNowShowYearInfo;
@end

@implementation PackingPayHistoryVC

- (void)viewDidLoad {
    [self initYearsData];//基础数据
    [super viewDidLoad];
    NSString *titleStr = [NSString stringWithFormat:@"%@-%@",[ShareUserInfo sharedUserInfo].commuityInfo.name,@"缴费记录"];
    self.title = titleStr;
    [self initView];
    [self addRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDIsCountBlueAndWW];
}
- (void)initYearsData{
 
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    NSString *thisYearString = [dateformatter stringFromDate:senddate];
    self.thisDataWithNowShowYearInfo = [thisYearString stringByAppendingString:@"年"];//展示文本
    //
    NSInteger thisYearNum = [thisYearString integerValue];
    for (int i = 0; i<=20; i++) {
        [self.dataSourceOfPopViewUseYearInfoArr addObject:[NSString stringWithFormat:@"%ld年",thisYearNum]];
        thisYearNum -= 1;
    }
    NSLog(@"%@",self.dataSourceOfPopViewUseYearInfoArr);
    [self.headerBtnView newAnBtnWithTextStr:self.dataSourceOfPopViewUseYearInfoArr.firstObject];

}
- (void)initView{
    [self.headerBtnView layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:10];
    self.tableView.tableHeaderView = self.headerBtnView;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
     self.tableView.mj_header = headeerRefresh;
}
- (void)initData{
    NSString *yearNumStr = [self.thisDataWithNowShowYearInfo substringToIndex:4];//从0取到第n位
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithCapacity:0];
    [parms setValue:@( [ShareUserInfo sharedUserInfo].commuityInfo.ID ) forKey:@"communityId"];
    [parms setValue:yearNumStr forKey:@"years"];
    [parms setValue:@(1) forKey:@"page"];
    [parms setValue:@(9999) forKey:@"rows"];
    WEAKSELF
    [MyCarInfoOrParkingOrPayHistoryData  myCarSpotPayHistoryListWithParms:parms withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            weakSelf.dataSourceArr =  [NSMutableArray arrayWithArray: [PackingPayHistoryModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
    
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PackingPayHistoryDetailVC *vc = [[PackingPayHistoryDetailVC alloc]init];
    vc.historyModel = self.dataSourceArr[indexPath.section];
    [self pushVc:vc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PackingPayHistoryVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PackingPayHistoryVcTableViewCell_I];
    if(!cell){
        cell = [[PackingPayHistoryVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:PackingPayHistoryVcTableViewCell_I];
    }
    [cell fillModel:self.dataSourceArr[indexPath.section]];
    return cell;
}
 
#pragma mark ==
- (UIButton *)headerBtnView{
    if (!_headerBtnView) {
        _headerBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerBtnView.frame = CGRectMake(0, 0, Screen_W, 50);
        _headerBtnView.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
        [_headerBtnView newAnBtnWithTextColor:[ThemeManager shareManager].mainTextColor];
        [_headerBtnView newAnBtnWithFont:[UIFont systemFontOfSize:15.0]];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            [_headerBtnView newAnBtnWithImg:[UIImage imageNamed:@"Allaccountnumbers_Pulldown_black"]];
        }else{
            [_headerBtnView newAnBtnWithImg:[UIImage imageNamed:@"Allaccountnumbers_Pulldown_white"]];
        }
        [_headerBtnView addTarget:self action:@selector(headerAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _headerBtnView;
}
- (ChooseYearPopView *)chooseYearPopView{
    _chooseYearPopView = [[ChooseYearPopView alloc]init];
    _chooseYearPopView.delegate = self;
    [_chooseYearPopView thisPopViewHeaderOkBtnChangeColor];
    return _chooseYearPopView;
}

- (NSMutableArray *)dataSourceOfPopViewUseYearInfoArr{
    if (!_dataSourceOfPopViewUseYearInfoArr) {
        _dataSourceOfPopViewUseYearInfoArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceOfPopViewUseYearInfoArr;
}

#pragma mark ===
- (void)headerAction{
    [self.chooseYearPopView showInView:self.view thePopViewTableViewHeight:0 WithArray:self.dataSourceOfPopViewUseYearInfoArr];
}
//弹出框拿到数据 处理成新数据
- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath{
    NSString *chooseYearStr = self.dataSourceOfPopViewUseYearInfoArr[indexPath.row];
    //header
    [self.headerBtnView newAnBtnWithTextStr: chooseYearStr];
    //数据
    self.thisDataWithNowShowYearInfo = chooseYearStr;
    [self initData];
}
@end
