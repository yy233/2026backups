//
//  OrderAdviceData.h
//  Community
//
//  Created by 余莹 on 2022/3/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderAdviceData : NSObject

//订单反馈图片上传
+ (void)smallOrderAdviceImg:(NSMutableArray *)imgsArr withBlock:(BaseDicAndSuccessBoolBlock)block;
//提交订单的反馈信息
+ (void)smallOrderAdviceInfo:(NSMutableDictionary *)infoDic withBlock:(BaseDicAndSuccessBoolBlock)block;

@end

NS_ASSUME_NONNULL_END
