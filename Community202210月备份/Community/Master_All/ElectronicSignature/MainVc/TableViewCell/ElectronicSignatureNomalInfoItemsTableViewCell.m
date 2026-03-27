//
//  ElectronicSignatureNomalInfoItemsTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import "ElectronicSignatureNomalInfoItemsTableViewCell.h"

#import "ElectronicSignatureNomalImgAndTextCollectionViewCell.h"
#define ElectronicSignatureNomalImgAndTextCollectionViewCell_Identifier                @"ElectronicSignatureNomalImgAndTextCollectionViewCell"

@interface ElectronicSignatureNomalInfoItemsTableViewCell ()  <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UICollectionView *collectionView;
//
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *imgNameArr;
@end

@implementation ElectronicSignatureNomalInfoItemsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showInfoItemsCellWithData{
    self.titleArr = [[NSMutableArray alloc]initWithObjects:@"我的资料", @"即将截止", @"合同模板", @"帮助反馈",nil];
    self.imgNameArr = [[NSMutableArray alloc]initWithObjects:@"mc", @"rt", @"ymzs",@"helpFk", nil];
    [self.collectionView reloadData];
}
#pragma mark==
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_delegate && [_delegate respondsToSelector:@selector(nomalInfoItemsCellTouchUpItemWithIndex:)]) {
        [_delegate nomalInfoItemsCellTouchUpItemWithIndex:indexPath.item];
    }
}
#pragma mark==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titleArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ElectronicSignatureNomalImgAndTextCollectionViewCell *cell = (ElectronicSignatureNomalImgAndTextCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:ElectronicSignatureNomalImgAndTextCollectionViewCell_Identifier  forIndexPath:indexPath];
    [cell setCellNewUIWithTitleAndImgHaveJianJu];
    cell.titleL.textColor = [ZYThemeManager shareManager].subTitleThemeColor;
    if (indexPath.item <= self.titleArr.count-1) {
        cell.titleL.text = self.titleArr[indexPath.row];
        cell.imgV.image = [UIImage imageNamed:self.imgNameArr[indexPath.row]];
    }
  
     return cell;
}
#pragma mark==

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self.titleArr = [[NSMutableArray alloc]init];
    self.imgNameArr = [[NSMutableArray alloc]init];
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.collectionView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_backView.superview);
        }];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_collectionView.superview).insets(UIEdgeInsetsMake(0, 16, 0, 16));
        }];
    }
    return self;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
    }
    return _backView;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake((Screen_W-50-32)/4, 100);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 110) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ElectronicSignatureNomalImgAndTextCollectionViewCell class] forCellWithReuseIdentifier: ElectronicSignatureNomalImgAndTextCollectionViewCell_Identifier];
    }
    return _collectionView;
}
 
@end
