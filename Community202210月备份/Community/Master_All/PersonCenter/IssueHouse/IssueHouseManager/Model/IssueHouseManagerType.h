//
//  IssueHouseManagerType.h
//  Community
//
//  Created by 余莹 on 2021/4/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    IssueHouseManagerVC_MyType_FangDong,//房东身份
    IssueHouseManagerVC_MyType_ZuKe,//租客身份
    IssueHouseManagerVC_MyType_BuniessShopManager,//商铺类型
    IssueHouseManagerVC_MyType_Other,//其他
} IssueHouseManagerVC_MyType;



@interface IssueHouseManagerType : NSObject

@end

NS_ASSUME_NONNULL_END
