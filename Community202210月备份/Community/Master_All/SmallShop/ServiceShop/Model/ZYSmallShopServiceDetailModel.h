//
//  ZYSmallShopServiceDetailModel.h
//  Community
//
//  Created by ZY on 2022/3/11.
//

#import <Foundation/Foundation.h>
#import "ZYSmallShopGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopServiceDetailModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *communityId;

@property (nonatomic, copy) NSString *serveName;

@property (nonatomic, copy) NSString *serveOriginalPrice;

@property (nonatomic, copy) NSString *serveSellPrice;

@property (nonatomic, copy) NSString *serveHeadImg;

@property (nonatomic, copy) NSString *serveDetailsImg;

@property (nonatomic, copy) NSString *serveDescribe;

@property (nonatomic, strong) ZYSmallShopGoodsDetailDataInfoModel *informationDto;

@end

NS_ASSUME_NONNULL_END
