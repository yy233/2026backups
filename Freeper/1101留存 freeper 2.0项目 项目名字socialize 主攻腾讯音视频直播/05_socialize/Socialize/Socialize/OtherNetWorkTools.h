//
//  ZhiBoNetWorkTools.h
//  Socialize
//
//  Created by 余莹 on 2023/10/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OtherNetWorkTools : NSObject
+ (void)getShenHeInfoWithBlock:(BaseDicAndSuccessBoolBlock)block;
//+ (void)getActivityXuNiNumActionWithActivityID:(NSString *)activityId withBlock:(BaseDicAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
