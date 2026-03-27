//
//  ZYSmallShopContainerRentVc.m
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import "ZYSmallShopContainerRentVc.h"
#import "ZYSmallShopContainerRentDetailVc.h"
#import "ZYSmallShopContainerRentCollectionViewCell.h"
#import "ZYEmptyDataCollectionView.h"

static NSString * const ZYSmallShopContainerRentCollectionViewCellID = @"ZYSmallShopContainerRentCollectionViewCell";
#define kZYSmallShopContainerRentCollectionViewCell_w (kScreenW-46)/2.0
#define kZYSmallShopContainerRentCollectionViewCell_H 113+(kScreenW-46)/2.0*102.0/145.0

@interface ZYSmallShopContainerRentVc () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ZYEmptyDataCollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ZYSmallShopContainerRentVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"货柜租用";
    [self setUI];
    [self customCollectionView];
    
    // 下拉刷新
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.currentPage = 1;
        [weakSelf initData];
        // 禁用footer
        weakSelf.collectionView.mj_footer.hidden = YES;
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage += 1;
        [weakSelf initData];
        // 禁用header
        weakSelf.collectionView.mj_header.hidden = YES;
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor zy_colorWithHexString:@"#F0F1F6"];
    [self setupNavigationBarStyleWithColor];
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview);
    }];
}

#pragma mark - 懒加载
- (ZYEmptyDataCollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[ZYEmptyDataCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    }
    
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 加载数据
- (void)initData {
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID), @"page" : @(self.currentPage), @"size" : @(20)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:ZY_BASEURL(kSmallShopContainerListUrl)  withBody:params finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            self.collectionView.mj_header.hidden = NO;
            self.collectionView.mj_footer.hidden = NO;
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    // 移除所有数据
                    if (self.currentPage == 1) {
                        [self.dataArray removeAllObjects];
                    }
                    ZYSmallShopContainerRentListModel *model = [ZYSmallShopContainerRentListModel yy_modelWithJSON:responsObject[@"data"]];
                    [self.dataArray addObjectsFromArray:model.records];
                    // 判断数据是否加载完了
                    if (self.dataArray.count >= model.total) {
                        // 表示没有数据可以请求，设置UITableView footer的状态
                        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                    }else {
                        // 重置提示加载更多数据
                        [self.collectionView.mj_footer resetNoMoreData];
                    }
                    // 刷新tableView
                    [self.collectionView reloadData];
                }else {
                    if (self.currentPage > 1) {
                        self.currentPage -= 1;
                    }
                    if (self.currentPage == 1) {
                        self.collectionView.mj_footer.hidden = YES;
                    }
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                if (self.currentPage > 1) {
                    self.currentPage -= 1;
                }
                if (self.currentPage == 1) {
                    self.collectionView.mj_footer.hidden = YES;
                }
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
            if (!self.dataArray.count) {
                self.collectionView.mj_footer.hidden = YES;
                // 空占位图文
                [self.collectionView emptyDataDelegate];
            }
            // 刷新tableView
            [self.collectionView reloadData];
        });
    }];
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:ZYSmallShopContainerRentCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:ZYSmallShopContainerRentCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYSmallShopContainerRentCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYSmallShopContainerRentCollectionViewCellID forIndexPath:indexPath];
    ZYSmallShopContainerRentListRecordsModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"货柜:%ld", indexPath.row);
    
    ZYSmallShopContainerRentDetailVc *vc = [[ZYSmallShopContainerRentDetailVc alloc] init];
    ZYSmallShopContainerRentListRecordsModel *model = self.dataArray[indexPath.row];
    vc.cabinetId = model.ID;
    vc.isHiddenRemainDay = YES;
    [self pushVc:vc];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kZYSmallShopContainerRentCollectionViewCell_w, kZYSmallShopContainerRentCollectionViewCell_H);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(15, 16, 20, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 13;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 13;
}

@end
