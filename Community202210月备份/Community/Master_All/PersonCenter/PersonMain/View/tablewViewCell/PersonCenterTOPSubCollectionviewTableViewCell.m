//
//  PersonCenterTOPSubCollectionviewTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/1/18.
//

#import "PersonCenterTOPSubCollectionviewTableViewCell.h"
#define BackView_width           (Screen_W)
#define Cell_Width_TopCell       (BackView_width-60)/5
#define Cell_Height              60
@implementation PersonCenterTOPSubCollectionviewTableViewCell


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(Cell_Width_TopCell, Cell_Height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"TOPSubCollectionviewT didSelectItemAtIndexPath    %@",self.dataSourceArr[indexPath.row]);
    if (_topCellDelegate && [_topCellDelegate respondsToSelector:@selector(personVcTopSubCollectionViewTouchUpItemWithIndex:)]) {
        [_topCellDelegate personVcTopSubCollectionViewTouchUpItemWithIndex:indexPath.row];
    }
}
//重写

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selfSubCellType = PersoncenterSubCollectionviewCell_Type_TopCell;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(Cell_Width_TopCell, Cell_Height);
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
            flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, BackView_width) collectionViewLayout:flowLayout];
        [self upSetUI];
    }
    return self;
}
- (void)upSetUI{
    [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView.superview).insets(UIEdgeInsetsMake(5, 0, 5, 0));
    }];
}
@end
