//
//  ZYSmallShopContainerRentPaySuccessAddressCell.h
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopContainerRentDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopContainerRentPaySuccessAddressCellDelegate <NSObject>

- (void)navigationButtonEvent;

- (void)chatButtonEvent;

@end

@interface ZYSmallShopContainerRentPaySuccessAddressCell : UITableViewCell

@property (nonatomic, strong) ZYSmallShopContainerRentDetailModel *model;

@property (nonatomic, weak) id<ZYSmallShopContainerRentPaySuccessAddressCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
