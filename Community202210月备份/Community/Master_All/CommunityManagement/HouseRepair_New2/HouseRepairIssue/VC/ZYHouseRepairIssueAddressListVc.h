//
//  ZYHouseRepairIssueAddressListVc.h
//  Community
//
//  Created by ZY on 2022/4/12.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ZYHouseRepair_Region_Type_Public,      // 公共区域
    ZYHouseRepair_Region_Type_NoPublic     // 非公共区域
} ZYHouseRepair_Region_Type;

NS_ASSUME_NONNULL_BEGIN

@interface ZYHouseRepairIssueAddressListVc : ZYBaseViewController

@property (nonatomic, assign) ZYHouseRepair_Region_Type type;

@property (nonatomic, copy) NSString *communityId;

@end

NS_ASSUME_NONNULL_END
