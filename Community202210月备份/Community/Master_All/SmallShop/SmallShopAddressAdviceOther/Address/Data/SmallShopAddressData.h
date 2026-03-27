//
//  SmallShopAddressData.h
//  Community
//
//  Created by 余莹 on 2022/3/11.
//

#import <Foundation/Foundation.h>
#import "SmallShopAddressInfoHeader.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^SmallShopAddressInfoBlock)(SmallShopAddressInfoModel *addressInfoModel ,BOOL isHaveBool);//是否有数据的bool

@interface SmallShopAddressData : NSObject
#pragma mark ==== 总查询
//查询当前默认地址一个地址model
+ (void)smallShopNomalFirstAddressAndPhoneWithBlock:(SmallShopAddressInfoBlock)block;
//查询小店已添加或使用的地址列表
+ (void)smallShopAddressInfoHaveUsedListWithArrBlock:(BaseListArrAndSuccessBoolBlock)block;

#pragma mark ==== 新增
+ (void)smallShopAddressAddNewInfoModel:(SmallShopAddressInfoModel *)model withBlock:(BaseDicAndSuccessBoolBlock)block;

#pragma mark ==== 删除
+ (void)smallShopAddressDeletOneInfoModel:(SmallShopAddressInfoModel *)model withBlock:(BaseDicAndSuccessBoolBlock)block;

#pragma mark ==== 使用此地址｜即 使用地址修改顺序
+ (void)smallShopAddressUseThisOneInfoModel:(SmallShopAddressInfoModel *)model withBlock:(BaseDicAndSuccessBoolBlock)block;
 
 @end

NS_ASSUME_NONNULL_END
