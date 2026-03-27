//
//  AccessListModel.h
//  Community
//  门禁
//communityAccess 社区门禁类型
//buildingAccess  楼栋门禁类型
//  Created by 余莹 on 2020/12/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ListArrBlock)(NSArray *);
@interface AccessListModel : NSObject
+ (void)getCommunityAccessListWithBlock:(ListArrBlock)listArrBlock;
+ (void)getBuildingAccessListWithBlock:(ListArrBlock)listArrBlock;
@end

NS_ASSUME_NONNULL_END
