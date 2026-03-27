//
//  ZYPensionMainFunctionCell.m
//  Community
//
//  Created by ZY on 2021/11/5.
//

#import "ZYPensionMainFunctionCell.h"
#import "ZYPensionMainFunctionCollectionViewCell.h"

static NSString * const pensionMainFunctionCollectionViewCellID = @"ZYPensionMainFunctionCollectionViewCell";

@interface ZYPensionMainFunctionCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *backgroundColorArray;

@property (nonatomic, strong) NSArray *iconImageNameArray;

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation ZYPensionMainFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self customCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (NSMutableArray *)backgroundColorArray {
    if (!_backgroundColorArray) {
        _backgroundColorArray = [NSMutableArray array];
        CGSize size = CGSizeMake(kFunctionCollectionViewCell_W, kFunctionCollectionViewCell_H);
        NSArray *startColorArray = @[Y_RGBA(254, 203, 1, 1), Y_RGBA(255, 136, 136, 1), Y_RGBA(255, 177, 143, 1), Y_RGBA(53, 231, 231, 1), Y_RGBA(74, 238, 201, 1), Y_RGBA(96, 190, 255, 1)];
        NSArray *endColorArray = @[Y_RGBA(255, 156, 2, 1), Y_RGBA(250, 96, 97, 1), Y_RGBA(255, 118, 58, 1), Y_RGBA(7, 193, 193, 1), Y_RGBA(16, 199, 159, 1), Y_RGBA(62, 151, 251, 1)];
        for (int i = 0; i < startColorArray.count; i++) {
            UIColor *color = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionLevel startColor:startColorArray[i] endColor:endColorArray[i]];
            [_backgroundColorArray addObject:color];
        }
    }
    
    return _backgroundColorArray;
}

- (NSArray *)iconImageNameArray {
    if (!_iconImageNameArray) {
        _iconImageNameArray = @[@"yl_drug", @"yl_sos", @"yl_health", @"yl_product_icon", @"yl_activity", @"yl_family_icon"];
    }
    
    return _iconImageNameArray;
}

- (NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"事件提醒", @"SOS", @"医疗服务", @"推荐产品", @"老年活动", @"家人档案"];
    }
    
    return _titleArray;
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZYPensionMainFunctionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:pensionMainFunctionCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.backgroundColorArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYPensionMainFunctionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:pensionMainFunctionCollectionViewCellID forIndexPath:indexPath];
    cell.contentV.backgroundColor = self.backgroundColorArray[indexPath.row];
    cell.iconImageView.image = [UIImage imageNamed:self.iconImageNameArray[indexPath.row]];
    cell.titleLabel.text = self.titleArray[indexPath.row];
    
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
    
    return CGSizeMake(kFunctionCollectionViewCell_W, kFunctionCollectionViewCell_H);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(10, 16, 10, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 8;
}

@end
