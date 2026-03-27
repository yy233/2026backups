//
//  BusinessServicesData.m
//  Community
//
//  Created by 余莹 on 2021/4/2.
//

#import "BusinessServicesData.h"
#import "BusinesServicePayDataModel.h"
#import "BuniessWillPayGetOrderViewModel.h"

@implementation BusinessServicesData


//让后台做这个订单
+ (void)creatOrderWithDic:(NSMutableDictionary *)getJsDic with:(BaseDicAndSuccessBoolBlock)dicBlock{
    Y_SVP_SHOW_MES_IsDealing_15Delay
    NSString *url = @"services/order/order/saveOrder";
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueueWtihBuniessShopTypeUrl:url withParams:getJsDic finished:^(id responsObject, NSError *error) {
        Y_SVP_DISMISS
        BaseDicAndSuccessBoolBlock block = dicBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;//订单全部数据
                Y_SVP_SHOW_SUCCESS_MES(@"已提交订单");
                block(dic,YES);
            }else{
                block(@{},NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@{},NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
#pragma mark ==  拿到订单信息 作支付

+ (void)shopOrderInfoToPayWithJsGetDic:(NSMutableDictionary *)jsGetDic andOrderInfo:(NSMutableDictionary *)orderInfoDic with:(BaseDicAndSuccessBoolBlock)block{
    Y_SVP_SHOW_MES(@"正在调起支付");
    BusinesServicePayDataModel *model = [BusinesServicePayDataModel mj_objectWithKeyValues:jsGetDic];
    switch ( model.deliveryWay ) {
        case PayTool_ThisPay_Type_WeChat://微信
            {
                [self goWeChatPayWithJsGetDic:jsGetDic andOrderInfo:orderInfoDic with:block];
            }
            break;
        case PayTool_ThisPay_Type_ZFB://支付宝
            {
                [self goZFBPayWithJsGetDic:jsGetDic andOrderInfo:orderInfoDic with:block];
            }
            break;
        case PayTool_ThisPay_Type_YuE://余额
            {
            }
            break;
        case PayTool_ThisPay_Type_BankCard://银行卡
            {
            }
            break;
            
        default:
            
            break;
    }
}
#pragma mark ===
+ (void)goWeChatPayWithJsGetDic:(NSMutableDictionary *)jsGetDic andOrderInfo:(NSMutableDictionary *)orderInfoDic with:(BaseDicAndSuccessBoolBlock)block{
    BusinesServicePayDataModel *model = [BusinesServicePayDataModel mj_objectWithKeyValues:jsGetDic];
    
    //[WeChatPayData weChatPayOfOrderNumStr:self.dataOrderIdStr];//  20220406改版
      
      
      /**
        20220406改版  暂未  **/
       
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [BuniessWillPayGetOrderViewModel willWeChatPayMoneyNum:model.deliveryFee withPayOrderType:PayOrder_Type_Shopping  withDescriptionStr:[TextShowWithModelStr textShowWithModelStr:model.storeName]     withOrderData:orderInfoDic withGetOrderInfo:^(WillPayOrderInfoModel * model, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            
            PayReq *req   = [[PayReq alloc] init];
            req.openID = [TextShowWithModelStr textShowWithModelStr:model.appid] ;                   //商家id
            req.nonceStr  = [TextShowWithModelStr textShowWithModelStr:model.noncestr];
            req.timeStamp = [[TextShowWithModelStr textShowWithModelStr:model.timestamp] intValue];  //时间戳
            req.package   = [TextShowWithModelStr textShowWithModelStr:model.package];
            req.partnerId = [TextShowWithModelStr textShowWithModelStr:model.partnerid];
            req.prepayId  = [TextShowWithModelStr textShowWithModelStr:model.prepayid];
            req.sign      = [TextShowWithModelStr textShowWithModelStr:model.sign];
            dispatch_async( dispatch_get_main_queue(), ^{
                [[WeChatPayManager shareManager] hangleWechatPayWithPayReq:req];  //gowx
            });
            block(@{},YES);
        }else{
            block(@{},NO);
        }
    }];
}
#pragma mark ===
+ (void)goZFBPayWithJsGetDic:(NSMutableDictionary *)jsGetDic andOrderInfo:(NSMutableDictionary *)orderInfoDic with:(BaseDicAndSuccessBoolBlock)block{
    BusinesServicePayDataModel *model = [BusinesServicePayDataModel mj_objectWithKeyValues:orderInfoDic];
    
    Y_SVP_SHOW_MES_IsDealing_15Delay
    [BuniessWillPayGetOrderViewModel willZFBPayMoneyNum:model.deliveryFee withPayOrderType:PayOrder_Type_Shopping withOrderData:orderInfoDic  withGetOrderInfo:^(WillPayOrderInfoModel * model, BOOL success) {
    Y_SVP_DISMISS
        if (success) {
            NSString *zfbOrderStr = [TextShowWithModelStr textShowWithModelStr:model.orderStr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[ZfbPayManager shareManager] hangleZFPayOrderStr:zfbOrderStr];
            });
            block(@{},YES);
        }else{
            block(@{},NO);
        }
    }];
}
@end
