//
//  ZYSmallShopContainerRentDetailPriceCollectionViewCell.h
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopContainerRentDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopContainerRentDetailPriceCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) ZYSmallShopContainerRentDetailCabinetModel *model;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

NS_ASSUME_NONNULL_END
