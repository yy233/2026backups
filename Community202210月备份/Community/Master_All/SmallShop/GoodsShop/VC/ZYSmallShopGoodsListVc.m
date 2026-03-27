//
//  ZYSmallShopGoodsListVc.m
//  Community
//
//  Created by ZY on 2022/3/2.
//

#import "ZYSmallShopGoodsListVc.h"
#import "ZYSmallShopGoodsDetailVc.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "ZYSmallShopMainShopCollectionViewCell.h"
#import "ZYEmptyDataCollectionView.h"

static NSString * const ZYSmallShopMainShopCollectionViewCellID = @"ZYSmallShopMainShopCollectionViewCell";

@interface ZYSmallShopGoodsListVc () <UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout>

@property (nonatomic, strong) ZYEmptyDataCollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) CGFloat labelHeight;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

// 当前model
@property (nonatomic, strong) ZYSmallShopMainValue3RecordsModel *currentModel;

@end

@implementation ZYSmallShopGoodsListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品列表";
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
      CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
      layout.sectionInset = UIEdgeInsetsMake(15, 16, 20, 16);
      layout.minimumColumnSpacing = 13;
      layout.minimumInteritemSpacing = 13;
      layout.columnCount  = 2;
      layout.itemRenderDirection = CHTCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst;
      _collectionView = [[ZYEmptyDataCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
      _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      _collectionView.backgroundColor = [UIColor clearColor];
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
    NSDictionary *params = @{@"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID), @"page" : @(self.currentPage), @"rows" : @(20)};
    [[ToolOfNetWork sharedTools] YrequestPostALLURLNoMainQueueWithBodyNotParms:ZY_BASEURL(kSmallShopCommodityListUrl)  withBody:params finished:^(id responsObject, NSError *error) {
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
                    ZYSmallShopMainValue3Model *model = [ZYSmallShopMainValue3Model yy_modelWithJSON:responsObject[@"data"]];
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

// 加载加入购物车数据
- (void)initAddShoppingCartData {
    NSDictionary *params = @{@"commodityId" : self.currentModel.ID};
    [[ToolOfNetWork sharedTools] YYrequestALLURLGetNotMainQueue:ZY_BASEURL(kSmallShopAddShoppingCartUrl) withParams:params.mutableCopy finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            Y_SVP_DISMISS
            if (isNotNil(responsObject)) {
                if (Y_IS_Success) {
                    [SVProgressHUD showSuccessCustomHUDWithStatus:@"加入成功，在购物车等亲！"];
                }else {
                    Y_SVP_SHOW_ERR_MESSAGE
                }
            }else {
                Y_SVP_SHOW_ERR_DESCRIPTION
            }
        });
    }];
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:ZYSmallShopMainShopCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:ZYSmallShopMainShopCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYSmallShopMainShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYSmallShopMainShopCollectionViewCellID forIndexPath:indexPath];
    ZYSmallShopMainValue3RecordsModel *model = self.dataArray[indexPath.row];
    cell.buyView.hidden = NO;
    cell.buyButton.tag = 200 + indexPath.row;
    [cell.buyButton addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.buyViewHeightConstraint.constant = 30;
    cell.model = model;
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYSmallShopMainValue3RecordsModel *model = self.dataArray[indexPath.row];
    CGSize size = [model.commodityName boundingRectWithSize:CGSizeMake(kZYSmallShopMainShopCollectionViewCell_W - 16, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil].size;
    self.labelHeight = size.height;
    if (size.height <= 36) {
        self.labelHeight = size.height;
    }else {
        self.labelHeight = 36;
    }
    ZYImageWidthHeightModel *imageWidthHeightModel = [ZYSmallShopImageUrlSegmentationTool imageUrlSegmentationWithUrlStr:model.commodityHeadImg];
    CGFloat height;
    CGFloat ratio;
    if (imageWidthHeightModel.width == 0) {
        ratio = 0;
    }else {
        ratio = imageWidthHeightModel.height / imageWidthHeightModel.width;
    }
    if (kMinAspectRatio <= ratio && ratio <= kMaxAspectRatio) {
        height = ratio * kZYSmallShopMainShopCollectionViewCell_W;
    }else if (ratio  < kMinAspectRatio) {
        height = kMinAspectRatio * kZYSmallShopMainShopCollectionViewCell_W;
    }else {
        height = kMaxAspectRatio * kZYSmallShopMainShopCollectionViewCell_W;
    }
    if (model.activityType != 0) {
        
        return CGSizeMake(kZYSmallShopMainShopCollectionViewCell_W, 175 + height + self.labelHeight - 36);
    }else {
        
        return CGSizeMake(kZYSmallShopMainShopCollectionViewCell_W, 155 + height + self.labelHeight - 36);
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"商品:%ld", indexPath.row);
    
    ZYSmallShopGoodsDetailVc *vc = [[ZYSmallShopGoodsDetailVc alloc] init];
    ZYSmallShopMainValue3RecordsModel *model = self.dataArray[indexPath.row];
    vc.commodityId = model.ID;
    [self pushVc:vc];
}

#pragma mark - 处理点击事件
- (void)buyButtonClicked:(UIButton *)sender {
    NSLog(@"加入购物车%ld", sender.tag - 200);
    
    self.currentModel = self.dataArray[sender.tag - 200];
    [SVProgressHUD showLoadingCustomHUDWithStatus:@"加入中..."];
    [self initAddShoppingCartData];
}

@end
