//
//  WeChatPayData.h
//  Community
//
//  Created by 余莹 on 2022/4/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeChatPayData : NSObject


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


//用订单str去调起微信支付
//+ (void)weChatPayOfOrderNumStr:(NSString *)orderStr;

//停车缴费
+ (void)weChatPayOfCarParkingUseIdStr:(NSString *)idStr;

//生活缴费 Id组 去调起微信支付
+ (void)weChatPayOfLiftCostIdStrArr:(NSArray *)idStrArr;

@end

NS_ASSUME_NONNULL_END
