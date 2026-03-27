//
//  ZYSmallShopServiceModel.h
//  Community
//
//  Created by ZY on 2022/3/10.
//

#import <Foundation/Foundation.h>

@class ZYSmallShopServiceRecordsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopServiceModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) NSInteger size;

@property (nonatomic, assign) NSInteger current;

@property (nonatomic, strong) NSArray<ZYSmallShopServiceRecordsModel *> *records;

@end


@interface ZYSmallShopServiceRecordsModel : NSObject <YYModel>

// 服务id
@property (nonatomic, copy) NSString *ID;

// 店铺id
@property (nonatomic, copy) NSString *storeId;

// 社区id
@property (nonatomic, copy) NSString *communityId;

// 服务名
@property (nonatomic, copy) NSString *serveName;

// 原价
@property (nonatomic, copy) NSString *serveOriginalPrice;

// 卖价
@property (nonatomic, copy) NSString *serveSellPrice;

// 图片
@property (nonatomic, copy) NSString *serveHeadImg;

@end

NS_ASSUME_NONNULL_END
