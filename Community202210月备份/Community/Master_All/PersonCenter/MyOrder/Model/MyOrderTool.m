//
//  MyOrderTool.m
//  Community
//
//  Created by 余莹 on 2021/2/18.
//

#import "MyOrderTool.h"

@implementation MyOrderTool
+ (NSString *)typeStrWithType:(MyOrderListCell_Type)type{
//    switch (type) {
//        case  MyOrderListCell_Type_WillPay:
//            return @"待支付";
//            break;
//        case  MyOrderListCell_Type_EndDeal:
//            return @"已完成";
//            break;
//        case  MyOrderListCell_Type_IsCancel:
//            return @"已取消";
//            break;
//        case  MyOrderListCell_Type_WillEvaluation:
//            return @"待评价";
//            break;
//        case  MyOrderListCell_Type_WillUse:
//            return @"待使用";
//            break;
//
//        default:
//            return @"其他";
//            break;
//    }
    
//    MyOrderListCell_Type_All=1,
//    MyOrderListCell_Type_WillPay=2,
//    MyOrderListCell_Type_PayEnd =3,//3"已付款"
//    MyOrderListCell_Type_WillUse=4,// 4"待使用"
//    MyOrderListCell_Type_WillEvaluation=5,//"待评价5"
//    MyOrderListCell_Type_EndDeal=5,//"待评价5"==已完成5
//    MyOrderListCell_Type_EvaluationEnd =6,//已经评价
//    MyOrderListCell_Type_ReturnCom=7,//退款/售后
    
        switch (type) {
            case  MyOrderListCell_Type_WillPay:
                return @"待支付";
                break;
            case  MyOrderListCell_Type_PayEnd:
                return @"已付款";
                break;
            case  MyOrderListCell_Type_WillUse:
                return @"待使用";
                break;
            case  MyOrderListCell_Type_WillEvaluation:
                return @"待评价";
                break;
//            case  MyOrderListCell_Type_EndDeal:
//                return @"已完成";
//                break;
            case  MyOrderListCell_Type_EvaluationEnd:
                return @"已评价";
                break;
            case  MyOrderListCell_Type_ReturnCom:
                return @"退款/售后";
                break;
//            case  MyOrderListCell_Type_IsCancel:
//                return @"已取消";
//                break;
            default:
                return @"其他";
                break;
        }
}
@end
