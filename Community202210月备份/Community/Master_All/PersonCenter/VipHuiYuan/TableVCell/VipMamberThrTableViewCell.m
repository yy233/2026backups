//
//  VipMamberThrTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "VipMamberThrTableViewCell.h"

#import "VipCellSubThrCollectionViewCell.h"
#define  VipCellSubThrCollectionViewCell_Identifier                                 @"VipCellSubThrCollectionViewCell"

 
 
//subcell
#define CollectionV_ALL_W                   (Screen_W-32)
#define CollectionV_Cell_W                  ((CollectionV_ALL_W-40)/3)

@implementation VipMamberThrTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return 3;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    VipCellSubThrCollectionViewCell *cell = (VipCellSubThrCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:VipCellSubThrCollectionViewCell_Identifier  forIndexPath:indexPath];
    cell.centerL.text = @"无门槛";
    cell.titleL.text = @"¥7";
    cell.bottomL.text = @"售价¥5起";
//    cell.imgV.image = [UIImage imageNamed:@"Members_Dosingpackage_bottom"];
//    cell.backV.backgroundColor = Y_RGBA(255, 242, 212, 1);
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize  size =  CGSizeMake(CollectionV_Cell_W, 95);
    return size;
}
#pragma mark -------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseTouchUpCollectionCellSection:andIndex:withSelfTableViewCellType:)]) {
        [self.delegate baseTouchUpCollectionCellSection:indexPath.section andIndex:indexPath.item withSelfTableViewCellType:VipMamberTableViewCell_Type_Thr];
    }
}
#pragma mark -------------
@end
