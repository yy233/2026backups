//
//  PaymentCompanyUseShowModel.h
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import <Foundation/Foundation.h>

@class QueryPaymentBillParamModelListModel, CreatePaymentBillParamsModelListModel;

NS_ASSUME_NONNULL_BEGIN

@interface PaymentCompanyUseShowModel : NSObject

// 缴费项目ID
@property (nonatomic,copy) NSString *paymentItemId;

// 缴费类别ID
@property (nonatomic,copy) NSString *categoryId;

// 公司ID
@property (nonatomic,copy) NSString *companyId;

// 缴费单位名称
@property (nonatomic,copy) NSString *companyName;

// 缴费项目名称
@property (nonatomic,copy) NSString *paymentItemName;

// 业务流程;0：先查后缴 1：直接缴费 2：二次查询;不同的业务流程,需要跳不同的页面,走不同的接口
@property (nonatomic,assign) NSInteger businessFlow;

// 是否支持预交费;0:不支持预交费;1:支持预交费
@property (nonatomic,assign) NSInteger isAppoint;

// 项目编号
@property (nonatomic,copy) NSString *paymentItemCode;

// 项目编号
@property (nonatomic,copy) NSString *paymentItemNo;

// 打发票地址
@property (nonatomic,copy) NSString *printAddress;

// 获取发票方式描述
@property (nonatomic,copy) NSString *getInvoiceDescription;

// 特殊提示
@property (nonatomic,copy) NSString *paymentConstraint;

@property (nonatomic, strong) NSArray<QueryPaymentBillParamModelListModel *> *queryPaymentBillParamModelList;

@property (nonatomic, strong) NSArray<CreatePaymentBillParamsModelListModel *> *createPaymentBillParamsModelList;

@end


@interface QueryPaymentBillParamModelListModel : NSObject

// 输入域优先级 1 主输入域 2 非主输入域
@property (nonatomic, assign) NSInteger priorLevel;

// 输入域名称
@property (nonatomic,copy) NSString *name;

// 输入框最小长度
@property (nonatomic, assign) NSInteger minFieldLength;

// 输入框最大长度
@property (nonatomic, assign) NSInteger maxFieldLength;

// 说明
@property (nonatomic,copy) NSString *desc;

// 下拉框选项 例如2个选项：学杂费=1|通讯费=2
@property (nonatomic,copy) NSString *listBoxOptions;

// 输入域filed
@property (nonatomic, assign) NSInteger filedNum;

// 1可以为空 0表示不可以为空
@property (nonatomic, assign) NSInteger isNull;

// 0表示文本框 1表示下拉框
@property (nonatomic, assign) NSInteger filedType;

// 0 表示金额以分为单位 1 表示金额以元为单位 2 表示账期 必须以YYYYMM 格式
@property (nonatomic, assign) NSInteger inputType;

// 显示优先级 1-5 输入框显示位置：1 表示 最前 5 表示最后
@property (nonatomic, assign) NSInteger showLevel;

@end


@interface CreatePaymentBillParamsModelListModel : NSObject

// 金额限制
@property (nonatomic,copy) NSString *amountLimit;

// 账期类型
@property (nonatomic,copy) NSString *rangLimit;

// 缴费金额提示
@property (nonatomic,copy) NSString *desc;

// 缴费时间提示
@property (nonatomic,copy) NSString *payTimeTips;

// 可选择的充值金额
@property (nonatomic,copy) NSString *chooseAmount;

// 日期限制
@property (nonatomic,copy) NSString *timeRangeLimit;

// 充值金额限制
@property (nonatomic,copy) NSString *rechargeLimit;

@end

/**
 businessFlow = 0;
 categoryId = 32;
 cebPaymentNameModelList =                     (
 );
 cityModelList =                     (
 );
 companyId = 010001301;
 companyName = "国网北京市电力公司";
 createPaymentBillParamsModelList =                     (
                             {
         amountLimit = "0-1000000000000";
         payCondId = 229704;
         paymentItemId = 246907;
         rangLimit = 1;
     }
 );
 isAppoint = 1;
 paymentBillFieldsInfoModelList =                     (
 );
 paymentItemCode = 987745741;
 paymentItemId = 246907;
 paymentItemName = "北京网络电表代缴（勿删）";
 paymentItemNo = 001301;
 printAddress = "交易日起三个月内凭光大银行缴费凭条到国网电力网点换取发票";
 queryPaymentBillParamModelList =                     (
                             {
         description = "购电金额200，单位：元";
         filedNum = 2;
         filedType = 1;
         inputType = 1;
         isNull = 0;
         isScan = 0;
         keyboardType = 3;
         listBoxOptions = "200=200";
         maxFieldLength = 999;
         minFieldLength = 0;
         name = "购电金额";
         paymentItemId = 246907;
         priorLevel = 2;
         selectParamId = 251307;
         showLevel = 2;
         type = 0;
     },
                             {
         description = "10位至12位数字用户编号";
         filedNum = 0;
         filedType = 0;
         inputType = "-1";
         isNull = 0;
         isScan = 0;
         keyboardType = 2;
         maxFieldLength = 12;
         minFieldLength = 10;
         name = "用户编号";
         paymentItemId = 246907;
         priorLevel = 1;
         selectParamId = 242506;
         showLevel = 1;
         type = 0;
     }
 );
 status = 1;
 tempOffStatus = 0;
 */

NS_ASSUME_NONNULL_END
