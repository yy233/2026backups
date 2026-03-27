//
//  TempCodeRelated.h
//  Community
//
//  Created by 余莹 on 2021/10/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    TempCodeTime_Type_30,
    TempCodeTime_Type_60,
    TempCodeTime_Type_90,
} TempCodeTime_Type;

@interface TempCodeRelated : NSObject
+ (void)addTempCodeWithCommunityId:(NSString *)communityId withTimeType:(TempCodeTime_Type)timeType withBlock:(BaseDicAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
