//
//  ZYSmallShopMainVC.m
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import "ZYSmallShopMainVC.h"
#import "ZYSmallShopContainerRentVc.h"
#import "ZYSmallShopHotRecommendVc.h"
#import "ZYSmallShopGoodsListVc.h"
#import "ZYSmallShopGoodsDetailVc.h"
#import "ZYSmallShopServiceVc.h"
#import "ZYSmallShopServiceDetailVc.h"
#import "ZYSmallShopGoodsSpellGroupDetailVc.h"
#import "ZYSmallShopMainNavigationView.h"
#import "ZYSmallShopMainTopHeaderView.h"
#import "ZYSmallShopMainTitleHeaderView.h"
#import "ZYSmallShopMainMenuCell.h"
#import "ZYSmallShopMainAdvertisingCell.h"
#import "ZYSmallShopMainShopCell.h"
#import "ZYSmallShopMainSpellGroupCell.h"
#import "SmallShopPersonCenterMainVC.h"
#import "SmallShopInfomationVC.h"


static NSString * const ZYSmallShopMainMenuCellID = @"ZYSmallShopMainMenuCell";
static NSString * const ZYSmallShopMainAdvertisingCellID = @"ZYSmallShopMainAdvertisingCell";
static NSString * const ZYSmallShopMainShopCellID = @"ZYSmallShopMainShopCell";
static NSString * const ZYSmallShopMainSpellGroupCellID = @"ZYSmallShopMainSpellGroupCell";
#define kZYSmallShopMainNavigationViewHeight 357+status_height-20
#define kZYSmallShopMainTopHeaderViewHeight 50
#define kZYSmallShopMainAdvertisingCellHeight 124
#define kZYSmallShopMainTitleHeaderViewHeight 45
#define kZYSmallShopMainSpellGroupCellHeight 208

@interface ZYSmallShopMainVC () <UITableViewDataSource, UITableViewDelegate, ZYSmallShopMainNavigationViewDelegate, ZYSmallShopMainTopHeaderViewDelegate, ZYSmallShopMainTitleHeaderViewDelegate, ZYSmallShopMainMenuCellDelegate, ZYSmallShopMainShopCellDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) ZYSmallShopMainNavigationView *naviView;

@property (nonatomic, strong) ZYSmallShopMainTopHeaderView *topHeaderView;

@property (nonatomic, strong) ZYSmallShopMainTitleHeaderView *titleHeaderView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 瀑布流视图高度
@property (nonatomic, assign) CGFloat waterfallViewHeight;

// 是否有拼团
@property (nonatomic, assign) BOOL isHaveSpellGroup;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) ZYSmallShopMainModel *model;

@end

@implementation ZYSmallShopMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // pop返回手势
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.title = @"";
    [self setUI];
    [self customTableView];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf initData];
        // 禁用footer
        weakSelf.tableView.mj_footer.hidden = YES;
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf initData];
        // 禁用header
        weakSelf.tableView.mj_header.hidden = YES;
    }];
    [self.tableView.mj_header beginRefreshing];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"WATER_FALL_LAYOUT_COMPLETE_BACK", waterFallLayoutCompleteBack:);
    Y_NSNotificationCenter_Creat_NameAction(@"SMALL_SHOP_PAY_SUCCESS_BACK", smallShopPaySuccessBack);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    [self hiddenNavigationBar];
}

// 通知回调
- (void)waterFallLayoutCompleteBack:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat height = [noti.object doubleValue];
        self.waterfallViewHeight = height;
        [self.tableView reloadData];
    });
}

- (void)smallShopPaySuccessBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.currentPage = 1;
        [self initData];
    });
}

// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"WATER_FALL_LAYOUT_COMPLETE_BACK");
    Y_NSNotificationCenter_RemoveNotice_Name(@"SMALL_SHOP_PAY_SUCCESS_BACK");
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.naviView];
    [_naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_naviView.superview);
        make.height.offset(kZYSmallShopMainNavigationViewHeight);
    }];
    
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_tableView.superview).offset(status_height + 44);
        make.left.right.bottom.equalTo(_tableView.superview);
    }];
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (ZYSmallShopMainNavigationView *)naviView {
    if (!_naviView) {
        _naviView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopMainNavigationView" owner:nil options:nil].lastObject;
        _naviView.delegate = self;
    }
    
    return _naviView;
}

- (ZYSmallShopMainTopHeaderView *)topHeaderView {
    if (!_topHeaderView) {
        _topHeaderView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopMainTopHeaderView" owner:nil options:nil].lastObject;
        _topHeaderView.delegate = self;
    }
    
    return _topHeaderView;
}

- (ZYSmallShopMainTitleHeaderView *)titleHeaderView {
    if (!_titleHeaderView) {
        _titleHeaderView = [[NSBundle mainBundle] loadNibNamed:@"ZYSmallShopMainTitleHeaderView" owner:nil options:nil].lastObject;
        _titleHeaderView.delegate = self;
    }
    
    return _titleHeaderView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
- (void)initData {
    NSLog(@"token=%@ communityId=%ld", [ShareUserInfo sharedUserInfo].token, [ShareUserInfo sharedUserInfo].commuityInfo.ID);
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID), @"page" : @(self.currentPage), @"rows" : @(20)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:ZY_BASEURL(kSmallShopHomeUrl)  withBody:params finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_header.hidden = NO;
            self.tableView.mj_footer.hidden = NO;
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    // 移除所有数据
                    if (self.currentPage == 1) {
                        [self.dataArray removeAllObjects];
                    }
                    ZYSmallShopMainModel *model = [ZYSmallShopMainModel yy_modelWithJSON:responsObject[@"data"]];
                    self.model = model;
                    [SmallShopNowShopShare share].saveNowShopId = [TextShowWithModelStr textShowWithModelStr:model.value4];//存储当前仓储小店id
                    [SmallShopNowShopShare share].saveNowShopIMId = [TextShowWithModelStr textShowWithModelStr:model.value5];//imid
                    [self initThisStoreOtherInfo];//获取店铺信息

                    ZYSmallShopMainValue3Model *value3Model = model.value3;
                    [self.dataArray addObjectsFromArray:value3Model.records];
                    // 判断数据是否加载完了
                    if (self.dataArray.count >= value3Model.total) {
                        // 表示没有数据可以请求，设置UITableView footer的状态
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else {
                        // 重置提示加载更多数据
                        [self.tableView.mj_footer resetNoMoreData];
                    }
                    if (isNotNil(model.value2)) {
                        self.isHaveSpellGroup = YES;
                    }else {
                        self.isHaveSpellGroup = NO;
                    }
                    if (!self.dataArray.count) {
                        self.tableView.mj_footer.hidden = YES;
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
        });
    }];
}
- (void)initThisStoreOtherInfo{
    if ([SmallShopNowShopShare share].saveNowShopId.length <= 0) {
        return;
    }
    [[ToolOfNetWork sharedTools]YYrequestALLURLGetNotMainQueue:ZY_BASEURL(@"zhsj/cabinet/store/selectInformation") withParams:@{@"storeId" : [SmallShopNowShopShare share].saveNowShopId }.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *getDic = Y_ResponsObject_dataDic;
                [SmallShopNowShopShare share].saveNowShopAddress = [[getDic allKeys]containsObject:@"storeAddress"] ? [TextShowWithModelStr textShowWithModelStr: [getDic objectForKey:@"storeAddress"] ] : @"暂无店铺地址信息"; //店铺地址
                [SmallShopNowShopShare share].saveNowShopPhone = [[getDic allKeys]containsObject:@"storePhone"] ? [TextShowWithModelStr textShowWithModelStr: [getDic objectForKey:@"storePhone"] ] : @"暂无店铺电话信息";//店铺电话
               [SmallShopNowShopShare share].saveNowShopLat =  [[getDic allKeys]containsObject:@"latitude"] ? [[getDic objectForKey:@"latitude"] floatValue] : 0.0;//店铺电话
              [SmallShopNowShopShare share].saveNowShopLongi = [[getDic allKeys]containsObject:@"longitude"] ? [[getDic objectForKey:@"longitude"] floatValue] : 0.0;//店铺电话
                NSLog(@"店铺地址电话信息 == %@ 。%@",[SmallShopNowShopShare share].saveNowShopAddress,[SmallShopNowShopShare share].saveNowShopPhone);
            }else{
                [SmallShopNowShopShare share].saveNowShopAddress = @"暂无店铺地址信息"; //店铺地址
                [SmallShopNowShopShare share].saveNowShopPhone =  @"暂无店铺电话信息";//店铺电话
            }
        }else{
            [SmallShopNowShopShare share].saveNowShopAddress = @"暂无店铺地址信息"; //店铺地址
            [SmallShopNowShopShare share].saveNowShopPhone =  @"暂无店铺电话信息";//店铺电话
        }
    }];
}

#pragma mark - 定制tableView
- (void)customTableView {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopMainMenuCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopMainMenuCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopMainAdvertisingCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopMainAdvertisingCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopMainShopCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopMainShopCellID];
    [self.tableView registerNib:[UINib nibWithNibName:ZYSmallShopMainSpellGroupCellID bundle:nil] forCellReuseIdentifier:ZYSmallShopMainSpellGroupCellID];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYSmallShopMainMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopMainMenuCellID forIndexPath:indexPath];
        [self configureCell:cell atIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.section == 1) {
        if (self.isHaveSpellGroup) {
            ZYSmallShopMainSpellGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopMainSpellGroupCellID forIndexPath:indexPath];
            cell.model = self.model.value2;
            
            return cell;
        }else {
            ZYSmallShopMainAdvertisingCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopMainAdvertisingCellID forIndexPath:indexPath];
            
            return cell;
        }
    }else if (indexPath.section == 2) {
        ZYSmallShopMainShopCell *cell = [tableView dequeueReusableCellWithIdentifier:ZYSmallShopMainShopCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.dataArray = self.dataArray;
        
        return cell;
    }
    
    return nil;
}

- (void)configureCell:(UITableViewCell *)currentCell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZYSmallShopMainMenuCell *cell = (ZYSmallShopMainMenuCell *)currentCell;
        cell.delegate = self;
        cell.model = self.model;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:ZYSmallShopMainMenuCellID configuration:^(ZYSmallShopMainMenuCell *cell) {
            [self configureCell:cell atIndexPath:indexPath];
        }];
    }else if (indexPath.section == 1) {
        if (self.isHaveSpellGroup) {
            
            return kZYSmallShopMainSpellGroupCellHeight;
        }else {
            
            return kZYSmallShopMainAdvertisingCellHeight;
        }
    }else if (indexPath.section == 2) {
        
        return self.waterfallViewHeight;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return self.topHeaderView;
    }else if (section == 2) {
        
        return self.titleHeaderView;
    }
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        return kZYSmallShopMainTopHeaderViewHeight;
    }else if (section == 2) {
        
        return kZYSmallShopMainTitleHeaderViewHeight;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        
        return 20;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && self.isHaveSpellGroup) {
        NSLog(@"拼团");
        ZYSmallShopGoodsSpellGroupDetailVc *vc = [[ZYSmallShopGoodsSpellGroupDetailVc alloc] init];
        vc.model = self.model.value2;
        [self pushVc:vc];
    }
}

#pragma mark - ZYSmallShopMainNavigationViewDelegate
// 返回
- (void)backButtonEvent {
    [self popVC];
}

#pragma mark - ZYSmallShopMainTopHeaderViewDelegate
// 消息
- (void)messageButtonEvent {
    NSLog(@"消息");
    SmallShopInfomationVC *vc = [[SmallShopInfomationVC alloc]init];
    vc.infomationVc_type = InfomationVc_Type_smallShopMain;
    [self pushVc:vc];

}

// 个人中心
- (void)personButtonEvent {
    NSLog(@"个人中心");
    SmallShopPersonCenterMainVC *vc = [[SmallShopPersonCenterMainVC alloc]init];
    [self pushVc:vc];
}

#pragma mark - ZYSmallShopMainTitleHeaderViewDelegate
// 更多
- (void)moreButtonEvent {
    NSLog(@"更多");
    ZYSmallShopHotRecommendVc *vc = [[ZYSmallShopHotRecommendVc alloc] init];
    [self pushVc:vc];
}

#pragma mark - ZYSmallShopMainMenuCellDelegate
//// 共享货柜
//- (void)sharedContainerViewEvent {
//    NSLog(@"共享货柜");
//
//    ZYSmallShopContainerRentVc *vc = [[ZYSmallShopContainerRentVc alloc] init];
//    [self pushVc:vc];
//}

// 特价商品
- (void)bargainShopViewEvent {
    NSLog(@"特价商品");
    
    ZYSmallShopGoodsListVc *vc = [[ZYSmallShopGoodsListVc alloc] init];
    [self pushVc:vc];
}

// 便民服务
- (void)convenienceSerViceViewEvent {
    NSLog(@"便民服务");
    
    ZYSmallShopServiceVc *vc = [[ZYSmallShopServiceVc alloc] init];
    [self pushVc:vc];
}

#pragma mark - ZYSmallShopMainShopCellDelegate
// 商品
- (void)collectionViewSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"商品服务:%ld", indexPath.row);
    
    ZYSmallShopMainValue3RecordsModel *model = self.dataArray[indexPath.row];
    if (model.type == 1) {
        ZYSmallShopGoodsDetailVc *vc = [[ZYSmallShopGoodsDetailVc alloc] init];
        vc.commodityId = model.ID;
        [self pushVc:vc];
    }else if (model.type == 2) {
        ZYSmallShopServiceDetailVc *vc = [[ZYSmallShopServiceDetailVc alloc] init];
        vc.serveId = model.ID;
        [self pushVc:vc];
    }
}

@end
