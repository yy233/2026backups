//
//  ZYContrectUnderSigningDetailEditAttachmentUploadCell.m
//  Community
//
//  Created by ZY on 2021/5/19.
//

#import "ZYContrectUnderSigningDetailEditAttachmentUploadCell.h"
#import "ZYContrectUnderSigningDetailEditAttachmentUploadCollectionViewCell.h"

static NSString * const contrectUnderSigningDetailEditAttachmentUploadCollectionViewCellID = @"ZYContrectUnderSigningDetailEditAttachmentUploadCollectionViewCell";
#define kContrectUnderSigningDetailEditAttachmentUploadCollectionViewCellWidth (kScreenW - 80) / 3
#define kContrectUnderSigningDetailEditAttachmentUploadCollectionViewCellHeight ((kScreenW - 80) / 3)

@interface ZYContrectUnderSigningDetailEditAttachmentUploadCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray<ZYSealImageDataModel *> *dataArray;

@end

@implementation ZYContrectUnderSigningDetailEditAttachmentUploadCell

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
- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    
//    if (self.dataArray.count > 0) {
//        [self.dataArray removeAllObjects];
//    }
//    [self.dataArray addObjectsFromArray:imageArray];
//    ZYSealImageDataModel *model = [[ZYSealImageDataModel alloc] init];
//    [self.dataArray addObject:model];
//    [self.collectionView reloadData];
    
    if (self.dataArray.count > 0) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:imageArray];
    if (self.dataArray.count == 0) {
        ZYSealImageDataModel *model = [[ZYSealImageDataModel alloc] init];
        [self.dataArray addObject:model];
    }
    [self.collectionView reloadData];
}

#pragma mark - 懒加载
- (NSMutableArray<ZYSealImageDataModel *> *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    
    // 设置collection纵向滑动
    self.collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    // 设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // 注册单元格
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZYContrectUnderSigningDetailEditAttachmentUploadCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:contrectUnderSigningDetailEditAttachmentUploadCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    ZYContrectUnderSigningDetailEditAttachmentUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:contrectUnderSigningDetailEditAttachmentUploadCollectionViewCellID forIndexPath:indexPath];
//    if (indexPath.row == (self.dataArray.count - 1)) {
//        cell.iconImageView.image = [UIImage imageNamed:@"ic_contrect_upload_add"];
//        cell.iconImageView.backgroundColor = [UIColor clearColor];
//        cell.deletetButton.hidden = YES;
//    }else {
//        ZYSealImageDataModel *model = self.dataArray[indexPath.row];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, model.url]];
//        [cell.iconImageView sd_setImageWithURL:url];
//        cell.iconImageView.backgroundColor = Y_RGBA(235, 235, 235, 1);
//        cell.deletetButton.hidden = NO;
//        cell.deletetButton.tag = 100 + indexPath.row;
//        [cell.deletetButton addTarget:self action:@selector(deletetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    ZYContrectUnderSigningDetailEditAttachmentUploadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:contrectUnderSigningDetailEditAttachmentUploadCollectionViewCellID forIndexPath:indexPath];
    ZYSealImageDataModel *model = self.dataArray[indexPath.row];
    if (!(model.url.length > 0)) {
        cell.iconImageView.image = [UIImage imageNamed:@"ic_contrect_upload_add"];
        cell.iconImageView.backgroundColor = [UIColor clearColor];
        cell.deletetButton.hidden = YES;
    }else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kElectronicSignatureImageBaseUrl, model.url]];
        [cell.iconImageView sd_setImageWithURL:url];
        cell.iconImageView.backgroundColor = Y_RGBA(235, 235, 235, 1);
        cell.deletetButton.hidden = NO;
        cell.deletetButton.tag = 100 + indexPath.row;
        [cell.deletetButton addTarget:self action:@selector(deletetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(contrectUnderSigningDetailEditAttachmentUploadCellSelectItemAtIndexPath:)]) {
        
        [self.delegate contrectUnderSigningDetailEditAttachmentUploadCellSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kContrectUnderSigningDetailEditAttachmentUploadCollectionViewCellWidth, kContrectUnderSigningDetailEditAttachmentUploadCollectionViewCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// item 列间距(纵)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 16;
}

// item 行间距(横)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

#pragma mark - 处理点击事件
- (void)deletetButtonClicked:(UIButton *)sender {
    
    NSInteger index = sender.tag - 100;
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteButtonSelectedIndex:)]) {
        
        [self.delegate deleteButtonSelectedIndex:index];
    }
}

@end
