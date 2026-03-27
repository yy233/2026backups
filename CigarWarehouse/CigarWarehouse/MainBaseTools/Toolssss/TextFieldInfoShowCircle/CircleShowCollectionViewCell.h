//
//  CircleShowCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2021/10/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleShowCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UILabel *showLabel;
- (void)changeTextFont:(UIFont *)newFont;
- (void)changeTextColor:(UIColor *)newColor;
- (void)changeTextBackColor:(UIColor *)newLabelBackColor;

@end

NS_ASSUME_NONNULL_END
