//
//  ZYSmallShopContainerRentPayPriceCell.h
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopContainerRentDetailModel.h"

#define kZYSmallShopContainerRentPayPriceCollectionViewCell_W (kScreenW-87)/4.0
#define kZYSmallShopContainerRentPayPriceCollectionViewCell_H (kScreenW-87)/4.0*85.0/72.0

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopContainerRentPayPriceCellDelegate <NSObject>

- (void)collectionViewSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface ZYSmallShopContainerRentPayPriceCell : UITableViewCell

@property (nonatomic, strong) ZYSmallShopContainerRentDetailModel *model;

@property (nonatomic, weak) id<ZYSmallShopContainerRentPayPriceCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
