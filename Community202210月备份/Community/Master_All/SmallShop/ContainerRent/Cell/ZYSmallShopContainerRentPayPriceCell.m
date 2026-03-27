//
//  ZYSmallShopContainerRentPayPriceCell.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopContainerRentPayPriceCell.h"
#import "ZYSmallShopContainerRentPayPriceCollectionViewCell.h"

static NSString * const ZYSmallShopContainerRentPayPriceCollectionViewCellID = @"ZYSmallShopContainerRentPayPriceCollectionViewCell";

@interface ZYSmallShopContainerRentPayPriceCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ZYSmallShopContainerRentPayPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self customCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据model
- (void)setModel:(ZYSmallShopContainerRentDetailModel *)model {
    _model = model;
    
    self.nameLabel.text = _model.title;
    self.dataArray = _model.cabinetPriceDtos;
    [self.collectionView reloadData];
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:ZYSmallShopContainerRentPayPriceCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:ZYSmallShopContainerRentPayPriceCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYSmallShopContainerRentPayPriceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYSmallShopContainerRentPayPriceCollectionViewCellID forIndexPath:indexPath];
    ZYSmallShopContainerRentDetailCabinetModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionViewSelectItemAtIndexPath:)]) {
        [self.delegate collectionViewSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kZYSmallShopContainerRentPayPriceCollectionViewCell_W, kZYSmallShopContainerRentPayPriceCollectionViewCell_H);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

@end

