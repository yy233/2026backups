//
//  HouseRepairEditCellSubTypeBtnCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2020/12/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRepairEditCellSubTypeBtnCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIView *isSelectedShowView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *rightBottomImg;
- (void)nowSelectedType:(BOOL)isSelectedType;
@end

NS_ASSUME_NONNULL_END
