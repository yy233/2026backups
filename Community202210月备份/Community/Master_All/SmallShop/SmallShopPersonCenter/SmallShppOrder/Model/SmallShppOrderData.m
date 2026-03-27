//
//  SmallShppOrderData.m
//  Community
//
//  Created by 余莹 on 2022/3/10.
//

#import "SmallShppOrderData.h"

static NSString *const kOrderDetailData_Goods_Url =     @"orderCommodity/selectCommodityOrder";
static NSString *const kOrderDetailData_Service_Url =   @"orderServe/selectServeOrder";
static NSString *const kOrderDetailData_Box_Url =       @"order/selectOrderCabinetByOrderId";


@implementation SmallShppOrderData


+ (void)getOrderDetailInfoWithThisType:(SmallShopOrderDetailVC_Type)orderType andOrderId:(NSInteger)orderId withBlock:(BaseDicAndSuccessBoolBlock)block{
 
    switch (orderType) {
        case SmallShopOrderDetailVC_Type_Goods:
            [self goodsOrderDetailWithId:orderId withBlock:block];
            break;
        case SmallShopOrderDetailVC_Type_Service:
            [self serviceOrderDetailWithId:orderId withBlock:block];
            break;
            
        case SmallShopOrderDetailVC_Type_Container:
            [self boxOrderDetailWithId:orderId withBlock:block];
            break;
            
        default:
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_MES(@"订单类型有误");
            });
        }
          
            break;
    }
}


//商品订单详情
+ (void)goodsOrderDetailWithId:(NSInteger)orderId withBlock:(BaseDicAndSuccessBoolBlock)block{
    

    NSDictionary *parms = @{
        @"orderId":@(orderId)
//        @"orderId":@(1498867333884018692)
    };
    
     [[ToolOfNetWork sharedTools]YrequestPostAllLongURLNoMainQueueWithBodyNotParms:Y_SmallShop_URL_AllLongURL(kOrderDetailData_Goods_Url)  withBody:parms.mutableCopy finished:^(id responsObject, NSError *error) {
          if (isNotNil(responsObject)) {
              if (Y_IS_Success) {
                  block(Y_ResponsObject_dataDic,YES);
              }else{
                  block(@{},NO);
                  dispatch_async(dispatch_get_main_queue(), ^{
                      Y_SVP_SHOW_ERR_MESSAGE
                  });
              }
          }else{
              block(@{},NO);
              dispatch_async(dispatch_get_main_queue(), ^{
                  Y_SVP_SHOW_ERR_DESCRIPTION
              });
          }
      }];
  
}

//服务订单详情
+ (void)serviceOrderDetailWithId:(NSInteger)orderId withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSDictionary *parms = @{
        @"orderId":@(orderId)
//        @"orderId":@(165203043829288960)
    };
    
     [[ToolOfNetWork sharedTools]YrequestPostAllLongURLNoMainQueueWithBodyNotParms:Y_SmallShop_URL_AllLongURL(kOrderDetailData_Service_Url)  withBody:parms.mutableCopy finished:^(id responsObject, NSError *error) {
          if (isNotNil(responsObject)) {
              if (Y_IS_Success) {
                  block(Y_ResponsObject_dataDic,YES);

              }else{
                  block(@{},NO);
                  dispatch_async(dispatch_get_main_queue(), ^{
                      Y_SVP_SHOW_ERR_MESSAGE
                  });
              }
          }else{
              block(@{},NO);
              dispatch_async(dispatch_get_main_queue(), ^{
                  Y_SVP_SHOW_ERR_DESCRIPTION
              });
          }
      }];
}

//货柜订单详情
+ (void)boxOrderDetailWithId:(NSInteger)orderId withBlock:(BaseDicAndSuccessBoolBlock)block{
    NSDictionary *parms = @{
        @"orderId":@(orderId)
//        @"orderId":@(1501406918178533378)

    };
    [[ToolOfNetWork sharedTools]YrequestGetALLURL:Y_SmallShop_URL_AllLongURL(kOrderDetailData_Box_Url)  withParams:parms.mutableCopy  finished:^(id responsObject, NSError *error) {
 
          if (isNotNil(responsObject)) {
              if (Y_IS_Success) {
                  block(Y_ResponsObject_dataDic,YES);

              }else{
                  block(@{},NO);
                  dispatch_async(dispatch_get_main_queue(), ^{
                      Y_SVP_SHOW_ERR_MESSAGE
                  });
              }
          }else{
              block(@{},NO);
              dispatch_async(dispatch_get_main_queue(), ^{
                  Y_SVP_SHOW_ERR_DESCRIPTION
              });
          }
      }];
}



@end
