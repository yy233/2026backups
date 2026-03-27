//
//  ZYPositioningModel.h
//  Community
//
//  Created by ZY on 2021/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYPositioningModel : NSObject

// 经度
@property (nonatomic, assign) CGFloat latitude;

// 纬度
@property (nonatomic, assign) CGFloat longitude;

// 国家
@property (nonatomic, copy) NSString *country;

// 市
@property (nonatomic, copy) NSString *locality;

// 区
@property (nonatomic, copy) NSString *subLocality;

// 街道
@property (nonatomic, copy) NSString *thoroughfare;

// 子街道
@property (nonatomic, copy) NSString *subThoroughfare;

// 地名
@property (nonatomic, copy) NSString *name;

// 邮编
@property (nonatomic, copy) NSString *postalCode;

// 国家编码
@property (nonatomic, copy) NSString *ISOcountryCode;

// 详细地址
@property (nonatomic, copy) NSString *detailAddress;

@end

NS_ASSUME_NONNULL_END
