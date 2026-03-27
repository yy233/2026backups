//
//  ZYSmallShopMainShopCell.m
//  Community
//
//  Created by ZY on 2022/2/28.
//

#import "ZYSmallShopMainShopCell.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "ZYSmallShopMainShopCollectionViewCell.h"
#import "ZYSmallShopServiceCollectionViewCell.h"

static NSString * const ZYSmallShopMainShopCollectionViewCellID = @"ZYSmallShopMainShopCollectionViewCell";
static NSString * const ZYSmallShopServiceCollectionViewCellID = @"ZYSmallShopServiceCollectionViewCell";

@interface ZYSmallShopMainShopCell () <UICollectionViewDataSource, UICollectionViewDelegate, CHTCollectionViewDelegateWaterfallLayout>

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (nonatomic, assign) CGFloat oldHeight;

@property (nonatomic, assign) CGFloat labelHeight;

@end

@implementation ZYSmallShopMainShopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.contentV addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview);
    }];
    [self customCollectionView];
    
    // kvo监听
    [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

// 移除监听
- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
}

#pragma mark - 懒加载
- (UICollectionView *)collectionView {
  if (!_collectionView) {
      CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
      layout.sectionInset = UIEdgeInsetsMake(5, 16, 0, 16);
      layout.minimumColumnSpacing = 13;
      layout.minimumInteritemSpacing = 13;
      layout.columnCount  = 2;
      layout.itemRenderDirection = CHTCollectionViewWaterfallLayoutItemRenderDirectionShortestFirst;
      _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
      _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      _collectionView.backgroundColor = [UIColor clearColor];
      _collectionView.scrollEnabled = NO;
  }
    
  return _collectionView;
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:ZYSmallShopMainShopCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:ZYSmallShopMainShopCollectionViewCellID];
    [self.collectionView registerNib:[UINib nibWithNibName:ZYSmallShopServiceCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:ZYSmallShopServiceCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYSmallShopMainValue3RecordsModel *model = self.dataArray[indexPath.row];
    if (model.type == 1) {
        ZYSmallShopMainShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYSmallShopMainShopCollectionViewCellID forIndexPath:indexPath];
        cell.buyView.hidden = YES;
        cell.buyViewHeightConstraint.constant = 0;
        cell.model = self.dataArray[indexPath.row];
        
        return cell;
    }else if (model.type == 2) {
        ZYSmallShopServiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYSmallShopServiceCollectionViewCellID forIndexPath:indexPath];
        cell.buyView.hidden = YES;
        cell.buyViewHeightConstraint.constant = 0;
        cell.model = self.dataArray[indexPath.row];
        
        return cell;
    }
    
    return nil;
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
    if (model.type == 1) {
        if (model.activityType != 0) {
            
            return CGSizeMake(kZYSmallShopMainShopCollectionViewCell_W, 145 + height + self.labelHeight - 36);
        }else {
            
            return CGSizeMake(kZYSmallShopMainShopCollectionViewCell_W, 125 + height + self.labelHeight - 36);
        }
    }else if (model.type == 2) {
        
        return CGSizeMake(kZYSmallShopMainShopCollectionViewCell_W, 100 + height + self.labelHeight - 36);
    }
    
    return CGSizeZero;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewSelectItemAtIndexPath:)]) {
        [self.delegate collectionViewSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - kvo监听collectionView的高度变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat height = self.collectionView.contentSize.height;
        if (self.oldHeight != height) {
            self.oldHeight = height;
            // 发送通知
            Y_NSNotificationCenter_PostNotice_HaveObject_Name(@"WATER_FALL_LAYOUT_COMPLETE_BACK", @(height));
        }
    }
}

@end
