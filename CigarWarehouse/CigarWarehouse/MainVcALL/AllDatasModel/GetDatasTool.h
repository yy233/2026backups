//
//  GetDatasTool.h
//  CigarWarehouse
//
//  Created by 余莹 on 2024/7/16.
//

#import <Foundation/Foundation.h>
#import "CigarBrandsUseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef  void(^BlockWithSuccBoolAndArr)(BOOL succ,NSArray *dataList);


@interface GetDatasTool : NSObject
singleton_interface(share)
 


#pragma mark ***************** ***************** ***************** ***************** 品牌相关查询
#pragma mark ====  获取所有品牌
- (void)getAllBrandsListWithBlock:(BlockWithSuccBoolAndArr)block;

#pragma mark ====  获取某品牌所有型号
- (void)getBrandTypesOfOneBrandId:(NSInteger)brandId withTypesListWithBlock:(BlockWithSuccBoolAndArr)block;

#pragma mark ====  根据品牌查库存
- (void)getBrandStockNumOfOneBrandId:(NSInteger)brandId
                    withOtherInfoDic:(NSMutableDictionary *)pdic
              withTypesListWithBlock:(BlockWithSuccBoolAndArr)block;

#pragma mark ====  根据某产品码code查库存
- (void)getProductInfoWithProductCodeId:(NSString *)ProductCodeId withTypesListWithBlock:(BlockWithSuccBoolAndArr)block;
#pragma mark ***************** ***************** ***************** *****************  位置相关查询

#pragma mark ====  获取所有仓库
- (void)getAllPlaceListWithBlock:(BlockWithSuccBoolAndArr)block;

#pragma mark ====  获取柜子列表
- (void)getOnePlaceSubCabinetListWithPlaceId:(NSInteger)placeId withCabinetListWithBlock:(BlockWithSuccBoolAndArr)block;

#pragma mark ====  获取柜子对应的位置
- (void)getOneCabinetSubLevelListWithCabinetId:(NSInteger)cabinetId withLevelListWithBlock:(BlockWithSuccBoolAndArr)block;

@end

NS_ASSUME_NONNULL_END
