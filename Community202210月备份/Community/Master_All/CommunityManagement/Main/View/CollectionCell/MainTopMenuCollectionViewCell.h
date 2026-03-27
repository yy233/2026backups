//
//  MainTopMenuCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2021/7/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainTopMenuCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) MainCenterCollectionViewCellModel *model;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
