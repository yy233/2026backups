//
//  Url_OtherTool.h
//  Socialize
//
//  Created by 余莹 on 2023/10/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Url_OtherTool : NSObject
+ (NSString *)getRandStringWithLength:(int)length;
+ (NSString *)getNewUrlNeedInterRandStrWithAllUrl:(NSString *)nowAllUrlstr;
+ (NSString *)getNewUrlWithAddRandStr:(NSString *)nowUrlPstr;
@end

NS_ASSUME_NONNULL_END

