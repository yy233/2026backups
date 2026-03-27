//
//  ZYProcessEvidenceModel.h
//  Community
//
//  Created by ZY on 2021/9/1.
//

#import <Foundation/Foundation.h>

@class ZYProcessEvidenceDataModel, ZYProcessEvidenceDataListModel, ZYProcessEvidenceDataListDataModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYProcessEvidenceModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) ZYProcessEvidenceDataModel *data;

@end


@interface ZYProcessEvidenceDataModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *extractionCode;

@property (nonatomic, strong) NSArray<ZYProcessEvidenceDataListModel *> *processRecordTimestampParamList;

@end


@interface ZYProcessEvidenceDataListModel : NSObject

@property (nonatomic, assign) NSInteger dataType;

@property (nonatomic, strong) ZYProcessEvidenceDataListDataModel *data;

@end


@interface ZYProcessEvidenceDataListDataModel : NSObject

// 标题
@property (nonatomic, copy) NSString *role;

// 标题类型(0 未来物服， 1 发起方， 2 签约方， 3 第三方)
@property (nonatomic, assign) NSInteger roleType;

// 时间
@property (nonatomic, copy) NSString *time;

// 说明
@property (nonatomic, copy) NSString *describe;

// hash码
@property (nonatomic, copy) NSString *code;

// code类型
@property (nonatomic, assign) NSInteger codeType;

// 签署时间
@property (nonatomic, copy) NSString *signTime;

// 签署方id
@property (nonatomic, copy) NSString *userId;

// 签署方
@property (nonatomic, copy) NSString *signName;

// 证件号
@property (nonatomic, copy) NSString *licenseId;

// ip地址
@property (nonatomic, copy) NSString *ipAddr;

// 定位
@property (nonatomic, copy) NSString *positionInfo;

// 设备
@property (nonatomic, copy) NSString *deviceInfo;

// 电话
@property (nonatomic, copy) NSString *phone;

// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
