//
//  ElectronicNewsListVc.m
//  Community
//
//  Created by 余莹 on 2021/1/26.
//

#import "ElectronicNewsListVc.h"
#import "ElectronicNewsDetailShowVc.h"
#import "ZYContractKnowledgeListModel.h"
#import "ZYMoulageHelperBarView.h"

#import "ElectronicSignatureNewsTableViewCell.h"
#define  ElectronicSignatureNewsTableViewCell_Identifier  @"ElectronicSignatureNewsTableViewCell"
//
#define Height_NewsCell  85
#define Height_SectionOneHeaderView  129.0
@interface ElectronicNewsListVc () <UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) ZYMoulageHelperBarView *barView;
@property (nonatomic,strong) ZYEmptyDataTableView *tableView;
@property (nonatomic,strong) UIView *sectionOneView;
@property (nonatomic, strong) UIImageView *titleImageV;
@property (nonatomic,strong) UIImageView *topTitleImgV;

// 合同知识数组
@property (nonatomic, strong) NSMutableArray *contractKnowledgeArray;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ElectronicNewsListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self setBarUI];
    [self.view bringSubviewToFront:self.barView];
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.currentPage = 1;
        [weakSelf initContractKnowledgeListData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.currentPage += 1;
        [weakSelf initContractKnowledgeListData];
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self hiddenNavigationBar];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self setupNavigationBarClearTransparentStyle];
}
- (void)setBarUI {
    
    [self.view addSubview:self.barView];
    [_barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_barView.superview);
        make.height.offset(44 + status_height);
    }];
}

#pragma mark - 懒加载
- (ZYMoulageHelperBarView *)barView {
    if (!_barView) {
        _barView = [[NSBundle mainBundle] loadNibNamed:@"ZYMoulageHelperBarView" owner:nil options:nil].lastObject;
        [_barView.backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        _barView.titleLabel.hidden = YES;
        _barView.rightButton.hidden = YES;
    }
    
    return _barView;
}

- (ZYEmptyDataTableView *)tableView{
    if (!_tableView) {
        _tableView = [[ZYEmptyDataTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIView *)sectionOneView{
    if (!_sectionOneView) {
        _sectionOneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, (Screen_W-32) * 112/343 + 17)];
        UIImageView *imgv = [[UIImageView alloc] initWithFrame:CGRectMake(16, 17, Screen_W-32, (Screen_W-32) * 112/343)];
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.image = [UIImage imageNamed:@"htbaneer"];
        [_sectionOneView addSubview:imgv];
    }
    return _sectionOneView;
}

- (UIImageView *)titleImageV {
    if (!_titleImageV) {
        _titleImageV = [[UIImageView alloc] init];
        _titleImageV.image = [[ZYThemeManager shareManager] themeImageNamed:@"title_newsHeaderv"];
    }
    
    return _titleImageV;
}

- (UIImageView *)topTitleImgV{
    if (!_topTitleImgV) {
        _topTitleImgV = [[UIImageView alloc] init];
        _topTitleImgV.image = [[ZYThemeManager shareManager] themeImageNamed:@"newsHeaderv"];
    }
    return _topTitleImgV;
}

- (NSMutableArray *)contractKnowledgeArray {
    if (!_contractKnowledgeArray) {
        _contractKnowledgeArray = [NSMutableArray array];
    }
    
    return _contractKnowledgeArray;
}

#pragma mark - 加载数据
// 合同知识列表数据
- (void)initContractKnowledgeListData {
    
    NSDictionary *parms = @{@"pageNum" : @(self.currentPage), @"pageSize" : @(10)};
    [[ZYElectronicSignatureToolOfNetWork sharedTools] electronicSignatureRequestGetURL:kContractKnowledgeListUrl withParams:parms.mutableCopy finished:^(id  _Nonnull responsObject, NSError * _Nonnull error){
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = NO;
        
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                // 移除所有数据
                if (self.currentPage == 1) {
                    [self.contractKnowledgeArray removeAllObjects];
                }
                ZYContractKnowledgeListModel *model = [ZYContractKnowledgeListModel yy_modelWithJSON:responsObject];
                ZYContractKnowledgeListDataModel *dataModel = model.data;
                NSArray *array = dataModel.list;
                [self.contractKnowledgeArray addObjectsFromArray:array];
                // 判断数据是否加载完了
                if (self.contractKnowledgeArray.count >= dataModel.total) {
                    // 表示没有数据可以请求，设置UITableView footer的状态
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    // 重置提示加载更多数据
                    [self.tableView.mj_footer resetNoMoreData];
                }
                
                if (!self.contractKnowledgeArray.count) {
                    self.tableView.mj_footer.hidden = YES;
                    // 空占位图文
                    [self.tableView emptyDataDelegate];
                }
                
                // 刷新tableView
                [self.tableView reloadData];
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

#pragma mark ==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZYContractKnowledgeListDataListModel *model = self.contractKnowledgeArray[indexPath.row];
    ElectronicNewsDetailShowVc *detaiVc = [[ElectronicNewsDetailShowVc alloc]init];
    detaiVc.detailModel = model;
    [self pushVc:detaiVc];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contractKnowledgeArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Height_SectionOneHeaderView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Height_NewsCell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ElectronicSignatureNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ElectronicSignatureNewsTableViewCell_Identifier];
    if (!cell) {
        cell = [[ElectronicSignatureNewsTableViewCell alloc]init];
    }
//    [cell showCellWithDic:@{}.mutableCopy];
    ZYContractKnowledgeListDataListModel *model = self.contractKnowledgeArray[indexPath.row];
    cell.model = model;
    
    return cell;
}
 
#pragma mark==
- (void)initView{
    [self.view addSubview:self.topTitleImgV];
    [self.view addSubview:self.titleImageV];
    self.tableView.tableHeaderView = self.sectionOneView;
    [self.view addSubview:self.tableView];
    [_topTitleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_topTitleImgV.superview.mas_centerX);
        make.top.equalTo(_topTitleImgV.superview).with.offset(-1);
        make.height.offset(96 + status_height);
        make.width.offset(Screen_W);
    }];
    [_titleImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_titleImageV.superview);
        make.bottom.equalTo(_topTitleImgV.mas_bottom).offset(-26);
        make.width.offset(162);
        make.height.offset(54);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topTitleImgV.mas_bottom);
        make.left.equalTo(_tableView.superview.mas_left);
        make.right.equalTo(_tableView.superview.mas_right);
        make.bottom.equalTo(_tableView.superview);
    }];
}

#pragma mark - 点击事件
- (void)backButtonClicked {
    
    [self popVC];
}

@end
