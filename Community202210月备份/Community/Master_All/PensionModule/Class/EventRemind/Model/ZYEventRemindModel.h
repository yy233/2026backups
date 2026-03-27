//
//  ZYEventRemindModel.h
//  Community
//
//  Created by ZY on 2021/11/11.
//

#import <Foundation/Foundation.h>

@class ZYEventRemindRecordsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYEventRemindModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

// 内容
@property (nonatomic, copy) NSString *content;

// 状态（0未启用，1已启用）
@property (nonatomic, assign) NSInteger status;

// 是否已提醒
@property (nonatomic, assign) BOOL pushStatus;

// 提醒小时
@property (nonatomic, assign) NSInteger warnHour;

// 提醒分钟
@property (nonatomic, assign) NSInteger warnMinute;

// 提醒家人集合
@property (nonatomic, strong) NSArray<ZYEventRemindRecordsModel *> *records;

// 提醒周天
@property (nonatomic, strong) NSArray *weeks;

// 家人id集合
@property (nonatomic, strong) NSArray *families;

@end


@interface ZYEventRemindRecordsModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
