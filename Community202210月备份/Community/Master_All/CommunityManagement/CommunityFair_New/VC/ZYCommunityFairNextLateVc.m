//
//  ZYCommunityFairNextLateVc.m
//  Community
//
//  Created by ZY on 2022/6/6.
//

#import "ZYCommunityFairNextLateVc.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "ZYCommunityFairLateCollectionViewCell.h"

static NSString * const ZYCommunityFairLateCollectionViewCellID = @"ZYCommunityFairLateCollectionViewCell";
#define kZYCommunityFairLateTopViewHeight (70+status_height+120.0/343*(kScreenW-32))
#define kZYCommunityFairLateCollectionViewCell_w (kScreenW-46)/2.0
#define kZYCommunityFairLateCollectionViewCell_H 320

@interface ZYCommunityFairNextLateVc () <UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation ZYCommunityFairNextLateVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加返回手势
    self.transitioningDelegate = self;
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgePan];
    
    self.view.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    [self setUI];
    [self customCollectionView];
    [self initData];
}

- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan {
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].windows.lastObject].x / [UIApplication sharedApplication].windows.lastObject.bounds.size.width);
    if ((edgePan.edges == UIRectEdgeLeft) && (progress > 0.1)) {
        Y_NSNotificationCenter_PostNotice_NilObject_Name(@"ZY_CUSTOM_POP_BACK")
    }
}

#pragma mark - 布局视图
- (void)setUI {
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_collectionView.superview);
        make.height.offset(kScreenH - kZYCommunityFairLateTopViewHeight - 40);
    }];
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
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
    [self.dataArray addObjectsFromArray:@[@"", @"", @"", @"", @"", @"", @"", @"", @"", @""]];
    [self.collectionView reloadData];
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:ZYCommunityFairLateCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:ZYCommunityFairLateCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYCommunityFairLateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYCommunityFairLateCollectionViewCellID forIndexPath:indexPath];
    
    return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kZYCommunityFairLateCollectionViewCell_w, kZYCommunityFairLateCollectionViewCell_H);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"商品:%ld", indexPath.row);
}

@end
