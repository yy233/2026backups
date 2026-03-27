//
//  ZYSmallShopGoodsDetailInfoImageCell.m
//  Community
//
//  Created by ZY on 2022/3/30.
//

#import "ZYSmallShopGoodsDetailInfoImageCell.h"
#import "ZYSmallShopGoodsDetailInfoImageCollectionViewCell.h"

static NSString * const ZYSmallShopGoodsDetailInfoImageCollectionViewCellID = @"ZYSmallShopGoodsDetailInfoImageCollectionViewCell";
#define kZYSmallShopGoodsDetailInfoImageCollectionViewCell_W (kScreenW-46)

@interface ZYSmallShopGoodsDetailInfoImageCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) CGFloat oldHeight;

@end

@implementation ZYSmallShopGoodsDetailInfoImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self customCollectionView];
    
    // kvo监听
    [self.collectionView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 移除监听
- (void)dealloc {
    [self.collectionView removeObserver:self forKeyPath:@"contentSize"];
}

// 设置数据
- (void)setImagesArray:(NSArray *)imagesArray {
    _imagesArray = imagesArray;
    
    [self.collectionView reloadData];
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:ZYSmallShopGoodsDetailInfoImageCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:ZYSmallShopGoodsDetailInfoImageCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imagesArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYSmallShopGoodsDetailInfoImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYSmallShopGoodsDetailInfoImageCollectionViewCellID forIndexPath:indexPath];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"cc_placeholder_big_banner"]];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYImageWidthHeightModel *imageWidthHeightModel = [ZYSmallShopImageUrlSegmentationTool imageUrlSegmentationWithUrlStr:self.imagesArray[indexPath.row]];
    CGFloat height;
    CGFloat ratio;
    if (imageWidthHeightModel.width == 0) {
        ratio = 0;
    }else {
        ratio = imageWidthHeightModel.height / imageWidthHeightModel.width;
    }
    height = ratio * kZYSmallShopGoodsDetailInfoImageCollectionViewCell_W;
    
    return CGSizeMake(kZYSmallShopGoodsDetailInfoImageCollectionViewCell_W, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

#pragma mark - kvo监听collectionView的高度变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentSize"]) {
        CGFloat height = self.collectionView.contentSize.height;
        if (self.oldHeight != height) {
            self.oldHeight = height;
            // 发送通知
            Y_NSNotificationCenter_PostNotice_HaveObject_Name(@"DETAIL_INFO_IMAGE_COMPLETE_BACK", @(height));
        }
    }
}

@end
