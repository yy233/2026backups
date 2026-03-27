//
//  UserFamilAllModel.h
//  Community
//
//  Created by 余莹 on 2021/3/3.
//   (详情页_使用)0303 家属model 换

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserFamilAllModel : NSObject
/**
 cars =     (
             {
         carPlate = "\U6e1dA77767";
         carType = 2;
         carTypeText = "\U5c0f\U578b\U8f66";
         drivingLicenseUrl = "http://222.178.212.29:9000/wocao/1e1abbce-cc04-4cf8-a509-158182b0aa6a";
         id = 29626556179681280;
     }
 );
 communityId = 2;
 houseId = 115;
 id = 19;
 idCard = 516498199108138777;
 identificationType = 1;
 mobile = 15087487146;
 name = "\U4f59\U8bc6";
 relation = 2;
 sex = 0;
}
 */

@property (nonatomic,strong) NSString *householderId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *idCard;
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger communityId;
@property (nonatomic,assign) NSInteger houseId;
@property (nonatomic,assign) NSInteger sex;
@property (nonatomic,assign) NSInteger relation;
@property (nonatomic,strong) NSArray *cars;
@end

@interface UserFamilAllModelOfCarsModel : NSObject
//car
@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger carType;          //类型code
@property (nonatomic,strong) NSString *carTypeText;      //类型文本
@property (nonatomic,strong) NSString *carPlate;         //车牌
@property (nonatomic,strong) NSString *drivingLicenseUrl;//url
 
@end

NS_ASSUME_NONNULL_END
