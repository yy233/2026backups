//
//  VipMamberFourTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "VipMamberFourTableViewCell.h"
#import "VipCellSubFourCollectionViewCell.h"
#define  VipCellSubFourCollectionViewCell_Identifier                                 @"VipCellSubFourCollectionViewCell"
//subcell
#define CollectionV_ALL_W                   (Screen_W-32)
#define CollectionV_Cell_W                  ((CollectionV_ALL_W-30)/2)
@implementation VipMamberFourTableViewCell

#pragma mark ==
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        [self.backView addSubview:self.bottomTipL];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.backView).insets(UIEdgeInsetsMake(40, 0,30, 0));
        }];
        [_bottomTipL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_bottomTipL.superview);
            make.height.offset(30);
        }];
    }
    return self;
}
- (UILabel *)bottomTipL{
    if (!_bottomTipL) {
        _bottomTipL = [[UILabel alloc]init];
        _bottomTipL.font = FontSize_Vip_Nomail(12);
        _bottomTipL.textColor = Y_RGBA(153, 153, 153, 1);
        _bottomTipL.text = @"特价菜品及价格以商家店内实际上架为准";
        _bottomTipL.textAlignment = NSTextAlignmentCenter;
    }
    return _bottomTipL;
}

#pragma mark ==
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return 7;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    VipCellSubFourCollectionViewCell *cell = (VipCellSubFourCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:VipCellSubFourCollectionViewCell_Identifier  forIndexPath:indexPath];
    cell.centerL.text = @"¥19.7";
    cell.titleL.text = @"单人干锅鸡（不含米饭）" ;
//    cell.bottomL.text = @"¥49.9";
//    cell.imgV.image = [UIImage imageNamed:@"Members_Dosingpackage_bottom"];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle),
                                 NSBaselineOffsetAttributeName : @0};// @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleThick]};
     NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"¥49.9" attributes:attribtDic];
    cell.bottomL.attributedText = attribtStr;
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize  size =  CGSizeMake(CollectionV_Cell_W, 160);
    return size;
}
#pragma mark -------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseTouchUpCollectionCellSection:andIndex:withSelfTableViewCellType:)]) {
        [self.delegate baseTouchUpCollectionCellSection:indexPath.section andIndex:indexPath.item withSelfTableViewCellType:VipMamberTableViewCell_Type_Four];
    }
}
#pragma mark -------------
@end
