//
//  MyOrderTool.h
//  Community
//
//  Created by 余莹 on 2021/2/18.
//

#import <Foundation/Foundation.h>
#import "MyOrderModel.h"
#import "MyOrderCallShopTool.h"
#import "MyOrderEvaluationVC.h"//评论提交页
#import "MyOrderRefundScheduleVC.h"//退款进度页

NS_ASSUME_NONNULL_BEGIN
//typedef enum : NSUInteger {
//    MyOrderListCell_Type_All=1,
//    MyOrderListCell_Type_WillPay=2,
//    MyOrderListCell_Type_WillUse=3,//3"已付款" 4"待使用"
//    MyOrderListCell_Type_WillEvaluation=4,//"待评价5"
//    MyOrderListCell_Type_EndDeal=5,//"待评价5"==已完成5
//    MyOrderListCell_Type_IsCancel=8,//取消状态
//} MyOrderListCell_Type;
//typedef enum : NSUInteger {
//    MyOrderListCell_Type_All=1,
//    MyOrderListCell_Type_WillPay=2,
//    MyOrderListCell_Type_PayEnd =3,//3"已付款"
//    MyOrderListCell_Type_WillUse=4,// 4"待使用"
//    MyOrderListCell_Type_WillEvaluation=5,//"待评价5"
//    MyOrderListCell_Type_EndDeal=5,//"待评价5"==已完成5
//    MyOrderListCell_Type_EvaluationEnd =6,//已经评价
//    MyOrderListCell_Type_ReturnCom=7,//退款/售后
//} MyOrderListCell_Type;
//————————————————————————————————————————————————————————————————————————————
//      "stateId": 3,//订单状态 0:待接单,1:已接单,2:正在配送，3:已完成,,4:待删除,5:作废
//      "payState": "1",//0是未支付，1是支付成功，2是退款中，3是退款成功，4拒绝退款
//      "evaluationId": -1,//用户是否评论，-1未评论，1是评论
//      "used": "0",//是否使用 0是未使用，1是已使用
//————————————————————————————————————————————————————————————————————————————
//。     总订单类型 appState appStateNum
 /**
  //OrderState_FROM_ALL("全部订单", 1),
          OrderState_FROM_WAIT_PAYED("待付款", 2),
          //ORDER_STATE_FROM_PAYED("已付款",3),
          ORDER_STATE_FROM_USED("待使用", 4),
          ORDER_STATE_FROM_EVALUATION("待评价", 5),
          ORDER_STATE_FROM_EVALUATED("已评价",6),
          ORDER_STATE_FROM_BACKING("退款中",7),
          ORDER_STATE_FROM_FINISH_BACK("退款成功",8),
          ORDER_STATE_FROM_REFUSE_BACK("拒绝退款",9);
          //ORDER_STATE_FROM_RETURN("退款/售后", 10);
  */
//————————————————————————————————————————————————————————————————————————————
typedef enum : NSUInteger {
    MyOrderListCell_Type_All=1,
    MyOrderListCell_Type_WillPay=2, //待付款
    MyOrderListCell_Type_PayEnd =3, //3"已付款"
    MyOrderListCell_Type_WillUse=4, // 4"待使用"
    MyOrderListCell_Type_WillEvaluation=5,//"待评价5" == 已完成MyOrderListCell_Type_EndDeal
    MyOrderListCell_Type_EvaluationEnd =6,//已经评价
    MyOrderListCell_Type_ReturnComIng=7,//退款中
    MyOrderListCell_Type_ReturnComSuccess=8,//退款成功
    MyOrderListCell_Type_ReturnComRefused=9,//拒绝退款
    MyOrderListCell_Type_ReturnCom=10,//退款/售后
} MyOrderListCell_Type;




@interface MyOrderTool : NSObject
+ (NSString *)typeStrWithType:(MyOrderListCell_Type)type;
@end

NS_ASSUME_NONNULL_END
