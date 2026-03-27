//
//  ZYSmallShopGoodsData.h
//  Community
//
//  Created by ZY on 2022/4/21.
//

#import <Foundation/Foundation.h>

typedef void(^ZYCompletionBlock)(id _Nullable responsObject, BOOL success);

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopGoodsData : NSObject

+ (void)isSmallShopGoodsOpen:(ZYCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
