//
//  WillPayOrderInfoModel.h
//  Community
//
//  Created by 余莹 on 2021/3/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WillPayOrderInfoModel : NSObject
/**
 微信支付跳转前所需的部分数据
 */
@property (nonatomic,strong) NSString *appid;
@property (nonatomic,strong) NSString *partnerid;
@property (nonatomic,strong) NSString *prepayid;
@property (nonatomic,strong) NSString *package;
@property (nonatomic,strong) NSString *noncestr;
@property (nonatomic,strong) NSString *timestamp;
@property (nonatomic,strong) NSString *sign;
@property (nonatomic,strong) NSString *orderNum;//用于后续add

/**
 支付宝支付跳转前所需的部分数据
 */
//@property (nonatomic,strong) NSString *orderNum;//用于成功后后台add订单键值 同wx
@property (nonatomic,strong) NSString *orderStr;//用于支付宝的长串
 
 


/**
 //微信
 message": null,
     "data": {
         "appid": "wxe84d22f50370bbda",
         "partnerid": "1605856544",
         "prepayid": "wx111539457371775a4a9da938ff38560000",
         "package": "Sign=WXPay",
         "noncestr": "5eb94a1f6e0b4bbeaa823766ff526724",
         "timestamp": "1615448386",
         "sign": "0L/fqiTOetCUzJW7PD2UiEu2eQctsLxCKl3wfsxcsxbs4RyaiT1sqZwlOWRfsO6zQp9MxMIxwmODZzji5Qz615GaejJ4SK7Nw1e88TVxDXwgxn66MmvyP0/0aV0XAPhMJQZnd/nivKKOctt3OtFnRpNf2PAU/11VG1LE2PDBIEbt0hTtAb2RVchZOzFhnED4YHyiKGyw1QrlxGcV6Q8KY7/6s1uS4yukURN59LgisQxSi8Qy6JvjGo1VYt1C/++W7w7EV6WG6r9pwP9ExcXoY5Kn636Jod2CVqwu97JOAumAsc4tqQz9DFCuLkbXlupumLZGSv9eTqrfTsc4zkNhlA==",
         "orderNum": "202103111539454256939451"
     }
 //支付宝
 url= v1/payment/alipay/order____{
    code = 0;
    data =     {
        orderNum = 202103171133432208450441;
        orderStr = "alipay_root_cert_sn=687b59193f3f462dd5336e5abf83c5d8_02941eef3187dddf3d3b83462e1dfcf6&alipay_sdk=alipay-easysdk-java&app_cert_sn=ab0bdd0003d255606eee0f61f0743f19&app_id=2021002119679359&biz_content=%7B%22total_amount%22%3A%220.01%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%2C%22subject%22%3A%22%E6%88%BF%E5%B1%8B%E7%A7%9F%E9%87%91%22%2C%22out_trade_no%22%3A%22202103171133432208450441%22%2C++%7D&charset=utf-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2F222.178.212.29%3A9951%2Fapi%2Fv1%2Fpayment%2FcallBack%2Fpay&sign=Uiq0EzWb5kdIiwUUpdfTTJjUbihVghjp3ZH2%2FnMA8DqTAjJqQjtkIMtsDyAjVVZ%2FMSd7Vn479%2BAxyoI6cvNLlFHCe4nX8eqpAO1OMpIZlZA9Osw2yZazLpFZkZ9a3tThiJHED8lp8ToFupHVSeCDYlOcUu9p6v6smtRhZgWrLQg64u%2Ftb1wcjU8HO%2F993g2CYhODwFwtQONuw0dXgljOUb5tVlIif%2FFNubfSzynDEHhQgkwe9lj5JDiNKdL7jY4G8pWf%2FH43zfU6NyxSSGfuh70yrOlPBVSk9z6PVaK1kqk7YfdW4kunfBr7BvYcwdf0CX9KGzSsEkeO%2FnvNyHAXMw%3D%3D&sign_type=RSA2&timestamp=2021-03-17+11%3A33%3A43&version=1.0";
    };
    message = "下单成功";
};
}
(lldb)
 */
@end

NS_ASSUME_NONNULL_END
