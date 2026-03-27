//
//  ZhiBoMainListSubCollectionViewCell.h
//  Socialize
//
//  Created by 余莹 on 2023/5/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhiBoMainListSubCollectionViewCell : UICollectionViewCell
//@property (nonatomic,strong) MainCenterCollectionViewCellModel *model;
@property (nonatomic,strong)UIView *backView;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong)UIImageView *typeImg;
@property (nonatomic,strong)UILabel *typeLabel;
@property (nonatomic,strong)KJMarqueeLabel *titleLabel;
@property (nonatomic,strong)KJMarqueeLabel *subtitleLabel_S;
@property (nonatomic,strong)UILabel *numLabel;
@property (nonatomic,strong)UILabel *dealLineTimeLabel;
@property (nonatomic,strong)UIView *textBkv;
@property (nonatomic,strong) UILabel *topRightVOiceOrLiveTypeLabel;
@property (nonatomic,strong) UILabel *topRightPubOrPivTypeLabel;

@end

NS_ASSUME_NONNULL_END
