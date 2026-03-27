//
//  ZYMessageTopCell.m
//  Community
//
//  Created by ZY on 2021/4/25.
//

#import "ZYMessageTopCell.h"
#import "ZYMessageTopCollectionViewCell.h"

static NSString * const messageTopCollectionViewCellID = @"ZYMessageTopCollectionViewCell";
#define kMessageTopCollectionViewCellWidth (kScreenW - 160) / 4
//#define kMessageTopCollectionViewCellHeight ((kScreenW - 160) / 4) * 90 / 60
#define kMessageTopCollectionViewCellHeight (((kScreenW - 160) / 4) * 90 / 60)+10

@interface ZYMessageTopCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *iconImageArray;

@property (nonatomic, strong) NSMutableArray *nameArray;

@property (nonatomic,strong) NSMutableArray *friendsInfoArr;

@end

@implementation ZYMessageTopCell

- (void)fillFriendsWithArr:(NSMutableArray *)arr{
    DLog(@"");
    self.friendsInfoArr = [NSMutableArray arrayWithArray:arr];
    [self.collectionView reloadData];
}

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
- (NSMutableArray *)friendsInfoArr{
    if (!_friendsInfoArr) {
        _friendsInfoArr = [[NSMutableArray alloc]init];
    }
    return _friendsInfoArr;
}
- (NSMutableArray *)iconImageArray {
    if (!_iconImageArray) {
        _iconImageArray = [[NSMutableArray  alloc]init];
    }
    
    return _iconImageArray;
}

- (NSMutableArray *)nameArray {
    if (!_nameArray) {
        _nameArray =  [[NSMutableArray  alloc]init];
    }
    
    return _nameArray;
}

#pragma mark - 定制collectionView
- (void)customCollectionView {
    
    // 设置collection横向滑动
    self.collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // 设置代理
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // 注册单元格
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZYMessageTopCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:messageTopCollectionViewCellID];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
//    return self.iconImageArray.count;
    return self.friendsInfoArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ZYMessageTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:messageTopCollectionViewCellID forIndexPath:indexPath];
//    cell.iconImageView.image = [UIImage imageNamed:self.iconImageArray[indexPath.row]];
//    cell.nameLabel.text = self.nameArray[indexPath.row];

    [cell fillData:self.friendsInfoArr[indexPath.row]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(messageTopCollectionViewCellSelectItemAtIndexPath:)]) {
        
        [self.delegate messageTopCollectionViewCellSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(kMessageTopCollectionViewCellWidth, kMessageTopCollectionViewCellHeight);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

// item 列间距(纵)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 32;
}

// item 行间距(横)
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}


@end
