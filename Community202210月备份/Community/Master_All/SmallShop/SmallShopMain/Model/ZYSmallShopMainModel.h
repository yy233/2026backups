//
//  ZYSmallShopMainModel.h
//  Community
//
//  Created by ZY on 2022/3/10.
//

#import <Foundation/Foundation.h>
#import "ZYSmallShopGoodsSpellGroupDetailModel.h"

@class ZYSmallShopMainValue1Model, ZYSmallShopMainValue3Model, ZYSmallShopMainValue3RecordsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopMainModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger size;

// 门店门头图
@property (nonatomic, copy) NSString *value0;

// 模块化数组
@property (nonatomic, strong) NSArray<ZYSmallShopMainValue1Model *> *value1;

// 拼团活动
@property (nonatomic, strong) ZYSmallShopGoodsSpellGroupDetailModel *value2;

// 热门数据
@property (nonatomic, strong) ZYSmallShopMainValue3Model *value3;

//当前店铺id
@property (nonatomic, copy) NSString *value4;
//imid
@property (nonatomic, copy) NSString *value5;
//当前店铺的电话 地址

@end


@interface ZYSmallShopMainValue1Model : NSObject <YYModel>

// 模板类型 1商品 2服务 3货柜
@property (nonatomic, assign) NSInteger moduleType;

// 模块id
@property (nonatomic, copy) NSString *ID;

// 模块标题
@property (nonatomic, copy) NSString *moduleTitle;

// 模块宣传
@property (nonatomic, copy) NSString *modulePublicity;

// 模块图片
@property (nonatomic, copy) NSString *moduleImg;

@end

@interface ZYSmallShopMainValue3Model : NSObject <YYModel>

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) NSInteger current;

@property (nonatomic, strong) NSArray<ZYSmallShopMainValue3RecordsModel *> *records;

@end


@interface ZYSmallShopMainValue3RecordsModel : NSObject <YYModel>

// 商品id
@property (nonatomic, copy) NSString *ID;

// 店铺id
@property (nonatomic, copy) NSString *storeId;

// 社区id
@property (nonatomic, copy) NSString *communityId;

// 商品名
@property (nonatomic, copy) NSString *commodityName;

// 活动类型 0没有活动 1打折 满减 3满送 4拼团
@property (nonatomic, assign) NSInteger activityType;

// 活动名
@property (nonatomic, copy) NSString *activityName;

// 原价
@property (nonatomic, copy) NSString *commodityOriginalPrice;

// 卖价
@property (nonatomic, copy) NSString *commoditySellPrice;

// 图片
@property (nonatomic, copy) NSString *commodityHeadImg;

// 热销
@property (nonatomic, assign) NSInteger selling;

// 热销
@property (nonatomic, assign) NSInteger commodityInventedSales;

// 类型 1商品 2服务 3智能柜
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
