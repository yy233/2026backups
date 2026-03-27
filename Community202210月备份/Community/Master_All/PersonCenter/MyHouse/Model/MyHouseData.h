//
//  MyHouseData.h
//  Community
//
//  Created by 余莹 on 2021/8/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHouseData : NSObject
//查询当前房子 用户的人物关系列表
+ (void)getMyHousePersonsRelationListDataWithParms:(NSMutableDictionary *)parms withBlock:(BaseDicAndSuccessBoolBlock)block;
//当前业主用户的情况下 批量删除 家属租客等次级关系人
+ (void)deletMyHousePersonsRelationsWithIdsArr:(NSArray *)idsArr withBlock:(BaseDicAndSuccessBoolBlock)block;
//当前业主用户情况下   家属租客的新增
+ (void)addMyHousePersonsRelationsWithPersonInfoDic:(NSMutableDictionary *)personInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block;
//家属详情编辑更新新版信息
+ (void)updateMyHousePersonWithFlamilyInfoDic:(NSMutableDictionary *)personInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block;
//当前业主用户情况下  房屋的新增
+ (void)addMyHouseWithHouseInfoDic:(NSMutableDictionary *)houseInfoDic withBlock:(BaseDicAndSuccessBoolBlock)block;

//根据小区查询所有当前业主认证过房子
+ (void)getMyHousesHaveBeenCertifiedListDataWithBlock:(BaseListArrAndSuccessBoolBlock)block;
 
//根据小区查询所有当前业主认证过房子 （用户是任意关联身份关系的房子）
+ (void)getMyHousesHaveRelattionListWithBlock:(BaseListArrAndSuccessBoolBlock)block;
@end

NS_ASSUME_NONNULL_END
