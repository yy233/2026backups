//
//  ZYEventRemindTopView.m
//  Community
//
//  Created by ZY on 2021/11/10.
//

#import "ZYEventRemindTopView.h"
#import "ZYEventRemindTopCollectionViewCell.h"

static NSString * const eventRemindTopCollectionViewCellID = @"ZYEventRemindTopCollectionViewCell";
#define kEventRemindTopCollectionViewCell_W 45
#define kEventRemindTopCollectionViewCell_H 65

@interface ZYEventRemindTopView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, assign) BOOL isMark;

@end

@implementation ZYEventRemindTopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addShadow];
    [self customCollectionView];
}

// 给视图添加阴影
- (void)addShadow{
    self.layer.shadowColor = Y_RGBA(240, 241, 246, 0.9).CGColor;
    self.layer.shadowOffset = CGSizeMake(2,6);
    self.layer.shadowOpacity = 1;//阴影
}

// 设置数据
- (void)setDataArray:(NSArray<ZYEventRemindTopModel *> *)dataArray {
    _dataArray = dataArray;
    
    [self.collectionView reloadData];
    [self collectionViewSetContentOffset];
}

// 设置collectionView的偏移量
- (void)collectionViewSetContentOffset {
    if (!self.isMark) {
        self.isMark = YES;
        for (ZYEventRemindTopModel *tempModel in _dataArray) {
            if (tempModel.isSelected) {
                [self.collectionView layoutIfNeeded];
                CGPoint point;
                if ([tempModel.day integerValue] - 2 >= 0) {
                    if (self.collectionView.contentSize.width - kScreenW >= ([tempModel.day integerValue] - 2) * 53 + 8) {
                        point = CGPointMake(([tempModel.day integerValue] - 2) * 53 + 8, 0);
                    }else {
                        point = CGPointMake(self.collectionView.contentSize.width - kScreenW, 0);
                    }
                }else {
                    point = CGPointZero;
                }
                [self.collectionView setContentOffset:point];
            }
        }
    }
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:eventRemindTopCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:eventRemindTopCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYEventRemindTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:eventRemindTopCollectionViewCellID forIndexPath:indexPath];
    ZYEventRemindTopModel *model = self.dataArray[indexPath.row];
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
    
    return CGSizeMake(kEventRemindTopCollectionViewCell_W, kEventRemindTopCollectionViewCell_H);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 16, 0, 16);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 8;
}

@end
