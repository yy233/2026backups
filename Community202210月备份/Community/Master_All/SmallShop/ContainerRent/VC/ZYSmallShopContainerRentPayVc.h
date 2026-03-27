//
//  ZYSmallShopContainerRentPayVc.h
//  Community
//
//  Created by ZY on 2022/3/1.
//

#import <UIKit/UIKit.h>
#import "ZYSmallShopContainerRentDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopContainerRentPayVc : ZYSmallShopBaseVC

@property (nonatomic, strong) ZYSmallShopContainerRentDetailModel *model;

@property (nonatomic, assign) BOOL isRelet;//续租

@end

NS_ASSUME_NONNULL_END
