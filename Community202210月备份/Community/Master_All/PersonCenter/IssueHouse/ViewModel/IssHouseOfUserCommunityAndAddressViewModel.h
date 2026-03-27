//
//  IssHouseCommunityViewModel.h
//  Community
//
//  Created by 余莹 on 2021/2/26.
//  出租 新增页 subpop （非商铺的）地址数据

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IssHouseOfUserCommunityAndAddressViewModel : NSObject
//+ (void)getIssueUserCommunityWithCityId:(NSInteger)cityId getCimmunityArr:(BaseListArrAndSuccessBoolBlock)listBlock;
+ (void)getIssueUserCommunityArr:(BaseListArrAndSuccessBoolBlock)listBlock;////1015更换
+ (void)getIssueUserAddressWithCommunityId:(NSInteger)commnunityId getAddressArr:(BaseListArrAndSuccessBoolBlock)listBlock;
@end

NS_ASSUME_NONNULL_END
