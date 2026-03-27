//
//  HouseRentListVcBuniessShopQueryTypesModel.h
//  Community
//
//  Created by 余莹 on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentListVcBuniessShopQueryTypesModel : NSObject
@property (nonatomic,strong) NSString *searchText;
@property (nonatomic,assign) NSInteger houseAreaId;
@property (nonatomic,assign) double housePriceMin;
@property (nonatomic,assign) double housePriceMax;
@property (nonatomic,assign) double houseSquareMeterMin;
@property (nonatomic,assign) double houseSquareMeterMax;
@property (nonatomic,assign) NSInteger houseSourceId;
@property (nonatomic,strong) NSMutableArray *shopTypeIdArrays;//类型
@property (nonatomic,strong) NSMutableArray *shopBusinessIdArrays;//行业
//
@property (nonatomic,assign) NSInteger shopTypeId;

/**
 "page": 1,
 "size": 20,
 "query":{
  "searchText":null,                                                   房源搜索文本
  "houseAreaId":null,                                                房屋租售所属区ID
  "housePriceMin":null,                                             房屋租售价格最小值
  "housePriceMax":null,                                            房屋租售价格最大值
  "houseSquareMeterMin":null,                                房屋租售平方最小值
  "houseSquareMeterMax":null,                                房屋租售平方最大值
  "shopTypeId":null,                                                  类型
  "shopBusinessId":null,                                             行业
  "houseSourceId":null                                              来源
 @property (nonatomic,assign) NSInteger shopTypeId;
 @property (nonatomic,assign) NSInteger shopBusinessId;
 改数组
 } */
@end

NS_ASSUME_NONNULL_END
