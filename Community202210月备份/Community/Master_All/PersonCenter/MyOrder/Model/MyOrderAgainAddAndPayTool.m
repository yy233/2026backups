//
//  MyOrderAgainAddAndPayTool.m
//  Community
//
//  Created by 余莹 on 2021/5/29.
//

#import "MyOrderAgainAddAndPayTool.h"
#import "BusinessServicesData.h"
@implementation MyOrderAgainAddAndPayTool
+ (void)againPayWithOrderModel:(MyOrderModel *)model{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:[TextShowWithModelStr textShowWithModelStr:model.address] forKey:@"addressUuid"];
    [parms setValue:@(model.deliveryFee) forKey:@"deliveryFee"];
    [parms setValue:@(model.deliveryWay) forKey:@"deliveryWay"];
    [parms setValue:[TextShowWithModelStr textShowWithModelStr:model.orderMessage] forKey:@"orderMessage"];
    [parms setValue:[TextShowWithModelStr textShowWithModelStr:model.shopUuid] forKey:@"shopUuid"];
    [parms setValue:[TextShowWithModelStr textShowWithModelStr:model.uuid] forKey:@"userRedpacket"];

    [self shopCreadOrderWithGetJsDic:parms];
    
}
//复用商铺主页的结算部分接口
#pragma mark === 支付订单新增
+ (void)shopCreadOrderWithGetJsDic:(NSMutableDictionary *)parms{
    NSLog(@"---%@---",parms);
    if ( ![[parms allKeys] containsObject:@"storeName"]) {//微信所需要的描述文本"
        [parms setValue:@"wx" forKey:@"storeName"];
    }
  [BusinessServicesData creatOrderWithDic:parms with:^(NSDictionary * dic, BOOL success) {
        if (success) {
            [self shopToPayThisOrderWithJsGetDic:parms withOrderInfoDic:dic.mutableCopy];
        }
    }];
}
#pragma mark === 支付订单已加 处理多种支付方式
+ (void)shopToPayThisOrderWithJsGetDic:(NSMutableDictionary *)jsGetDic withOrderInfoDic:(NSMutableDictionary *)dic{
    /**结算 支付 相关*/
    [BusinessServicesData shopOrderInfoToPayWithJsGetDic:jsGetDic andOrderInfo:dic   with:^(NSDictionary * dic, BOOL success) {
        if (success) {
            DLog(@"");//得到系统安排的订单数据-做支付-等待notice
        };
    }];
}
@end
