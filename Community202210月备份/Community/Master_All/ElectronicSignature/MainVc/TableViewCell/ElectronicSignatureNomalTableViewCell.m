//
//  ElectronicSignatureNomalTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import "ElectronicSignatureNomalInfoItemsTableViewCell.h"


@interface ElectronicSignatureNomalInfoItemsTableViewCell ()  <UICollectionViewDelegate,UICollectionViewDataSource>

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
- (void)showCellWithType:(ElectronicSignatureVC_Cell_Type)type{
    switch (type) {
        case ElectronicSignatureVC_Cell_Type_Top:
            
            break;
            
        default:
            break;
    }
}
#pragma mark==
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [[UICollectionViewCell alloc]init];
    return cell;
}
#pragma mark==

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
        flowLayout.itemSize = CGSizeMake((Screen_W-32-50)/3, 100);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);//top0
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 110) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ElectronicSignatureNomalImgAndTextCellView class] forCellWithReuseIdentifier: ElectronicSignatureNomalImgAndTextCellView_Identifier];
    }
    return _collectionView;
}
- (void)reCollectionViewGetWithV:(UICollectionView *)collectionView withFlowLayout:(UICollectionViewFlowLayout *)flowLayout{
}
@end
