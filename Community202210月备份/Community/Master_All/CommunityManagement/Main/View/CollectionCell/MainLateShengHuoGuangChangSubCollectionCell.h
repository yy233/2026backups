//
//  MainLateShengHuoGuangChangSubCollectionCell.h
//  Community
//
//  Created by 余莹 on 2021/8/9.
//

#import <UIKit/UIKit.h>
#import "HouseRentListVcHouseCellModel.h"
#import "MainShengHuoGuangChangListErShouUseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MainLateShengHuoGuangChangSubCollectionCell : UICollectionViewCell
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong)UIImageView *imgView;
@property (nonatomic,strong) UILabel *typeL;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *lineV;
@property (nonatomic,strong) UILabel *addressL;
@property (nonatomic,strong) UILabel *moneyL;
@property (nonatomic,strong) UIView *tipBackView;

- (void)fillZuFangCellDataModel:(HouseRentListVcHouseCellModel *)model;//租房数据
- (void)fillErShouShopCellDataModel:(MainShengHuoGuangChangListErShouUseModel *)model;//二手数据


@end

NS_ASSUME_NONNULL_END
