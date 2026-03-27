//
//  MainCenterCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2020/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainCenterCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) MainCenterCollectionViewCellModel *model;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
