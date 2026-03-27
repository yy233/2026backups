//
//  MoneyWalletYuEMingXiListVc.m
//  Community
//
//  Created by 余莹 on 2021/2/20.
// @"余额明细"

#import "MoneyWalletYuEMingXiListVc.h"
#import "YuEMingXiHeaderView.h"
#import "MoneyWalletYuEMingXiListVcTableViewCell.h"
#define  MoneyWalletYuEMingXiListVcTableViewCell_Identifier @"MoneyWalletYuEMingXiListVcTableViewCell"
#import "MoneyWalletYuEMingXiDetailVc.h"
@interface MoneyWalletYuEMingXiListVc () <YuEMingXiHeaderViewDelegate>
@property (nonatomic,strong) YuEMingXiHeaderView *headerView;
@property (nonatomic,assign) YuEMingXi_Type listType;
// 当前页码
@property (nonatomic, assign) NSInteger currentPage;
@end

@implementation MoneyWalletYuEMingXiListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"余额明细";
    self.listType = YuEMingXi_Type_ALL;
    [self initView];
    [self initRefreshing];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self setupNavigationBarWhiteStyle];
}
- (void)initView{
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.backgroundColor = Color_245Gray;
//    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [UIView new];
}
- (void)initRefreshing {
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf initBalanceDetailData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage += 1;
        [weakSelf initBalanceDetailData];
        // 禁用header
        weakSelf.tableView.mj_header.hidden = YES;
    }];
    if ([ZYThemeManager shareManager].themeType == ZYThemeType_Dark) {
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    }
    self.tableView.mj_header = header;
    self.tableView.mj_footer = footer;
    // 自动加载数据
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark ==
- (void)headerViewTouchSubBtnWithType:(YuEMingXi_Type)type{
    DLog(@"");
    if (self.dataSourceArr.count > 0) {
        [self.dataSourceArr removeAllObjects];
    }
    [self.tableView reloadData];
    
    self.listType = type;
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark ==
- (void)initBalanceDetailData {
    NSDictionary *parms = [NSDictionary dictionary];
    //tradeType 1:支出 2:收入
    if (self.listType == YuEMingXi_Type_ALL) {
        parms = @{@"page" : @(self.currentPage), @"size" : @(20)};
    }else if (self.listType == YuEMingXi_Type_ShouRu){
        parms = @{@"page" : @(self.currentPage), @"size" : @(20), @"query" : @{@"tradeType" : @(2)}};
    }else if (self.listType == YuEMingXi_Type_ZhiChu){
        parms = @{@"page" : @(self.currentPage), @"size" : @(20), @"query" : @{@"tradeType" : @(1)}};
    }
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@", BASE_URL, URL_Post_AccountWater] withBody:parms finished:^(id responsObject, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = NO;
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 移除所有数据
                if (self.currentPage == 1) {
                    [self.dataSourceArr removeAllObjects];
                }
                ZYBalanceDetailModel *model = [ZYBalanceDetailModel yy_modelWithJSON:responsObject];
                ZYBalanceDetailDataModel *dataModel = model.data;
                NSArray *array = dataModel.records;
                [self.dataSourceArr addObjectsFromArray:array];
                // 判断数据是否加载完了
                if (self.dataSourceArr.count >= dataModel.total) {
                    // 表示没有数据可以请求，设置UITableView footer的状态
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    // 重置提示加载更多数据
                    [self.tableView.mj_footer resetNoMoreData];
                }
                // 刷新tableView
                [self.tableView reloadData];
                
                if (!self.dataSourceArr.count) {
                    self.tableView.mj_footer.hidden = YES;
                }
            }else {
                if (self.currentPage > 1) {
                    self.currentPage -= 1;
                }
                if (self.currentPage == 1) {
                    self.tableView.mj_footer.hidden = YES;
                }
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else {
            if (self.currentPage > 1) {
                self.currentPage -= 1;
            }
            if (self.currentPage == 1) {
                self.tableView.mj_footer.hidden = YES;
            }
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MoneyWalletYuEMingXiDetailVc *vc = [[MoneyWalletYuEMingXiDetailVc alloc]init];
//    vc.type = [self.dataSourceArr[indexPath.row] integerValue];//test
    ZYBalanceDetailDataRecordsModel *model = self.dataSourceArr[indexPath.row];
    vc.detailModel = model;
    [self pushVc:vc];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  self.dataSourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoneyWalletYuEMingXiListVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MoneyWalletYuEMingXiListVcTableViewCell_Identifier];
    if (!cell) {
        cell = [[MoneyWalletYuEMingXiListVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MoneyWalletYuEMingXiListVcTableViewCell_Identifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *accessoryImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Settings_arrow"]];
        CGRect frame = accessoryImgView.frame;
        frame.size.width = frame.size.width + 10;
        accessoryImgView.frame = frame;
        [accessoryImgView setContentMode:UIViewContentModeLeft];
        cell.accessoryView = accessoryImgView;
        cell.separatorInset = UIEdgeInsetsMake(0,16, 0, 16);
    }
//    if (self.listType==YuEMingXi_Type_ZhiChu) {
//        [cell fillCellData:@{} withType:1];
//    }else if (self.listType==YuEMingXi_Type_ShouRu){
//        [cell fillCellData:@{} withType:2];
//    }else{
//        [cell fillCellData:@{} withType:[self.dataSourceArr[indexPath.row] integerValue]];
//    }
    ZYBalanceDetailDataRecordsModel *model = self.dataSourceArr[indexPath.row];
    cell.model = model;
  
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

#pragma mark === 列表组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            CGFloat cornerRadius = 7.0f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
            } else  if (indexPath.row==0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            }else if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            }else{
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            
            //颜色修改
            layer.fillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
            layer.strokeColor= [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;//线
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}
 
#pragma mark ==
- (YuEMingXiHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[YuEMingXiHeaderView alloc]initWithFrame:CGRectZero];
        _headerView.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
        _headerView.delegage = self;
    }
    return _headerView;
}
@end
