//
//  ZYSmallShopPayModel.h
//  Community
//
//  Created by ZY on 2022/3/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYSmallShopPayModel : NSObject

// 微信支付跳转前所需的部分数据
// 微信固定值
@property (nonatomic, copy) NSString *package;

// appid
@property (nonatomic, copy) NSString *appid;

// 签名
@property (nonatomic, copy) NSString *sign;

// 商户id
@property (nonatomic, copy) NSString *partnerid;

// 预付款id
@property (nonatomic, copy) NSString *prepayid;

// 随机字符串
@property (nonatomic, copy) NSString *noncestr;

// 时间戳
@property (nonatomic, copy) NSString *timestamp;


// 支付宝支付跳转前所需的部分数据
@property (nonatomic,strong) NSString *orderStr;

@end

NS_ASSUME_NONNULL_END
