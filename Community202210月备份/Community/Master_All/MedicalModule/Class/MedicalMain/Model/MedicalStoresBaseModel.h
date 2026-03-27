//
//  MedicalStoresBaseModel.h
//  Community
//
//  Created by 余莹 on 2021/12/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MedicalStoresBaseModel : NSObject

 
@property (nonatomic,copy) NSString *businessAddress;
@property (nonatomic,copy) NSString *mobile;

@property (nonatomic,copy) NSString *shopLogo;
@property (nonatomic,copy) NSString *shopName;
@property (nonatomic,copy) NSString *shopPhone;
@property (nonatomic,copy) NSString *shopTreeIdName;
@property (nonatomic,copy) NSString *title;

@property (nonatomic,assign) double distance;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,assign) double grade; //评分

@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger shopId;
@property (nonatomic,assign) NSInteger ID;
//@property (nonatomic,copy) NSString *ID;

/**
 
 "code": 0,
  "data": {
    "current": 1,
    "extra": null,
    "records": [
      {
        "businessAddress": "营业执照的地址",
        "distance": 40,
        "grade": null,
        "id": "1467745492880965634",
        "mobile": "023-75565121",
        "price": null,
        "shopLogo": "http://222.178.212.29:9000/mall/418e3915-bc5b-4d70-944e-d45bc2faf4e9-swiper1.png",
        "shopName": "麻辣小面3",
        "shopPhone": "13132314900",
        "shopTreeIdName": "",
        "title": "",
        "type": 1
      }
    ],
    "size": 10,
    "total": 1
 */
@end

NS_ASSUME_NONNULL_END
