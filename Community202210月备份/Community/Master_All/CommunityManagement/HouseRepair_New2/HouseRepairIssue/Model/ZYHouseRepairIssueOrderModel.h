//
//  ZYHouseRepairIssueOrderModel.h
//  Community
//
//  Created by ZY on 2022/4/12.
//

#import <Foundation/Foundation.h>

@class ZYHouseRepairIssueOrderChildrenModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYHouseRepairIssueOrderModel : NSObject <YYModel>

// 唯一标识id
@property (nonatomic, copy) NSString *ID;

// 父级id
@property (nonatomic, copy) NSString *pid;

// 小区id
@property (nonatomic, copy) NSString *communityId;

// 分类名称
@property (nonatomic, copy) NSString *name;

// 类型(1.内部工单 2.外部工单)
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSArray<ZYHouseRepairIssueOrderChildrenModel *> *children;

@end


@interface ZYHouseRepairIssueOrderChildrenModel : NSObject <YYModel>

// 唯一标识id
@property (nonatomic, copy) NSString *ID;

// 父级id
@property (nonatomic, copy) NSString *pid;

// 小区id
@property (nonatomic, copy) NSString *communityId;

// 分类名称
@property (nonatomic, copy) NSString *name;

// 类型(1.内部工单 2.外部工单)
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
