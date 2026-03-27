//
//  UserHouseListModel.h
//  Community
//  访客界面查询业主自己所有小区房屋
//业主自己所有houseList + 业主自己所有的小区list
//  Created by 余莹 on 2020/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ListArrBlock)(NSArray *);

@interface UserHouseOrCommunityListModel : NSObject
//作为业主家属租客身份所拥有的房屋列表
+ (void)getUserAllHouseListWithBlock:(ListArrBlock)listArrBlock;
/**
 address = "2\U680b2\U5355\U51431\U5c42bd24fa08-8207-11eb-b";
 buildingId = 4;
 communityId = 1;
 communityName = "\U5e06\U8f6f\U793e\U533a";
 id = 114;
 idStr = 114;
 owner = "\U4f59\U83b9";
 pid = 4;
 */

//只是作为业主身份所拥有的房屋列表
+ (void)getUserHouseListWhenIsYeZhuWithBlock:(ListArrBlock)listArrBlock;
//作为业主家属租客身份所拥有的小区列表
+ (void)getUerAllCommunityListWithBlock:(BaseListArrAndSuccessBoolBlock)listBlock;
/**
 id = 2;
 name = "\U8054\U60f3\U793e\U533a";
},
{
 */


//只是作为业主身份所拥有的小区列表
+ (void)getUerAllCommunityListWhenMyRightIsYeZhuWithBlock:(BaseListArrAndSuccessBoolBlock)listBlock;
 
@end

NS_ASSUME_NONNULL_END
