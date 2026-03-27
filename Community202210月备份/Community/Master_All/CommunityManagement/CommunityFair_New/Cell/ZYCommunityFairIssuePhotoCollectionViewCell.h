//
//  ZYCommunityFairIssuePhotoCollectionViewCell.h
//  Community
//
//  Created by ZY on 2022/6/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYCommunityFairIssuePhotoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *contentImgView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIView *addView;

@end

NS_ASSUME_NONNULL_END
