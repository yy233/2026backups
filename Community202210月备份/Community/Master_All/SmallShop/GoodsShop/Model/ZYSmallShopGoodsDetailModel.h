//
//  ZYSmallShopGoodsDetailModel.h
//  Community
//
//  Created by ZY on 2022/3/11.
//

#import <Foundation/Foundation.h>

@class ZYSmallShopGoodsDetailDataInfoModel, ZYSmallShopGoodsDetailPayModel;

NS_ASSUME_NONNULL_BEGIN


@interface ZYSmallShopGoodsDetailModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *storeId;

// 社区id
@property (nonatomic, copy) NSString *communityId;

// 活动id
@property (nonatomic, copy) NSString *spellId;

@property (nonatomic, copy) NSString *commodityName;

// 结束时间
@property (nonatomic, copy) NSString *activityEndTime;

// 首图
@property (nonatomic, copy) NSString *commodityHeadImg;

// 详情图
@property (nonatomic, copy) NSString *commodityDetailsImg;

// 商品描述信
@property (nonatomic, copy) NSString *commodityDescribe;

@property (nonatomic, strong) ZYSmallShopGoodsDetailDataInfoModel *informationDto;

@property (nonatomic, strong) ZYSmallShopGoodsDetailPayModel *payDto;

@end


@interface ZYSmallShopGoodsDetailDataInfoModel : NSObject

// 手机号
@property (nonatomic, copy) NSString *storePhone;

// 地址
@property (nonatomic, copy) NSString *storeAddress;

// 经度
@property (nonatomic, assign) CGFloat latitude;

// 纬度
@property (nonatomic, assign) CGFloat longitude;

@end


@interface ZYSmallShopGoodsDetailPayModel : NSObject

// 商品id
@property (nonatomic, copy) NSString *commodityId;

// 活动类型 0没有活动 1打折 满减 3满送 4拼团
@property (nonatomic, assign) NSInteger activityType;

// 活动名
@property (nonatomic, copy) NSString *activityName;

// 原价
@property (nonatomic, copy) NSString *commodityOriginalPrice;

// 卖价
@property (nonatomic, copy) NSString *commoditySellPrice;

@property (nonatomic, assign) NSInteger actualNumber;

@property (nonatomic, copy) NSString *actualPrice;

@property (nonatomic, copy) NSString *sumMoney;

@property (nonatomic, copy) NSString *activityFull;

@property (nonatomic, copy) NSString *activityGive;

@end

NS_ASSUME_NONNULL_END
