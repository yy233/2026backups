//
//  PersonCenterNomalCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2021/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonCenterNomalCollectionViewCell : UICollectionViewCell // PersonCenterVcLateBaseCollectionViewCell 子视图配置一样 ，高度不一样。 本类是旧版本 
@property (nonatomic,strong) UIImageView *topImgV;
@property (nonatomic,strong) UILabel *bottomTextLabel;
@end

NS_ASSUME_NONNULL_END
