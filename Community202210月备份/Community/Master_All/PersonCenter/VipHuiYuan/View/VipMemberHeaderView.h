//
//  VipHuiYuanView.h
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import <UIKit/UIKit.h>
#import "VipMamberTableViewCellBaseDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface VipMemberHeaderView : UIView
@property (nonatomic,strong) UIImageView *backImgV;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleL;
@property (nonatomic,strong) UIImageView *titileBackImgV;
@property (nonatomic,strong) UIButton *bottomBtn;
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,weak) id <VipMamberTableViewCellBaseDelegate> headerViewDelegate;
//
@end

NS_ASSUME_NONNULL_END
