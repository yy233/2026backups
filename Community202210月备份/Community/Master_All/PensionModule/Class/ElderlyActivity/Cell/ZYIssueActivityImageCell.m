//
//  ZYIssueActivityImageCell.m
//  Community
//
//  Created by ZY on 2021/11/15.
//

#import "ZYIssueActivityImageCell.h"
#import "ZYCommunityFairEditPhotoCollectionViewCell.h"

static NSString * const communityFairEditPhotoCollectionViewCellID = @"ZYCommunityFairEditPhotoCollectionViewCell";

@interface ZYIssueActivityImageCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imgArray;

@end

@implementation ZYIssueActivityImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self customCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据
- (void)setImagesArray:(NSArray *)imagesArray {
    _imagesArray = imagesArray;
    
    if (self.imgArray.count > 0) {
        [self.imgArray removeAllObjects];
    }
    [self.imgArray addObjectsFromArray:_imagesArray];
    if (self.imgArray.count < 3) {
        [self.imgArray addObject:@"add"];
    }
    [self.collectionView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray *)imgArray {
    if (!_imgArray) {
        _imgArray = [NSMutableArray array];
    }
    
    return _imgArray;
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZYCommunityFairEditPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:communityFairEditPhotoCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imgArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYCommunityFairEditPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:communityFairEditPhotoCollectionViewCellID forIndexPath:indexPath];
    if ([self.imgArray.lastObject isEqual:@"add"] && indexPath.row == self.imgArray.count - 1) {
        cell.addView.hidden = NO;
        cell.contentImgView.hidden = YES;
        [cell.addView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addViewTap)]];
    }else {
        cell.addView.hidden = YES;
        cell.contentImgView.hidden = NO;
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.imgArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"yl_placeholder_picture"]];
        cell.contentImgView.tag = 200 + indexPath.row;
        [cell.contentImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentImgViewTap:)]];
        cell.deleteButton.tag = 300 + indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

#pragma mark - 点击事件
- (void)addViewTap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addPhotos)]) {
        [self.delegate addPhotos];
    }
}

- (void)contentImgViewTap:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewTapWithIndex:)]) {
        [self.delegate imageViewTapWithIndex:tap.view.tag - 200];
    }
}

- (void)deleteButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deletePhotoWithIndex:)]) {
        [self.delegate deletePhotoWithIndex:sender.tag - 300];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kIssueActivityImageCell_W, kIssueActivityImageCell_H);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

@end
