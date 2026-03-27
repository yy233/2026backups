//
//  VipMamberOneTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "VipMamberOneTableViewCell.h"
#import "VipHeaderViewSubOneCollectionViewCell.h" //同样结构 背景色改掉即可
#define  VipHeaderViewSubOneCollectionViewCell_Identifier                           @"VipHeaderViewSubOneCollectionViewCell"
#import "VipCellSubTwoCollectionViewCell.h"
#define  VipCellSubTwoCollectionViewCell_Identifier                                 @"VipCellSubTwoCollectionViewCell"
#import "VipCellSubThrCollectionViewCell.h"
#define  VipCellSubThrCollectionViewCell_Identifier                                 @"VipCellSubThrCollectionViewCell"
#import "VipCellSubFourCollectionViewCell.h"
#define VipCellSubFourCollectionViewCell_Identifier                                 @"VipCellSubFourCollectionViewCell"



//
#define All_Height   362
//subcell
#define CollectionV_ALL_W                   (Screen_W-32)
#define CollectionV_OneSection_W            ((CollectionV_ALL_W-50)/4)
#define CollectionV_TwoSection_W            ((CollectionV_ALL_W-40)/3)

@interface VipMamberOneTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@end
@implementation VipMamberOneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backView.layer.masksToBounds = YES;
        [self.backView addSubview:self.tipL];
        [self.backView addSubview:self.titleL];
        [self.backView addSubview:self.collectionView];
        [self setUI];
        self.backView.backgroundColor = [UIColor whiteColor];
        self.backView.layer.cornerRadius = 10;
    }
    return self;
}
- (void)setUI{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_collectionView.superview).insets(UIEdgeInsetsMake(40, 0, 0, 0));
    }];
    [_tipL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_tipL.superview).offset(10);
        make.width.offset(40);
        make.height.offset(20);
    }];
    [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_tipL.mas_right).offset(10);
        make.centerY.height.equalTo(_tipL);
        make.right.equalTo(_titleL.superview);
    }];
    
}
#pragma mark ==
 
- (UILabel *)tipL{
    if (!_tipL) {
        _tipL = [[UILabel alloc]init];
        _tipL.layer.cornerRadius = 5;
        _tipL.layer.masksToBounds = YES;
        _tipL.textAlignment = NSTextAlignmentCenter;
        _tipL.font = FontSize_MoneyWallet_Bold(13);
        _tipL.text = @"特权";
        _tipL.textColor = Y_RGBA(114, 56, 0, 1);
        UIColor *beginColor = Y_RGBA(255, 235, 173, 1);
        UIColor *endColor = Y_RGBA(255, 210, 108, 1);
        CGSize size = CGSizeMake(40, 20);
        _tipL.backgroundColor = [UIColor y_colorGradientChangeWithSize:size direction:IHGradientChangeDirectionVertical startColor:beginColor endColor:endColor];
    }
    return _tipL;
}
- (UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.font = FontSize_Vip_Bold(14);
    }
    return _titleL;
}

#pragma mark ==
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.itemSize = CGSizeMake((Screen_W-32-50)/3, 110);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;//UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
//        flowLayout.headerReferenceSize = CGSizeMake(Screen_W-32, 1);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CollectionV_ALL_W, 10) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[VipHeaderViewSubOneCollectionViewCell class] forCellWithReuseIdentifier: VipHeaderViewSubOneCollectionViewCell_Identifier];
        [_collectionView registerClass:[VipCellSubTwoCollectionViewCell class] forCellWithReuseIdentifier: VipCellSubTwoCollectionViewCell_Identifier];
        [_collectionView registerClass:[VipCellSubThrCollectionViewCell class] forCellWithReuseIdentifier: VipCellSubThrCollectionViewCell_Identifier];
        [_collectionView registerClass:[VipCellSubFourCollectionViewCell class] forCellWithReuseIdentifier: VipCellSubFourCollectionViewCell_Identifier];

    }
    return _collectionView;
}

#pragma mark -------------
#pragma mark==
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        DLog(@"红包 %ld",(long)indexPath.item);
    }else{
        DLog(@"特权 %ld",(long)indexPath.item);
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(baseTouchUpCollectionCellSection:andIndex:withSelfTableViewCellType:)]) {
        [_delegate baseTouchUpCollectionCellSection:indexPath.section andIndex:indexPath.item withSelfTableViewCellType:VipMamberTableViewCell_Type_One];
    }
}
#pragma mark==
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return 4;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    VipHeaderViewSubOneCollectionViewCell *cell = (VipHeaderViewSubOneCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:VipHeaderViewSubOneCollectionViewCell_Identifier  forIndexPath:indexPath];
    cell.centerL.text = @"¥5";
    cell.titleL.text = @"无门槛";
    cell.bottomL.text = @"专属红包";
    cell.backV.backgroundColor = Y_RGBA(255, 242, 212, 1);
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize  size =  CGSizeMake(CollectionV_OneSection_W, 87);
    return size;
}
@end
