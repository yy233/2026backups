//
//  ActivityOtherData.h
//  Community
//
//  Created by 余莹 on 2022/6/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActivityOtherData : NSObject
//活动详情
+ (void)getDetailOfIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block;

//活动报名
+ (void)activityInputInfo:(NSMutableDictionary *)inputDic withBlock:(BaseDicAndSuccessBoolBlock)block;

//取消报名
+ (void)cancelActivityOfIdStr:(NSString *)idStr withBlock:(BaseDicAndSuccessBoolBlock)block; 
@end

NS_ASSUME_NONNULL_END
