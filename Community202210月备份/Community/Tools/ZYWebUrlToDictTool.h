//
//  ZYWebUrlToDictTool.h
//  Community
//
//  Created by ZY on 2022/3/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYWebUrlToDictTool : NSObject

+ (NSDictionary *)parameterWithURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
