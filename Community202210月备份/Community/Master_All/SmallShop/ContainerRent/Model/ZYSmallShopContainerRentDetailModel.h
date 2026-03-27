//
//  ZYSmallShopContainerRentDetailModel.h
//  Community
//
//  Created by ZY on 2022/3/11.
//

#import <Foundation/Foundation.h>

@class ZYSmallShopContainerRentDetailCabinetModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopContainerRentDetailModel : NSObject <YYModel>

// 智能柜id
@property (nonatomic, copy) NSString *ID;

// 尺寸
@property (nonatomic, copy) NSString *volume;

// 标题
@property (nonatomic, copy) NSString *title;

// 描述
@property (nonatomic, copy) NSString *detail;

@property (nonatomic, assign) BOOL isHiddenRemainDay;

// 租期到期天数
@property (nonatomic, assign) NSInteger remainDay;

// 编号
@property (nonatomic, copy) NSString *cabinetNumber;

// 图片
@property (nonatomic, copy) NSString *cabinetImg;

// 类型：1商品 2服务 3智能柜
@property (nonatomic, assign) NSInteger type;

// 手机号
@property (nonatomic, copy) NSString *storePhone;

// 社区小店地址
@property (nonatomic, copy) NSString *storeAddress;

// 经度
@property (nonatomic, assign) CGFloat latitude;

// 纬度
@property (nonatomic, assign) CGFloat longitude;

// 租用费用规则
@property (nonatomic, strong) NSArray<ZYSmallShopContainerRentDetailCabinetModel *> *cabinetPriceDtos;

@end


@interface ZYSmallShopContainerRentDetailCabinetModel : NSObject <YYModel>

// 收费id
@property (nonatomic, copy) NSString *ID;

// 智能柜id
@property (nonatomic, copy) NSString *cabinetId;

// 原价
@property (nonatomic, copy) NSString *cabinetPriceOriginal;

// 售价
@property (nonatomic, copy) NSString *cabinetPriceSell;

// 类型 1月租 2季度 3半年 4年度
@property (nonatomic, assign) NSInteger cabinetPriceStatus;

@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
