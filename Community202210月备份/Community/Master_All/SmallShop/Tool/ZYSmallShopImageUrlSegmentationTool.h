//
//  ZYSmallShopImageUrlSegmentationTool.h
//  Community
//
//  Created by ZY on 2022/3/3.
//

#import <Foundation/Foundation.h>
#import "ZYImageWidthHeightModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopImageUrlSegmentationTool : NSObject

+ (ZYImageWidthHeightModel *)imageUrlSegmentationWithUrlStr:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
