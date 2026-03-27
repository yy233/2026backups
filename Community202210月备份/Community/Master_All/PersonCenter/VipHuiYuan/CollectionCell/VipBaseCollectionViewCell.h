//
//  VipHeaderViewSubCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import <UIKit/UIKit.h>
#define Color_brown114    Y_RGBA(114, 56, 0, 1)
#define Color_brown192    Y_RGBA(192, 174, 163, 1)
#define COlor_Red255      Y_RGBA(255, 55, 61, 1)

NS_ASSUME_NONNULL_BEGIN

@interface VipBaseCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) UIView *backV;
@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UILabel *centerL;
@property (nonatomic,strong) UILabel *bottomL;
- (void)setBaseLabelUI;
- (void)setBaseHaveImgUI;
@end

NS_ASSUME_NONNULL_END
