//
//  ZYSmallShopDetailAddressCell.h
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopDetailAddressCellDelegate <NSObject>

- (void)navigationButtonEvent;

@end

@interface ZYSmallShopDetailAddressCell : UITableViewCell

@property (nonatomic, strong) ZYSmallShopGoodsDetailDataInfoModel *model;

@property (nonatomic, weak) id<ZYSmallShopDetailAddressCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
