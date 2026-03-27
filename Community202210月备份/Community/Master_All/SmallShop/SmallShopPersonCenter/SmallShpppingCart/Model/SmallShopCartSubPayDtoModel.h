//
//  SmallShopCartSubPayDtoModel.h
//  Community
//
//  Created by 余莹 on 2022/3/10.
// 活动打折满减

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SmallShopCartSubPayDtoModel : NSObject

/**
 //原价用于中横线显示
 //售价用于单个未活动时使用
 //活动价格才是计算活动数量后的真付钱价格
 */

@property (nonatomic,copy) NSString *commodityOriginalPrice;//商品原本价格
@property (nonatomic,copy) NSString *commoditySellPrice;//商品实际售卖价格 
@property (nonatomic,copy) NSString *actualPrice;//优惠过后应该支付的金额
@property (nonatomic,copy) NSString *sumMoney;//原本价格
@property (nonatomic,copy) NSString *activityName;
@property (nonatomic,copy) NSString *commodityId;//商品id
@property (nonatomic,assign) NSInteger  commodityNumber;//购买数量
@property (nonatomic,assign) NSInteger  actualNumber;
@property (nonatomic,assign) NSInteger  activityType;//活动类型  0无1打折2满减3满送4拼团
@property (nonatomic,copy) NSString * activityFull;//满x
@property (nonatomic,copy) NSString *activityGive;//打/减/送 y
 

/**
 id = 1498867333884018689;
 payDto =             {
  activityFull = "<null>";
  activityGive = "<null>";
  activityName = "<null>";
  activityType = 0;
  actualNumber = 1;
  actualPrice = 20;
  commodityId = 1498867333884018689;
  commodityOriginalPrice = 39;
  commoditySellPrice = 20;
  sumMoney = 20;
 };
 storeId = 1498534868334215170;
 type = 1;
 },
       "commodityId": "1498867333884018692",//商品id
       "commodityNumber": 2,//购买数量
       "actualPrice": 32,//优惠过后应该支付的金额
       "sumMoney": 40,//原本价格
       "activityType": 1,//活动类型  0无1打折2满减3满送4拼团
       "activityFull": 20,//满x
       "activityGive": 8,//打/减/送 y
       "commodityOriginalPrice": 39,//商品原本价格
       "commoditySellPrice": 20//商品实际售卖价格
     },
     {*/
@end

NS_ASSUME_NONNULL_END
