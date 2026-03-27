//
//  BuniessShopRentNomalShaiXuanModel.h
//  Community
//
//  Created by 余莹 on 2021/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuniessShopOrHouseRentNomalShaiXuanModel : NSObject


@property (nonatomic,strong) NSString *name;
//
@property (nonatomic,strong) NSString *annotation;
@property (nonatomic,strong) NSString *houseConstName;
@property (nonatomic,strong) NSString *houseConstValue;
@property (nonatomic,strong) NSString *idStr;
//@property (nonatomic,assign) NSInteger id;
@property (nonatomic,assign) NSInteger ID;

@property (nonatomic,assign) NSInteger houseConstType;
@property (nonatomic,assign) NSInteger houseConstCode;

//
/**
 getCityQuArr == (
        {
        id = 500101;
        initials = W;
        lat = "30.8079";
        level = 3;
        lng = "108.409";
        name = "\U4e07\U5dde\U533a";
        pid = 500100;
        pinyin = wanzhou;
    },
        {
 
 
 annotation = "房屋租金";
 houseConstCode = 32;
 houseConstName = "2万/月以上";
 houseConstType = 5;
 houseConstValue = "20000,999999";
 id = 35;
 idStr = 35;
 //
 annotation = "\U79df\U623f\U7c7b\U578b";
 houseConstCode = 4;
 houseConstName = "\U522b\U5885";
 houseConstType = 10;
 id = 67;
 idStr = 67;
 
 
 */
@end

NS_ASSUME_NONNULL_END
