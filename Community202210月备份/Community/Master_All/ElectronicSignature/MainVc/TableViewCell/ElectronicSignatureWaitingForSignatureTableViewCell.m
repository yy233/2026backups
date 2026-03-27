//
//  ElectronicSignatureWaitingForSignatureTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/25.
//

#import "ElectronicSignatureWaitingForSignatureTableViewCell.h"
#import "ElectronicSignatureNomalImgAndTextCollectionViewCell.h"
#define ElectronicSignatureNomalImgAndTextCollectionViewCell_Identifier @"ElectronicSignatureNomalImgAndTextCollectionViewCell"

@interface ElectronicSignatureWaitingForSignatureTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UICollectionView *collectionView;
//
@property (nonatomic,strong) NSMutableArray *titleArr;
@property (nonatomic,strong) NSMutableArray *imgNameArr;

@end
@implementation ElectronicSignatureWaitingForSignatureTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showCellWithData{
    self.titleArr = [[NSMutableArray alloc]initWithObjects:@"合同管理", @"在线签约", @"草稿箱", nil];
    self.imgNameArr = [[NSMutableArray alloc]initWithObjects:@"htgl", @"qianhetong-", @"caogaoxiang", nil];
    [self.collectionView reloadData];
}
#pragma mark==
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_delegate && [_delegate respondsToSelector:@selector(waitingForSignatureCellTouchUpItemWithIndex:)]){
        [_delegate waitingForSignatureCellTouchUpItemWithIndex:indexPath.item];
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
    if (indexPath.item <= self.titleArr.count-1) {
        cell.titleL.text = self.titleArr[indexPath.row];
        cell.imgV.image = [UIImage imageNamed:self.imgNameArr[indexPath.row]];
        [self changeBackViewColor:indexPath.item withThisCell:cell];
    }
     return cell;
}
- (void)changeBackViewColor:(NSInteger)index
               withThisCell:(ElectronicSignatureNomalImgAndTextCollectionViewCell *)cell{
    CGSize size = CGSizeMake((kScreenW - 60 - 32) / 3, (kScreenW - 60 - 32) / 3 * (112.0 / 94.0));
    switch (index%3) {
        case 0:
        {
            UIColor *beginColor = Y_RGBA(37, 88, 255, 1);
            UIColor *endColor = Y_RGBA(61, 142, 252, 1);
            cell.backV.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:endColor];
        }
            break;
        case 1:
        {
            UIColor *beginColor = Y_RGBA(255, 73, 73, 1);
            UIColor *endColor = Y_RGBA(255, 118, 117, 1);
            cell.backV.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:endColor];
        }
            break;
        case 2:
        {
            UIColor *beginColor = Y_RGBA(0, 159, 98, 1);
            UIColor *endColor = Y_RGBA(36, 187, 129, 1);
            cell.backV.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:endColor];
        }
            break;
        default:
            break;
    }
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
        flowLayout.itemSize = CGSizeMake((kScreenW - 60 - 32) / 3, (kScreenW - 60 - 32) / 3 * (112.0 / 94.0));
        flowLayout.minimumInteritemSpacing = 20;
        flowLayout.minimumLineSpacing = 20;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);//top0
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, (kScreenW - 60 - 32) / 3 * (112.0 / 94.0) + 10) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[ElectronicSignatureNomalImgAndTextCollectionViewCell class] forCellWithReuseIdentifier: ElectronicSignatureNomalImgAndTextCollectionViewCell_Identifier];
    }
    return _collectionView;
}


@end
