//
//  ZYLifeCostHouseholdUploadModel.h
//  Community
//
//  Created by ZY on 2022/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYLifeCostHouseholdUploadModel : NSObject

// 户号
@property (nonatomic, copy) NSString *account;

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

// 公司ID
@property (nonatomic, copy) NSString *companyId;

// 公司名称
@property (nonatomic, copy) NSString *company;

// 分类id
@property (nonatomic, copy) NSString *categoryId;

// 类型ID
@property (nonatomic, copy) NSString *typeId;

// 类型名称
@property (nonatomic, copy) NSString *typeName;

// 项目id
@property (nonatomic, copy) NSString *itemId;

// 项目编码
@property (nonatomic, copy) NSString *itemCode;

// 业务流程 0：先查后缴1：直接缴费2：二次查询
@property (nonatomic, copy) NSString *businessFlow;

// 终端类型 1-PC个人电脑 2-手机终端 3-微信公众号 4-支付宝 5-微信小程序
@property (nonatomic, copy) NSString *deviceType;

@end

NS_ASSUME_NONNULL_END
