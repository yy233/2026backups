//
//  ZYUploadFaceCollectionViewCell.h
//  Community
//
//  Created by ZY on 2021/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYUploadFaceCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *addView;

@property (weak, nonatomic) IBOutlet UIView *editView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIView *statusView;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

NS_ASSUME_NONNULL_END
