//
//  ZYContrectAllListModel.h
//  Community
//
//  Created by ZY on 2021/5/24.
//

#import <Foundation/Foundation.h>

@class ZYContrectAllListDataModel, ZYContrectAllListDataListModel, ZYContrectAllListDataMapModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYContrectAllListModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, copy) NSString *sign;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, assign) BOOL fail;

@property (nonatomic, strong) ZYContrectAllListDataModel *data;

@end


@interface ZYContrectAllListDataModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<ZYContrectAllListDataListModel *> *list;

@property (nonatomic, strong) ZYContrectAllListDataMapModel *map;

@end


@interface ZYContrectAllListDataListModel : NSObject

@property (nonatomic, copy) NSString *annexId;

@property (nonatomic, copy) NSString *conId;

@property (nonatomic, copy) NSString *conName;

@property (nonatomic, assign) NSInteger conState;

// 1:双方合同
@property (nonatomic, assign) NSInteger conType;

@property (nonatomic, copy) NSString *deadlineTime;

@property (nonatomic, copy) NSString *depositId;

@property (nonatomic, copy) NSString *depositTime;

@property (nonatomic, copy) NSString *endTime;

@property (nonatomic, copy) NSString *judicial;

@property (nonatomic, copy) NSString *partAName;

@property (nonatomic, copy) NSString *partAPhone;

@property (nonatomic, assign) NSInteger partASignState;

@property (nonatomic, copy) NSString *partASignTime;

@property (nonatomic, copy) NSString *partBName;

@property (nonatomic, copy) NSString *partBPhone;

@property (nonatomic, assign) NSInteger partBSignState;

@property (nonatomic, copy) NSString *partBSignTime;

@property (nonatomic, copy) NSString *processRecordId;

@property (nonatomic, copy) NSString *signedTime;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, assign) NSInteger going;

@property (nonatomic, assign) NSInteger blockStatus;

@property (nonatomic, copy) NSString *createTime;

// 0:发起方 1:签署方
@property (nonatomic, assign) NSInteger signRole;

// 司法链
@property (nonatomic, copy) NSString *judicialHash;

// 合同类型
@property (nonatomic, copy) NSString *type;

// 社区签约id
@property (nonatomic, copy) NSString *signId;

// 资产id
@property (nonatomic, copy) NSString *assetId;

// 资产类型
@property (nonatomic, assign) NSInteger assetType;

// 是否需要支付
@property (nonatomic, assign) BOOL isOnlinePayment;

// 是否支付
@property (nonatomic, assign) BOOL canSign;

@end


@interface ZYContrectAllListDataMapModel : NSObject

// 全部合同
@property (nonatomic, assign) NSInteger allContracts;

// 待我处理
@property (nonatomic, assign) NSInteger waitForMeToSignContracts;

// 待他人处理
@property (nonatomic, assign) NSInteger contractToBeSigned;

//已完成
@property (nonatomic, assign) NSInteger completedContract;

// 即将截止签署
@property (nonatomic, assign) NSInteger contractIsAboutToClose;

// 已失效
@property (nonatomic, assign) NSInteger contractIsInvalid;

// 即将过期
@property (nonatomic, assign) NSInteger contractAboutToExpire;

// 我发起的
@property (nonatomic, assign) NSInteger allInitiatedContractToMe;

@end

NS_ASSUME_NONNULL_END
