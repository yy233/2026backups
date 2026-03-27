//
//  ZYAmountCapitalTool.h
//  Community
//
//  Created by ZY on 2021/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYAmountCapitalTool : NSObject

// 金额转大写
+ (NSString *)getAmountInWords:(NSString *)money;

@end

NS_ASSUME_NONNULL_END
