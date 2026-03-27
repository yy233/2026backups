//
//  ZYSmallShopServiceCollectionViewCell.h
//  Community
//
//  Created by ZY on 2022/3/2.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopMainModel.h"

#define kZYSmallShopServiceCollectionViewCell_W (kScreenW-46)/2.0

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopServiceCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ZYSmallShopMainValue3RecordsModel *model;

@property (weak, nonatomic) IBOutlet UIView *buyView;

@property (weak, nonatomic) IBOutlet UIButton *buyButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buyViewHeightConstraint;

@end

NS_ASSUME_NONNULL_END
