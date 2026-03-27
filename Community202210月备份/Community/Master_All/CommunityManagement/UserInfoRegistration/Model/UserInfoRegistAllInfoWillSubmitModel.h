//
//  UserInfoRegistAllInfoWillSubmitModel.h
//  Community
//
//  Created by 余莹 on 2020/11/23.
//

#import <Foundation/Foundation.h>
#import "CarEntityModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserInfoRegistAllInfoWillSubmitModel : NSObject

@property (nonatomic,assign) NSInteger sex;
@property (nonatomic,strong) NSString *realName;
@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,assign) NSInteger householderId;
@property (nonatomic,strong) NSString *detailAddress;
@property (nonatomic,assign) NSInteger areaId;
@property (nonatomic,strong) NSMutableArray *carEntityList;
@property (nonatomic,strong) NSMutableArray *houseEntityList;
//家属部分 --- 新增属性 ：电话 亲属关系code
//增
@property (nonatomic,assign) NSInteger concern;
@property (nonatomic,strong) NSString *phoneTel;
//0305增
@property (nonatomic,assign) NSInteger relation;//亲属关系
@property (nonatomic,strong) NSString *mobile;


/** 旧
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
 
 //新
 "carImageUrl": "http://www.baidu.com/dsadsadadsa.jpg",
    "carPlate": "渝A1A619",
    "carType": 4
  }
],
"houseEntityList": [{
    "id": 63,
    "communityId": 1
 */
@end

NS_ASSUME_NONNULL_END
