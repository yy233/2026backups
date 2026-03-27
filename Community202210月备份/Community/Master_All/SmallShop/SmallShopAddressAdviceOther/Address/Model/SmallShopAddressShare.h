//
//  SmallShopAddressShare.h
//  Community
//
//  Created by 余莹 on 2022/3/11.
//

#import <Foundation/Foundation.h>
#import "SmallShopAddressInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SmallShopAddressShare : NSObject
@property (nonatomic,strong) SmallShopAddressInfoModel *nomallAddressInfoModel;

singleton_interface(share)


@end

NS_ASSUME_NONNULL_END
