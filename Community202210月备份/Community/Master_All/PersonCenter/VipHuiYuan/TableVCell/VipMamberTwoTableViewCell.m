//
//  VipMamberTwoTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "VipMamberTwoTableViewCell.h"
#import "VipCellSubTwoCollectionViewCell.h"
#define  VipCellSubTwoCollectionViewCell_Identifier                                 @"VipCellSubTwoCollectionViewCell"

 
 
//subcell
#define CollectionV_ALL_W                   (Screen_W-32)
#define CollectionV_Cell_W                  ((CollectionV_ALL_W-40)/3)
@implementation VipMamberTwoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        return 7;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    VipCellSubTwoCollectionViewCell *cell = (VipCellSubTwoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:VipCellSubTwoCollectionViewCell_Identifier  forIndexPath:indexPath];
    cell.centerL.text = @"¥7";
    cell.titleL.text = @"乡村基";
    cell.bottomL.text = @"无门槛";
    cell.imgV.image = [UIImage imageNamed:@"Members_logo"];
    cell.backV.backgroundColor = Y_RGBA(255, 242, 212, 1);
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize  size =  CGSizeMake(CollectionV_Cell_W, 150);
    return size;
}
#pragma mark -------------
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{ 
    if (self.delegate && [self.delegate respondsToSelector:@selector(baseTouchUpCollectionCellSection:andIndex:withSelfTableViewCellType:)]) {
        [self.delegate baseTouchUpCollectionCellSection:indexPath.section andIndex:indexPath.item withSelfTableViewCellType:VipMamberTableViewCell_Type_Two];
    }
}
#pragma mark -------------

@end
