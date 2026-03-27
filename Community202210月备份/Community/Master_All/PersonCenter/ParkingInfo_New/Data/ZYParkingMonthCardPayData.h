//
//  ZYParkingMonthCardPayData.h
//  Community
//
//  Created by ZY on 2022/5/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYParkingMonthCardPayData : NSObject

// 微信支付
+ (void)weChatPayWithOrderNum:(NSString *)orderNum;

// 支付宝支付
+ (void)ZFBPayWithOrderNum:(NSString *)orderNum;

@end

NS_ASSUME_NONNULL_END
