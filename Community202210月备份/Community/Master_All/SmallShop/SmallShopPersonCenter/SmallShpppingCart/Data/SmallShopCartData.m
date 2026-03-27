//
//  SmallShopCartData.m
//  Community
//
//  Created by 余莹 on 2022/3/7.
//

#import "SmallShopCartData.h"

//base
#define  Cart_Url                         @"zhsj/cabinet/"
//购物车 删除
static NSString *const kCartDelData_Url = @"car/delCarIds";
//购物车单种 数量更改
static NSString *const kCartChangeCount_Url = @"car/updateCar";
//拿到某商品在某数量时的价格等信息
static NSString *const kCartGetOneGoosMoney_Url = @"order/getOrderPayMoney";

//单种订单
static NSString *const kOneGoodsSeiveceBoxCreartOrder_Url  = @"order/insertOrder";
//购物车订单
static NSString *const kCartCreartOrder_Url   = @"order/insertCarOrder";

//超时处理或订单删除接口
static NSString *const kDeletNotPayOrder_Url  = @"order/deleteByOrderNumber";

 

@implementation SmallShopCartData
//删除
+ (void)myCartDelInfoWithIdArrs:(NSMutableArray *)idArrs withBlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YrequestPostAllLongURLNoMainQueueWithBodyNotParms:[NSString stringWithFormat:@"%@%@%@",BASE_URL_OnlyAsOfPort,Cart_Url,kCartDelData_Url] withBody:idArrs finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
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


 
//更改数量（购物车内更改）
+ (void)myCartchangeOneGoodsCountNumWithId:(NSString *)goodsId withNowCount:(NSInteger)nowCount withBlock:(BaseDicAndSuccessBoolBlock)block{ 
    
    NSDictionary *parms = @{
        @"commodityId":goodsId,
        @"commodityNumber":@(nowCount)
    };

    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:[NSString stringWithFormat:@"%@%@%@",BASE_URL_OnlyAsOfPort,Cart_Url,kCartChangeCount_Url]
                                                     withParams:parms.mutableCopy
                                                       finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
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



//拿到某商品在某数量时的价格等信息
+ (void)myCartChangeCountOfGetMoneyInfoWithOneGoodsID:(NSString *)goodsId withNowCount:(NSInteger)nowCount withBlock:(BaseDicAndSuccessBoolBlock)block{
    if (goodsId.length <=0) {
        Y_SVP_SHOW_ERR_MES(@"商品信息错误！数量增加减少不可操作")
        return;
    }
    NSDictionary *parms = @{
        @"commodityId":goodsId,
        @"commodityNumber":@(nowCount)
    };
    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:[NSString stringWithFormat:@"%@%@%@",BASE_URL_OnlyAsOfPort,Cart_Url,kCartGetOneGoosMoney_Url]
                                                     withParams:parms.mutableCopy
                                                       finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
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
 
////（结算页更改更改数量—— 都是钱的数据 不在car加数量）
//+ (void)myCartDetailOrOneGoodsPayVcGetMoneyInfoWithOneGoodsID:(NSInteger)goodsId withNowCount:(NSInteger)nowCount withBlock:(BaseDicAndSuccessBoolBlock)block{
//    
//    NSDictionary *parms = @{
//        @"commodityId":@(goodsId),
//        @"commodityNumber":@(nowCount)
//    };
//
//    [[ToolOfNetWork sharedTools]YYrequestALLURLPostNotMainQueue:[NSString stringWithFormat:@"%@%@%@",BASE_URL_OnlyAsOfPort,Cart_Url,kCartChangeCount_Url]
//                                                     withParams:parms.mutableCopy
//                                                       finished:^(id responsObject, NSError *error) {
//        if (isNotNil(responsObject)) {
//            if (Y_IS_Success) {
//                NSDictionary *dic = Y_ResponsObject_dataDic;
//                block(dic,YES);
//            }else{
//                block(@{},NO);
//                Y_SVP_SHOW_ERR_MESSAGE
//            }
//        }else{
//            block(@{},NO);
//            Y_SVP_SHOW_ERR_DESCRIPTION
//        }
//    }];
//}
#pragma mark === 订单生成部分
 

//单种 商品/服务/货柜/订单 -> 生成订单  kOneGoodsSeiveceBoxCreartOrder_Url
+ (void)oneGoodSeiviceBoxCreatOrderWithInfoDic:(NSMutableDictionary *)infoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
    [[ToolOfNetWork sharedTools]YrequestPostAllLongURLNoMainQueueWithBodyNotParms:Y_SmallShop_URL_AllLongURL(kOneGoodsSeiveceBoxCreartOrder_Url)  withBody:infoDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
//                NSDictionary *dic = Y_ResponsObject_dataDic;
                NSDictionary *dic = @{@"order":Y_ResponsObject_dataStr};
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
 
//购物车单种多种货物 -> 生成订单   kCartCreartOrder_Url
+ (void)cartCreatOrderWithCartDetailInfoDic:(NSMutableDictionary *)infoDic withBlock:(BaseDicAndSuccessBoolBlock)block{
    
    [[ToolOfNetWork sharedTools]YrequestPostAllLongURLNoMainQueueWithBodyNotParms:Y_SmallShop_URL_AllLongURL(kCartCreartOrder_Url)  withBody:infoDic finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
//                NSDictionary *dic = Y_ResponsObject_dataDic;
                NSDictionary *dic = @{@"order":Y_ResponsObject_dataStr};
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


//超时处理或订单删除接口
+ (void)deletOrderWithOrderStr:(NSString *)orderStr withBlock:(BaseDicAndSuccessBoolBlock)block{
//    kDeletNotPayOrder_Url
    NSString *allUrl = [NSString stringWithFormat:@"%@?orderNumber=%@",Y_SmallShop_URL_AllLongURL(kDeletNotPayOrder_Url),orderStr];
//    [[ToolOfNetWork sharedTools]YYrequestALLURLGetNotMainQueue:Y_SmallShop_URL_AllLongURL(kDeletNotPayOrder_Url) withParams:@{@"orderId" : orderStr }.mutableCopy finished:^(id responsObject, NSError *error) {
    
    [[ToolOfNetWork sharedTools]YYrequestALLURLGetNotMainQueue:allUrl withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {

        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *dic = Y_ResponsObject_dataDic;
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
@end
