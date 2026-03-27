//
//  ZYCommunityFairEditPhotoCollectionViewCell.h
//  Community
//
//  Created by ZY on 2021/8/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairEditPhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *contentImgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIView *addView;

@end

NS_ASSUME_NONNULL_END
