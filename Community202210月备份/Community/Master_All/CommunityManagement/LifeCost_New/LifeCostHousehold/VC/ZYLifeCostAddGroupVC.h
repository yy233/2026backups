//
//  ZYLifeCostAddGroupVC.h
//  Community
//
//  Created by ZY on 2022/1/7.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZYLife_Cost_Type_AddHousehold, //新增缴费
    ZYLife_Cost_Type_AddGroup, //新增分组
    ZYLife_Cost_Type_UpdateGroup, //修改分组
} ZYLife_Cost_Type;

NS_ASSUME_NONNULL_BEGIN

@interface ZYLifeCostAddGroupVC : ZYBaseViewController

@property (nonatomic, assign) ZYLife_Cost_Type type;

// 分组id
@property (nonatomic, copy) NSString *groupId;

// 分组名
@property (nonatomic, copy) NSString *groupName;

@end

NS_ASSUME_NONNULL_END
