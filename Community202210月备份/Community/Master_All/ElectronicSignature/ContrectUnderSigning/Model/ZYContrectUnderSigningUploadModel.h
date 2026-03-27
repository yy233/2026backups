//
//  ZYContrectUnderSigningUploadModel.h
//  Community
//
//  Created by ZY on 2021/5/20.
//

#import <Foundation/Foundation.h>
#import "ZYContractTemplateUploadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYContrectUnderSigningUploadModel : NSObject <YYModel>

// 合同类型
@property (nonatomic, assign) NSInteger contractType;

// 发起方设备详细信息
@property (nonatomic, copy) NSString *deviceInfo;

// 发起方IP地址
@property (nonatomic, copy) NSString *ipAddr;

// 发起人密码/人脸数据/短信验证码
@property (nonatomic, copy) NSString *organAuth;

// 发起人认证方式
@property (nonatomic, copy) NSString *organAuthType;

// 发起人
@property (nonatomic, copy) NSString *organizerId;

// 发起方印章
@property (nonatomic, copy) NSString *organizerSealId;

// 乙方是否必须手写
@property (nonatomic, assign) BOOL partBMustHand;

// 发起方位置
@property (nonatomic, copy) NSString *positionInfo;

// 描述-说明
@property (nonatomic, copy) NSString *remark;

// 合同创建时间
@property (nonatomic, copy) NSString *createTime;

//// 续签提醒日期
//@property (nonatomic, copy) NSString *renewalReminderDate;

// 签署人
@property (nonatomic, copy) NSString *signatoryId;

// 签约截止日期
@property (nonatomic, copy) NSString *signingDeadline;

// 短信验证码，本人操作验证
@property (nonatomic, copy) NSString *smsCode;

// 合同主题
@property (nonatomic, copy) NSString *subject;

// 合同模板id
@property (nonatomic, copy) NSString *templateId;

// 附件
@property (nonatomic, copy) NSString *annexFileId;

//@property (nonatomic, strong) NSArray<ZYContractTemplateUploadTempParamModel *> *contractParams;
@property (nonatomic, strong) NSDictionary *contractParams;



// 签约id
@property (nonatomic, assign) NSInteger id;

// 房屋id
@property (nonatomic, copy) NSString *assetId;

// 资产类型 1:商铺 2:房屋
@property (nonatomic, assign) NSInteger assetType;

// 是否需要支付
@property (nonatomic, assign) BOOL isOnlinePayment;

@end

NS_ASSUME_NONNULL_END
