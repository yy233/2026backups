//
//  MedicalServiceBaseModel.h
//  Community
//
//  Created by 余莹 on 2021/12/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MedicalServiceBaseModel : NSObject

@property (nonatomic,copy) NSString *images;
@property (nonatomic,copy) NSString *shopName;
@property (nonatomic,copy) NSString *serviceCall;
@property (nonatomic,copy) NSString *shopTreeIdName;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *goodsTypeName;
@property (nonatomic,copy) NSString *textDescription;
@property (nonatomic,copy) NSString *serviceRegulations;

@property (nonatomic,assign) NSInteger isPutaway;
@property (nonatomic,assign) NSInteger priceStrategy;
@property (nonatomic,assign) NSInteger goodsTypeId;
@property (nonatomic,assign) BOOL discountState;//折扣
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) NSInteger shopId;
@property (nonatomic,assign) NSInteger ID;

//@property (nonatomic,assign) double pvNum;
//@property (nonatomic,assign) double sums;
//@property (nonatomic,assign) double price;
//@property (nonatomic,assign) double discountPrice; //折扣

@property (nonatomic,copy) NSString *pvNum;
@property (nonatomic,copy) NSString *sums;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *discountPrice; //折扣


/**
 
 {
discountPrice = 199;
discountState = 0;
goodsTypeId = 1458340509269938177;
goodsTypeName = "美食";
id = 1466678902386200578;
images = "http://222.178.212.29:9000/mall/6b4a107c-3147-48bc-96e2-52882075c55d-food-img.png,http://222.178.212.29:9000/mall/6b4a107c-3147-48bc-96e2-52882075c55d-food-img.png";
isPutaway = 1;
price = 200;
priceStrategy = 0;
pvNum = 229;
serviceCall = 1818181818;
serviceRegulations = "服务规则";
shopId = 1466339716018806786;
shopName = "纵横世纪";
sums = 0;
textDescription = "介绍";
title = "服务名4";
type = 1;
validUntilTime = "2021-12-01 12:00:00";
}
);
 */

@end

NS_ASSUME_NONNULL_END
