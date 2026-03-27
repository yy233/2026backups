//
//  BaseImgAndLabelCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2022/2/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const BaseImgAndLabelCollectionViewCell_I = @"BaseImgAndLabelCollectionViewCell";

@interface BaseImgAndLabelCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *titleLabel;
@end

NS_ASSUME_NONNULL_END
