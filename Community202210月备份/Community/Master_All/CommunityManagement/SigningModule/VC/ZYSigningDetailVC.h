//
//  ZYSigningDetailVC.h
//  Community
//
//  Created by ZY on 2021/8/18.
//  租赁签约

#import <UIKit/UIKit.h>
#import "HouseRentDetailVcHouseModel.h"
#import "HouseRentDetailVcBuniessShopModelShopModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYSigningDetailVC : ZYBaseViewController

// 签约id
@property (nonatomic, copy) NSString *contractId;

// 身份类型 1:房东 2:租客
@property (nonatomic, assign) NSInteger identityType;

// 资产id
@property (nonatomic, strong) NSString *assetId;

// 资产类型 1:商铺 2:房屋
@property (nonatomic, assign) NSInteger assetType;

// 房屋详情
@property (nonatomic, strong) HouseRentDetailVcHouseModel *houseDetailModel;

// 商铺详情
@property (nonatomic, strong) HouseRentDetailVcBuniessShopModelShopModel *shopDetailModel;

// 是否我的租赁详情入口
@property (nonatomic, assign) BOOL isRentDetail;

@end

NS_ASSUME_NONNULL_END
