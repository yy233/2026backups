//
//  LifeCostPaymentOneEndBillOrderDetailModel.h
//  Community
//
//  Created by 余莹 on 2021/3/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPaymentOneEndBillOrderDetailModel : NSObject
//
@property (nonatomic,strong) NSString *billClassificationName;
@property (nonatomic,assign) NSInteger billClassification;
@property (nonatomic,strong) NSString *payTypeName;//付款方式名
@property (nonatomic,strong) NSString *typeName;  //账单分类
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,strong) NSString *familyName;
@property (nonatomic,assign) NSInteger familyId;
@property (nonatomic,assign) NSInteger orderNum;
@property (nonatomic,assign) NSInteger orderId;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) double paymentBalance;//本次支付的金额
@property (nonatomic,strong) NSString *icon;
@property (nonatomic,strong) NSString *largeSizeIcon;
@property (nonatomic,strong) NSString *mediumIcon;

//
@property (nonatomic,strong) NSString *tally; //标签
@property (nonatomic,strong) NSString *remark;    //备注
@property (nonatomic,strong) NSString *remarkImg; //备注图的url
@property (nonatomic,assign) NSInteger id;
 
/**
 code = 0;
 data =     {
     billClassification = 1;
     billClassificationName = "充值缴费";
     companyName = "国家电网重庆市电力公司";
     familyId = 105613516;
     icon = "https://i.postimg.cc/4xSG87YQ/2.png";
     largeSizeIcon = "https://i.postimg.cc/VkyyCVLB/a2.png";
     mediumIcon = "https://i.postimg.cc/vTnjvh4p/q2.png";
     orderId = 33357729829621760;
     orderNum = 20210311181625198118586;
     paymentBalance = 333;
     status = 2;
     typeName = "电费";

 
 
 remark = "标签11111";
 remarkImg = "http://222.178.212.29:9000/bbbb/cf85dcdb18e341e89585afd971311720";
 status = 2;
 tally = "其他账本本本本本";
 //
 
 
 message = "<null>";
}
 */
@end

NS_ASSUME_NONNULL_END
