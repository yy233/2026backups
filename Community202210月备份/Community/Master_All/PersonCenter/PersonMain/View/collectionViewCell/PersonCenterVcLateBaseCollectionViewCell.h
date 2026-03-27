//
//  PersonCenterVcLateBaseCollectionViewCell.h
//  Community
//
//  Created by 余莹 on 2021/7/27.
//

#import <UIKit/UIKit.h> 

NS_ASSUME_NONNULL_BEGIN

@interface PersonCenterVcLateBaseCollectionViewCell : UICollectionViewCell  //PersonCenterNomalCollectionViewCell 子视图结构一样 ，图文高度不一样

@property (nonatomic,strong) UIImageView *topImgV;
@property (nonatomic,strong) UILabel *bottomTextLabel;

@end

NS_ASSUME_NONNULL_END
