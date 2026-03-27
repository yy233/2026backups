//
//  ZYCaschesTool.h
//  Community
//
//  Created by ZY on 2021/10/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYCaschesTool : NSObject

singleton_interface(share)

// 获取缓存数据大小
- (NSString *)getCacheSize;

// 清除数据
- (void)cleanCacheWithSuccess:(void (^)(BOOL success))successBlock;

@end

NS_ASSUME_NONNULL_END
