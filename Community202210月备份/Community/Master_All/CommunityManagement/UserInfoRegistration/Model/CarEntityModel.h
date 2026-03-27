//
//  CarEntityModel.h
//  Community
// 车辆整体信息model
//  Created by 余莹 on 2020/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CarEntityModel : NSObject
@property (nonatomic,strong) NSString *carTypeText;//20210225 详情页使用的 业主部分 车辆信息 类型文字型文本
@property (nonatomic,strong) NSString *drivingLicenseUrl;//20210225行驶证
//
@property (nonatomic,strong) NSString *carImageUrl;//车辆图片（弃用）
@property (nonatomic,strong) NSString *carPlate;
@property (nonatomic,strong) NSString *carType;//类型文本 详情页使用的 业主部分 车辆信息 类型code文本
@property (nonatomic,assign) NSInteger carTypeCode;//类型code  增
@property (nonatomic,assign) NSInteger carPositionId;
@property (nonatomic,assign) NSInteger communityId;
//
@property (nonatomic,assign) NSInteger id;//业主登记数据 查看更改时 会用到
/**
 请求参数：
 {
   "areaId": 0,
   "carEntity": {
     "carImageUrl": "https://www.baidu.com",
     "carPlate": "粤B52865",
     "carPositionId": 123,
     "carType": "重型车",
     "communityId": 1
   },
   "detailAddress": "",
   "hasCar": true,
   "householderId": 0,
   "idCard": "513029199910053056",
   "realName": "张某某",
   "sex": 0
 }
 */
@end

NS_ASSUME_NONNULL_END
