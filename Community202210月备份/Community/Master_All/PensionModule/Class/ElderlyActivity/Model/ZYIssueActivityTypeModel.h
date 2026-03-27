//
//  ZYIssueActivityTypeModel.h
//  Community
//
//  Created by ZY on 2021/12/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYIssueActivityTypeModel : NSObject <YYModel>

// 活动类型id
@property (nonatomic, copy) NSString *ID;

// 活动类型
@property (nonatomic, copy) NSString *activityTypeCode;

// 活动类型名
@property (nonatomic, copy) NSString *activityTypeName;

@end

NS_ASSUME_NONNULL_END
