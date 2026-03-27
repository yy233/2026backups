//
//  ZYIPAdressTool.h
//  ZYVC
//
//  Created by ZY on 2021/5/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZYIPAdressBlock)(NSString *ipAdress);

@interface ZYIPAdressTool : NSObject

// 获取IP地址
+ (void)deviceWANIPAddressBlock:(ZYIPAdressBlock)block;

@end

NS_ASSUME_NONNULL_END
