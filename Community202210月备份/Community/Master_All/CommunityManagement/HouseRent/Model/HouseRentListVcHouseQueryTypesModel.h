//
//  HouseRentListVcQueryTypesModel.h
//  Community
//
//  Created by 余莹 on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HouseRentListVcHouseQueryTypesModel : NSObject
@property (nonatomic,strong) NSArray *houseAdvantage;//Query该键是数组 cellmodel的该键是字典且显示使用用key值
@property (nonatomic,strong) NSString *houseAreaId;
@property (nonatomic,assign) NSInteger houseSourceId;
@property (nonatomic,assign) double housePriceMin;
@property (nonatomic,assign) double housePriceMax;
@property (nonatomic,assign) double houseSquareMeterMin;
@property (nonatomic,assign) double houseSquareMeterMax;
//@property (nonatomic,assign) NSInteger houseTypeId;//弃用
@property (nonatomic,assign) NSInteger houseLeasetypeId;
@property (nonatomic,assign) NSInteger houseLeasemodeId;
//2021修
@property (nonatomic,strong) NSString *searchText;
@property (nonatomic,strong) NSString *houseTypeCode; //房间户型
@property (nonatomic,strong) NSMutableArray *houseAdvantageCode;//亮点

 

//2021 参数修改
/*
 {
   "page": 1,
   "query": {
     "houseAreaId": "",
     "searchText": "小区地段不错",
     "housePriceMin": 0,
     "housePriceMax": 0,
     "houseSquareMeterMin": 0,
     "houseSquareMeterMax": 0,
     "houseTypeCode": "",
     "houseLeasetypeId": 0,
     "houseLeasemodeId": 0,
     "houseAdvantage":[],
     "houseSourceId": 0
   },
   "size"
 **/
@end

NS_ASSUME_NONNULL_END
