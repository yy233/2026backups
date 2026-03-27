//
//  ZYEventRemindTopModel.h
//  Community
//
//  Created by ZY on 2021/11/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYEventRemindTopModel : NSObject

// 天
@property (nonatomic, copy) NSString *day;

// 周
@property (nonatomic, copy) NSString *week;

@property (nonatomic, assign) NSInteger weekNum;

// 日期
@property (nonatomic, copy) NSString *date;

// 是否选中
@property (nonatomic, assign) BOOL isSelected;

// 是否过去时
@property (nonatomic, assign) BOOL isPast;

@end

NS_ASSUME_NONNULL_END
