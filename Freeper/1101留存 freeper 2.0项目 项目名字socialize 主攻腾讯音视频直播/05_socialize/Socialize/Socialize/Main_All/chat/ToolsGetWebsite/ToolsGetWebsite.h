//
//  ToolsGetWebsite.h
//  Socialize
//
//  Created by 余莹 on 2023/9/5.
//
//判断是否有网址 获取网址
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToolsGetWebsite : NSObject
+ (NSArray *)getWebsitesWithString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
