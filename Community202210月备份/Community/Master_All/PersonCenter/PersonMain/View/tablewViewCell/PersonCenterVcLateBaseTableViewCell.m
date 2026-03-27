//
//  PersonCenterVcLateBaseTableViewCell.m
//  Community
//
//  Created by 余莹 on 2021/7/27.
//

#import "PersonCenterVcLateBaseTableViewCell.h"

#import "PersonCenterVcLateBaseCollectionViewCell.h"
#define  PersonCenterVcLateBaseCollectionViewCell_Identifier     @"PersonCenterVcLateBaseCollectionViewCell"
#import "PersonCenterUseShowModel.h"

@interface PersonCenterVcLateBaseTableViewCell () <UICollectionViewDelegate,UICollectionViewDataSource>

@end

@implementation PersonCenterVcLateBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)showInitWithTitleArr:(NSMutableArray *)dataSourceArr imgArr:(NSMutableArray *)imgNameDataSourceArr{
//    
//    
//}
//


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.collectionView registerClass:[PersonCenterVcLateBaseCollectionViewCell class] forCellWithReuseIdentifier:PersonCenterVcLateBaseCollectionViewCell_Identifier];
       
    }
    return self;
}
 
#pragma mark ===
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
 
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PersonCenterVcLateBaseCollectionViewCell *cell = (PersonCenterVcLateBaseCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:PersonCenterVcLateBaseCollectionViewCell_Identifier  forIndexPath:indexPath];
    PersonCenterUseShowModel *useShowModel = self.showUseModelArr[indexPath.row];
    cell.bottomTextLabel.text = useShowModel.titleStr;
    if ([ThemeManager shareManager].type == ThemeType_White) {
        cell.topImgV.image = [UIImage imageNamed:[TextShowWithModelStr textShowWithModelStr:useShowModel.imgNameStr_W]];
    }else{
        cell.topImgV.image = [UIImage imageNamed:[TextShowWithModelStr textShowWithModelStr:useShowModel.imgNameStr_D]];
        
    }
    return cell;

//    PersonCenterVcLateBaseCollectionViewCell *cell = (PersonCenterVcLateBaseCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:PersonCenterVcLateBaseCollectionViewCell_Identifier  forIndexPath:indexPath];
//        cell.bottomTextLabel.text = self.dataSourceArr[indexPath.row];
////        cell.bottomTextLabel.backgroundColor = [UIColor redColor];
//        if (indexPath.item <= self.imgNameDataSourceArr.count-1) {
//            NSString *imgNameStr = [NSString stringWithFormat:@"%@",self.imgNameDataSourceArr[indexPath.row]];
//            if (imgNameStr.length<=0) {
//                return cell;
//            }else{
//                cell.topImgV.image  = [UIImage imageNamed:self.imgNameDataSourceArr[indexPath.row]];
//            }
//        }
//        return cell;
}
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{//type=top的协议在子类重写s
//    if (self.selfSubCellType == PersoncenterSubCollectionviewCell_Type_MoreRrecommend) {
//        if (_nomalAndMoneyCellDelegate && [_nomalAndMoneyCellDelegate respondsToSelector:@selector(personVcNomalSubCollectionViewMoreRecommendCellTouchUpItemWithIndex:)]) {
//            [_nomalAndMoneyCellDelegate personVcNomalSubCollectionViewMoreRecommendCellTouchUpItemWithIndex:indexPath.row];
//        }
//    }
//}
#pragma mark ==
 
@end
