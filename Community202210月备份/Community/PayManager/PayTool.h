//
//  PayTool.h
//  Community
//
//  Created by 余莹 on 2021/3/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//____ 总 支付方式类型
typedef enum : NSUInteger {
    PayTool_ThisPay_Type_WeChat   =1,
    PayTool_ThisPay_Type_ZFB      =2,
    PayTool_ThisPay_Type_YuE      =3,
    PayTool_ThisPay_Type_BankCard =4,
} PayTool_ThisPay_Type;
//  1微信支付，2支付宝支付，3账户余额，4其他银行卡

//____ 微信 支付订单类型
//微信 ---- 支付描述 1.充值提现2.商城购物3.水电缴费4.物业管理5.房屋租金6.红包7.红包退回 8.停车缴费 9.签章租赁 10.临时车辆缴费
//支付宝---  交易来源 1.充值提现2.商城购物3.水电缴费4.物业管理5.房屋租金6.红包7.红包退回 9.签章租赁 10.临时车辆缴费
typedef enum : NSUInteger {
    PayOrder_Type_ChongZhiTiXian =1,
    PayOrder_Type_Shopping       =2,
    PayOrder_Type_LifeCost       =3,
    PayOrder_Type_LifeCostWuYe   =4,
    PayOrder_Type_HouseRent      =5,
    PayOrder_Type_RedBao         =6,
    PayOrder_Type_RedBaoBack     =7,
    payOrder_Type_ParkCar        =8,
    payOrder_Type_SigningRent    =9,
    payOrder_Type_ParkCar_Temp   =10,
} ALL_PayOrder_Type;
@interface PayTool : NSObject
/**
 [userInfoDic  Pay_Success_PayType_Key        //  1微信支付，2支付宝支付，3账户余额，4其他银行卡
 Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(PaySuccessedEndInfo_Notice_Name, userInfoDic);
 */
@end

NS_ASSUME_NONNULL_END
