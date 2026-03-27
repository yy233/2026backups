//
//  ZYFamilyArchiveModel.h
//  Community
//
//  Created by ZY on 2021/11/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYFamilyArchiveModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *uid;

// 关系
@property (nonatomic, assign) NSInteger relation;

// 关系文本
@property (nonatomic, copy) NSString *relationText;

// 姓名
@property (nonatomic, copy) NSString *name;

// 电话
@property (nonatomic, copy) NSString *mobile;

// 性别（1男，2女）
@property (nonatomic, assign) NSInteger sex;

// 出生日期
@property (nonatomic, copy) NSString *birthday;

// 身份证
@property (nonatomic, copy) NSString *idCard;

// 头像地址
@property (nonatomic, copy) NSString *avatarUrl;

// 信息是否完善（0未完善，1已完善）
@property (nonatomic, assign) NSInteger status;

// 是否是自己
@property (nonatomic, assign) BOOL oneself;

@end

NS_ASSUME_NONNULL_END
