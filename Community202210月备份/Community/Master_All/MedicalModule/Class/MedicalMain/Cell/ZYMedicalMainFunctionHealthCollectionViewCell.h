//
//  ZYMedicalMainFunctionHealthCollectionViewCell.h
//  Community
//
//  Created by ZY on 2021/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYMedicalMainFunctionHealthCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *contentV;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIButton *goButton;

@end

NS_ASSUME_NONNULL_END
