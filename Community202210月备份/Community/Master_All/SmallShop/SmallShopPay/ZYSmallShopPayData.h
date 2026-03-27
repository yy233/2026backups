//
//  ZYSmallShopPayData.h
//  Community
//
//  Created by ZY on 2022/3/26.
//

#import <Foundation/Foundation.h>
#import "ZYSmallShopPayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopPayData : NSObject

// 微信支付
+ (void)weChatPayWithOrderNum:(NSString *)orderNum;

// 支付宝支付
+ (void)ZFBPayWithOrderNum:(NSString *)orderNum;

@end

NS_ASSUME_NONNULL_END
