//
//  ZYSmallShopContainerRentOrderVc.h
//  Community
//
//  Created by ZY on 2022/3/21.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopContainerRentDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopContainerRentOrderVc : ZYSmallShopBaseVC

@property (nonatomic, strong) ZYSmallShopContainerRentDetailModel *model;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *address;

@end

NS_ASSUME_NONNULL_END
