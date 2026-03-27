//
//  ZYReportAboutRepairApplyTextCell.m
//  Community
//
//  Created by ZY on 2022/3/7.
//

#import "ZYReportAboutRepairApplyTextCell.h"
#import "ZYReportAboutRepairApplyTextCollectionViewCell.h"
#import "UITextView+YLTextView.h"

static NSString * const ZYReportAboutRepairApplyTextCollectionViewCellID = @"ZYReportAboutRepairApplyTextCollectionViewCell";

@interface ZYReportAboutRepairApplyTextCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imageDataArray;

@end

@implementation ZYReportAboutRepairApplyTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentV.backgroundColor = [ZYThemeManager shareManager].contentViewBackgroundThemeColor;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    self.textView.backgroundColor = [ZYThemeManager shareManager].viewBackgroundThemeColor_Lf0f1f6;
    self.textView.textColor = [ZYThemeManager shareManager].titleThemeColor;
    self.textView.limitLength = @150;
    self.textView.placeholder = @"请简短描述问题";
    self.textView.placeholdColor = [ZYThemeManager shareManager].placeholderThemeColor;
    self.textView.placeholdFont = [UIFont systemFontOfSize:14];
    self.textView.wordCountLabel.textColor = [UIColor clearColor];
    
    [self customCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 设置数据
- (void)setImagesArray:(NSArray *)imagesArray {
    _imagesArray = imagesArray;
    
    self.textView.placeholder = @"请简短描述问题";
    if (self.imageDataArray.count > 0) {
        [self.imageDataArray removeAllObjects];
    }
    [self.imageDataArray addObjectsFromArray:_imagesArray];
    [self.imageDataArray addObject:@"add"];
    [self.collectionView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray *)imageDataArray {
    if (!_imageDataArray) {
        _imageDataArray = [NSMutableArray array];
    }
    
    return _imageDataArray;
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerNib:[UINib nibWithNibName:ZYReportAboutRepairApplyTextCollectionViewCellID bundle:nil] forCellWithReuseIdentifier:ZYReportAboutRepairApplyTextCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imageDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYReportAboutRepairApplyTextCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ZYReportAboutRepairApplyTextCollectionViewCellID forIndexPath:indexPath];
    if ([self.imageDataArray.lastObject isEqual:@"add"] && indexPath.row == self.imageDataArray.count - 1) {
        cell.addView.hidden = NO;
        cell.editView.hidden = YES;
        [cell.addView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addViewTap)]];
    }else {
        cell.addView.hidden = YES;
        cell.editView.hidden = NO;
        NSString *urlStr = [[self.imageDataArray[indexPath.row] componentsSeparatedByString:@";"] firstObject];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"yl_placeholder_picture"]];
        cell.editView.tag = 200 + indexPath.row;
        [cell.editView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentImgViewTap:)]];
        cell.deleteButton.tag = 300 + indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kZYReportAboutRepairApplyTextCollectionViewCell_W, kZYReportAboutRepairApplyTextCollectionViewCell_H);
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

@end
