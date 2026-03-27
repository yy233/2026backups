//
//  ZYChatUserInfoCenterCell.m
//  Community
//
//  Created by ZY on 2021/4/23.
//

#import "ZYChatUserInfoCenterCell.h"
#import "ZYChatUserInfoCenterCollectionViewCell.h"
#import "ZYChatUserInfoCenterAllCollectionViewCell.h"

static NSString * const chatUserInfoCenterCollectionViewCellID = @"ZYChatUserInfoCenterCollectionViewCell";
static NSString * const chatUserInfoCenterAllCollectionViewCellID = @"ZYChatUserInfoCenterAllCollectionViewCell";
#define kCollectionViewCellWidth (kScreenW - 88) / 4
#define kCollectionViewCellHeight ((kScreenW - 88) / 4) * 69 / 72

@interface ZYChatUserInfoCenterCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *iconImageArray;

@end

@implementation ZYChatUserInfoCenterCell
- (void)fillDataWithModel:(ChatUserModel *)model{
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setUI];
    [self customCollectionView];
}

- (void)setUI {
    
    self.collectionContentView.layer.shadowColor = Y_RGBA(31, 99, 255, 0.1).CGColor;
    self.collectionContentView.layer.shadowOffset = CGSizeMake(0, 3);
    self.collectionContentView.layer.shadowOpacity = 0.6;
    self.collectionContentView.layer.shadowRadius = 3.0;
    self.collectionContentView.clipsToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (NSMutableArray *)iconImageArray {
    if (!_iconImageArray) {
        _iconImageArray = [NSMutableArray arrayWithObjects:@"userinfo_dt1", @"userinfo_dt2", @"userinfo_dt3", nil];
    }
    
    return _iconImageArray;
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    
    // 设置collection横向滑动
    self.collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // 注册单元格
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZYChatUserInfoCenterCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:chatUserInfoCenterCollectionViewCellID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZYChatUserInfoCenterAllCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:chatUserInfoCenterAllCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.iconImageArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.iconImageArray.count > indexPath.row) {
        ZYChatUserInfoCenterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:chatUserInfoCenterCollectionViewCellID forIndexPath:indexPath];
        cell.iconImageView.image = [UIImage imageNamed:self.iconImageArray[indexPath.row]];
        
        return cell;
    }else {
        ZYChatUserInfoCenterAllCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:chatUserInfoCenterAllCollectionViewCellID forIndexPath:indexPath];
        
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(chatUserInfoCenterCollectionViewCellSelectItemAtIndexPath:)]) {
        
        [self.delegate chatUserInfoCenterCollectionViewCellSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kCollectionViewCellWidth, kCollectionViewCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// item 列间距(纵)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 12;
}

// item 行间距(横)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}

@end
