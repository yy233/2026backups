//
//  ZYUploadFaceView.m
//  Community
//
//  Created by ZY on 2021/8/10.
//

#import "ZYUploadFaceView.h"
#import "ZYUploadFaceCollectionViewCell.h"

static NSString * const uploadFaceCollectionViewCellID = @"ZYUploadFaceCollectionViewCell";
#define kTopViewHeight 38
#define kZYUploadFaceCollectionViewCell_W (kScreenW - 32 - 20) / 3.0

@interface ZYUploadFaceView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *imgArray;

@end

@implementation ZYUploadFaceView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.topViewHeightConstraint.constant = 0;
    self.collectionViewHeightConstraint.constant = kZYUploadFaceCollectionViewCell_W;
    self.titleLabel.textColor = [ZYThemeManager shareManager].titleThemeColor;
    
    [self customCollectionView];
}

// 设置数据
- (void)setImagesArray:(NSArray *)imagesArray {
    _imagesArray = imagesArray;
    
    if (self.imgArray.count > 0) {
        [self.imgArray removeAllObjects];
    }
    [self.imgArray addObjectsFromArray:_imagesArray];
    if ([self.typeStr isEqual:@"add"]) {
        if (self.imgArray.count < 3) {
            [self.imgArray addObject:@"add"];
        }
    }
    [self.collectionView reloadData];
}

- (void)setStatus:(NSInteger)status {
    _status = status;
    
    if (_status == 2) {
        self.topView.hidden = NO;
        self.topViewHeightConstraint.constant = kTopViewHeight;
    }else {
        self.topView.hidden = YES;
        self.topViewHeightConstraint.constant = 0;
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
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZYUploadFaceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:uploadFaceCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imgArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYUploadFaceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:uploadFaceCollectionViewCellID forIndexPath:indexPath];
    if ([self.imgArray.lastObject isEqual:@"add"] && indexPath.row == self.imgArray.count - 1) {
        cell.addView.hidden = NO;
        cell.editView.hidden = YES;
        [cell.addView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addViewTap)]];
    }else {
        cell.addView.hidden = YES;
        cell.editView.hidden = NO;
        [cell.iconImageView sd_setImageWithURL:self.imgArray[indexPath.row]];
        cell.editView.tag = 200 + indexPath.row;
        [cell.editView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentImgViewTap:)]];
        cell.deleteButton.tag = 300 + indexPath.row;
        [cell.deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.status == 0) {
            cell.statusView.backgroundColor = [UIColor zy_colorWithHexString:@"#000000" andAlpha:0.65];
            cell.statusLabel.text = @"同步中";
        }else if (self.status == 1) {
            cell.statusView.backgroundColor = [UIColor zy_colorWithHexString:@"#0B9639" andAlpha:0.65];
            cell.statusLabel.text = @"成功";
        }else if (self.status == 2) {
            cell.statusView.backgroundColor = [UIColor zy_colorWithHexString:@"#E81919" andAlpha:0.65];
            cell.statusLabel.text = @"失败";
        }
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
    
    return CGSizeMake(kZYUploadFaceCollectionViewCell_W, kZYUploadFaceCollectionViewCell_W);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

@end
