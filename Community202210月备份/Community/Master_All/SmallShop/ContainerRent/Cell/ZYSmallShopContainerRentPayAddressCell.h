//
//  ZYSmallShopContainerRentPayAddressCell.h
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopContainerRentDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZYSmallShopContainerRentPayAddressCellDelegate <NSObject>

- (void)editButtonEvent;

@end

@interface ZYSmallShopContainerRentPayAddressCell : UITableViewCell

@property (nonatomic, weak) id<ZYSmallShopContainerRentPayAddressCellDelegate> delegate;
    
- (void)fillNewAddressStr:(NSString *)addressStr andPhoneStr:(NSString *)phoneStr;

@end

NS_ASSUME_NONNULL_END
