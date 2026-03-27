//
//  ZYSmallShopContainerRentDetailPriceCell.m
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import "ZYSmallShopContainerRentDetailPriceCell.h"
#import "ZYSmallShopContainerRentDetailPriceCollectionViewCell.h"

static NSString * const ZYSmallShopContainerRentDetailPriceCollectionViewCellID = @"ZYSmallShopContainerRentDetailPriceCollectionViewCell";
#define kZYSmallShopContainerRentDetailPriceCellCollectionViewCell_W (kScreenW-57)/4.0
#define kZYSmallShopContainerRentDetailPriceCellCollectionViewCell_H (kScreenW-57)/4.0*88.0/75.0

@interface ZYSmallShopContainerRentDetailPriceCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ZYSmallShopContainerRentDetailPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionViewHeightConstraint.constant = 16 + kZYSmallShopContainerRentDetailPriceCellCollectionViewCell_H;
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
    self.remarkLabel.text = _model.detail;
    self.dataArray = _model.cabinetPriceDtos;
    [self.collectionView reloadData];
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:ZYSmallShopContainerRentDetailPriceCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:ZYSmallShopContainerRentDetailPriceCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZYSmallShopContainerRentDetailPriceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYSmallShopContainerRentDetailPriceCollectionViewCellID forIndexPath:indexPath];
    if (indexPath.row == self.dataArray.count - 1) {
        cell.lineView.hidden = YES;
    }else {
        cell.lineView.hidden = NO;
    }
    ZYSmallShopContainerRentDetailCabinetModel *model = self.dataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kZYSmallShopContainerRentDetailPriceCellCollectionViewCell_W, kZYSmallShopContainerRentDetailPriceCellCollectionViewCell_H);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

@end
