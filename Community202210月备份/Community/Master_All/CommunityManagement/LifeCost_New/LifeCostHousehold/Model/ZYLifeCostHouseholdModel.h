//
//  ZYLifeCostHouseholdModel.h
//  Community
//
//  Created by ZY on 2022/1/7.
//

#import <Foundation/Foundation.h>

@class ZYLifeCostHouseholdListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYLifeCostHouseholdModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *uid;

// 分组名
@property (nonatomic, copy) NSString *groupName;

@property (nonatomic, strong) NSArray<ZYLifeCostHouseholdListModel *> *accountEntityList;

@end


@interface ZYLifeCostHouseholdListModel : NSObject <YYModel>

// 数据ID
@property (nonatomic, copy) NSString *ID;

// 用户uid
@property (nonatomic, copy) NSString *uid;

// 分组ID
@property (nonatomic, copy) NSString *groupId;

// 省份ID
@property (nonatomic, copy) NSString *provinceId;

// 城市ID
@property (nonatomic, copy) NSString *cityId;

// 城市code
@property (nonatomic, copy) NSString *cityCode;

// 城市名称
@property (nonatomic, copy) NSString *cityName;

// 户号
@property (nonatomic, copy) NSString *account;

// 户主名称
@property (nonatomic, copy) NSString *householder;

// 地址
@property (nonatomic, copy) NSString *address;

// 公司ID
@property (nonatomic, copy) NSString *companyId;

// 公司名称
@property (nonatomic, copy) NSString *company;

// 分类ID
@property (nonatomic, copy) NSString *categoryId;

// 分类
@property (nonatomic, copy) NSString *category;

// 缴费类型ID
@property (nonatomic, copy) NSString *typeId;

// 类型名称
@property (nonatomic, copy) NSString *typeName;

// 项目ID
@property (nonatomic, copy) NSString *itemId;

// 项目code
@property (nonatomic, copy) NSString *itemCode;

// 类型图标
@property (nonatomic, copy) NSString *typePicUrl;

// 业务流程 0：先查后缴 1：直接缴费 2：二次查询;不同的业务流程,需要跳不同的页面,走不同的接口
@property (nonatomic, copy) NSString *businessFlow;

// 终端类型 1-PC个人电脑 2-手机终端 3-微信公众号 4-支付宝 5-微信小程序
@property (nonatomic, copy) NSString *deviceType;

@end

NS_ASSUME_NONNULL_END
