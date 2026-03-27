//
//  CommunityModel.h
//  Community
//
//  Created by 余莹 on 2020/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 查询类型1为查社区，需要传入城市id
 查询类型2为查单元，需要传入社区id
 查询类型3为查楼栋，需要传入单元id
 查询类型4为查楼层，需要传入楼栋id
 查询类型5为查门牌，需要传入楼层id
 */
typedef enum : NSUInteger {
    Community_Type_Community=1,//社区
    Community_Type_Unit=2,//单元
    Community_Type_Building=3,//楼栋
    Community_Type_Floor=4,//楼层
    Community_Type_Addresses=5,//门牌
}Community_Choose_Type;//queryType旧数据      弃用
//queryType旧数据 弃用

@interface CommunityModel : NSObject <NSCopying,NSMutableCopying>
//小区mode 在首页经纬度获取小区时 也会用到 存在share
@property (nonatomic,assign) NSInteger areaId;
@property (nonatomic,assign) NSInteger cityId;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,assign) NSInteger deleted;
@property (nonatomic,strong) NSString *detailAddress;
@property (nonatomic,strong) NSString *distanceDouble;
@property (nonatomic,strong) NSString *distanceString;
//@property (nonatomic,assign) NSInteger id;//小区ID
@property (nonatomic,assign) NSInteger ID;//小区ID
@property (nonatomic,assign) float lat;
@property (nonatomic,assign) float lon;
@property (nonatomic,strong) NSString *name;//小区名
@property (nonatomic,assign) NSInteger provinceId;
@property (nonatomic,strong) NSString *updateTime;
//@property (nonatomic,assign) NSInteger houseLevelMode;//新增字段 小区获取后 小区下级别层级关系由此定 弃用
@property (nonatomic,assign) NSInteger houseId;//门牌ID
@property (nonatomic,strong) NSString *iconUrl;

 /**
  data =     {
      areaId = 500103;
      cityId = 1;
      createTime = "2020-11-18 14:52:46";
      deleted = 0;
      detailAddress = "重庆花园小区";
      distanceDouble = "<null>";
      distanceString = "<null>";
      houseId = 115;
      houseLevelMode = 1;
      iconUrl = "https://dss2.bdstatic.com/6Ot1bjeh1BF3odCf/it/u=2812524706,2358921697&fm=85&app=81&f=JPG?w=121&h=75&s=8C851C72269ADF201DC7D8560300C0B8";
      id = 1;
      lat = 312;
      lon = 123;
      name = "帆云小区";
      provinceId = 12;
      updateTime = "2020-11-03 14:52:52";
  };
  message = "<null>";*/
 @end

NS_ASSUME_NONNULL_END
