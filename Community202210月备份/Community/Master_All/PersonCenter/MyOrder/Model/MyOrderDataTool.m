//
//  MyOrderData.m
//  Community
//
//  Created by 余莹 on 2021/5/20.
//

#import "MyOrderDataTool.h"

#define MyOrderList_Url_Type_All                              @"services/order/order/pageUserState"
 
@implementation MyOrderDataTool

//+ (void)getAllOrDerListWithPageNum:(NSInteger)pageNum withBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
//    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
//    [parms setValue:@(pageNum) forKey:@"rows"];
//    [parms setValue:@(Y_PAGE_SIZE) forKey:@"total"];
//    
//}


//+ (void)getAllOrderListWithBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
//    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueueWtihBuniessShopTypeUrl:MyOrderList_Url_Type_All withParams:@{}.mutableCopy finished:^(id responsObject, NSError *error) {
//        BaseListArrAndSuccessBoolBlock block = listBlock;
//        if (isNotNil(responsObject)) {
//            if (Y_IS_Success) {
//                NSDictionary *rows = Y_ResponsObject_dataDic;
//                block(Y_ResponsObject_rowsArr,YES);
//            }else{
//                block(@[],NO);
//                Y_SVP_SHOW_ERR_MESSAGE
//            }
//        }else{
//            block(@[],NO);
//            Y_SVP_SHOW_ERR_DESCRIPTION
//        }
//    }];
//}
+ (void)getAllOrderListWithBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
    [self getOrderListWithType:MyOrderListCell_Type_All withBlock:listBlock];
}

+ (void)getOrderListWithType:(MyOrderListCell_Type)orderType withBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@(9999) forKey:@"rows"];
    [parms setValue:@(1) forKey:@"page"];
    
    //全部：1，代付款：2，待使用：3，待评价：4，退款/售后：5；orederState
    switch (orderType) {
        case MyOrderListCell_Type_All://全部 不做筛选
            [parms setValue:@(1) forKey:@"orderState"];
            break;
        case MyOrderListCell_Type_WillPay:
            [parms setValue:@(2) forKey:@"orderState"];
            break;
        case MyOrderListCell_Type_WillUse:
            [parms setValue:@(3) forKey:@"orderState"];
            break;
        case MyOrderListCell_Type_WillEvaluation:
            [parms setValue:@(4) forKey:@"orderState"];
            break;
        case MyOrderListCell_Type_ReturnComIng:
            [parms setValue:@(5) forKey:@"orderState"];
            break;
        case MyOrderListCell_Type_ReturnComSuccess:
            [parms setValue:@(5) forKey:@"orderState"];
            break;
        case MyOrderListCell_Type_ReturnComRefused:
            [parms setValue:@(5) forKey:@"orderState"];
            break;
        case MyOrderListCell_Type_ReturnCom:
            [parms setValue:@(5) forKey:@"orderState"];
            break;
             
        default:
            break;
    }
    [self getListWithParms:parms withBlock:listBlock];
}

+ (void)getListWithParms:(NSMutableDictionary *)parms withBlock:(BaseListArrAndSuccessBoolBlock)listBlock{
    
    [[ToolOfNetWork sharedTools]YrequestPostURLNotMainQueueWtihBuniessShopTypeUrl:MyOrderList_Url_Type_All withParams:parms finished:^(id responsObject, NSError *error) {
        BaseListArrAndSuccessBoolBlock block = listBlock;
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                NSDictionary *rows = Y_ResponsObject_dataDic;
                block(Y_ResponsObject_rowsArr,YES);
            }else{
                block(@[],NO);
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            block(@[],NO);
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

@end
