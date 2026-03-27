//
//  LifeCostPayOrderDetailMobileRechargeSubPaymentItemModel.h
//  Community
//
//  Created by 余莹 on 2022/1/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LifeCostPayOrderDetailMobileRechargeSubPaymentItemModel : NSObject

@property (nonatomic,copy) NSString *companyId;
@property (nonatomic,copy) NSString *companyName;
@property (nonatomic,copy) NSString *paymentBusinessCode;
@property (nonatomic,copy) NSString *paymentConstraint;
@property (nonatomic,copy) NSString *paymentItemCode;
@property (nonatomic,copy) NSString *paymentItemId;
@property (nonatomic,copy) NSString *paymentItemNo;
@property (nonatomic,copy) NSString *printAddress;
@property (nonatomic,copy) NSString *proxyBankCode;
@property (nonatomic,copy) NSString *queryBusinessCode;
@property (nonatomic,copy) NSString *updatedAt;
@property (nonatomic,copy) NSString *createdAt;
@property (nonatomic,copy) NSString *description;
/**
 paymentItemModelList 的model
 data =     {
     mobileRechargeModel =         {
         mobile = 13900000000;
         operator = 0;
         paymentItemModelList =             (
                             {
                 businessFlow = 1;
                 categoryId = 30;
                 cebPaymentNameModelList =                     (
                 );
                 cityModelList =                     (
                 );
                 companyId = 010001601;
                 companyName = "北京移动";
                 createPaymentBillParamsModelList =                     (
                                             {
                         amountLimit = "0-100000";
                         b2bAmountLimitBottom = 0;
                         b2bAmountLimitTop = 1000000000000;
                         description = "缴费金额提示：";
                         payCondId = 5010053;
                         payTimeTips = "营业时间为00:05-23:55";
                         paymentItemId = 1;
                         rangLimit = "-10";
                         rechargeLimit = "";
                         timeRangeLimit = "28800000-86400000";
                     }
                 );
                 createdAt = "Jun 12, 2015 9:46:24 AM";
                 description = gjkklll;
                 isAppoint = 1;
                 operator = 0;
                 paymentBillFieldsInfoModelList =                     (
                 );
                 paymentBusinessCode = BJCEBBCReq;
                 paymentConstraint = "北京市移动通讯费北京市移动通讯费北京市移动通讯费北京市移动通讯费";
                 paymentItemCode = 972469929;
                 paymentItemId = 1;
                 paymentItemName = "北京市移动通讯费（勿删）";
                 paymentItemNo = 001603;
                 printAddress = "北京市移动通讯费";
                 proxyBankCode = 010;
                 queryBusinessCode = BJCEBQBIReq;
                 queryPaymentBillParamModelList =                     (
                 );
                 status = 1;
                 tempOffStatus = 0;
                 updatedAt = "Nov 25, 2021 6:46:32 PM";
             },
                             {
                 businessFlow = 1;
                 categoryId = 33;
                 cebPaymentNameModelList =                     (
                 );
                 cityModelList =                     (
                 );
                 companyId = 010001710;
                 companyName = "北京移动";
                 createPaymentBillParamsModelList =                     (
                                             {
                         amountLimit = "0-1000000000000";
                         b2bAmountLimitBottom = 0;
                         b2bAmountLimitTop = 1000000000000;
                         payCondId = 214503;
                         paymentItemId = 231106;
                         rangLimit = "-10";
                         rechargeLimit = "30|50|100|150";
                     }
                 );
                 createdAt = "Apr 12, 2021 6:34:49 PM";
                 isAppoint = 1;
                 operator = 0;
                 paymentBillFieldsInfoModelList =                     (
                 );
                 paymentBusinessCode = BJCEBBCReq;
                 paymentItemCode = 956084211;
                 paymentItemId = 231106;
                 paymentItemName = "移动话费充值";
                 paymentItemNo = 001710;
                 proxyBankCode = 010;
                 queryBusinessCode = ZJMS;
                 queryPaymentBillParamModelList =                     (
                 );
                 status = 1;
                 tempOffStatus = 0;
                 updatedAt = "Aug 10, 2021 2:05:47 PM";
             }
         );
         validCardsCount = 0;
     };
 
 */
@end

NS_ASSUME_NONNULL_END
