//
//  ZYSmallShopGoodsSpellGroupDetailModel.h
//  Community
//
//  Created by ZY on 2022/3/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopGoodsSpellGroupDetailModel : NSObject

// 商品id
@property (nonatomic, copy) NSString *commodityId;

// 拼团活动id
@property (nonatomic, strong) NSString *spellId;

// 参团总人数
@property (nonatomic, assign) NSInteger groupSpellPersonNumber;

// 已经参与的人数
@property (nonatomic, assign) NSInteger personSpell;

// 商品的原价
@property (nonatomic, copy) NSString *commodityOriginalPrice;

// 商品的团购价
@property (nonatomic, copy) NSString *groupSpellPrice;

// /商品的名称
@property (nonatomic, copy) NSString *commodityName;

// 商品的首图
@property (nonatomic, copy) NSString *commodityHeadImg;

// 商品的描述
@property (nonatomic, copy) NSString *commodityDescribe;

// 商品的详情图
@property (nonatomic, copy) NSString *commodityDetailsImg;

// 店家电话
@property (nonatomic, copy) NSString *storePhone;

// 店家的地址
@property (nonatomic, copy) NSString *storeAddress;

// 经度
@property (nonatomic, assign) CGFloat latitude;

// 纬度
@property (nonatomic, assign) CGFloat longitude;

// 到期时间
@property (nonatomic, strong) NSString *endTime;

// 是否参加活动
@property (nonatomic, assign) BOOL isJoin;

// 头像集合
@property (nonatomic, strong) NSArray *headImgS;

@end

NS_ASSUME_NONNULL_END
