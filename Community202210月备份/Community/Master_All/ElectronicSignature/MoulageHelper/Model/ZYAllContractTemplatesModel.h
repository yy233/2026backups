//
//  ZYAllContractTemplatesModel.h
//  Community
//
//  Created by ZY on 2021/4/8.
//

#import <Foundation/Foundation.h>

@class ZYAllContractTemplatesDataModel, ZYAllContractTemplatesDataListModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYAllContractTemplatesModel : NSObject

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, assign) BOOL fail;

@property (nonatomic, strong) ZYAllContractTemplatesDataModel *data;

@end


@interface ZYAllContractTemplatesDataModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, assign) NSInteger pages;

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<ZYAllContractTemplatesDataListModel *> *list;

@end


@interface ZYAllContractTemplatesDataListModel : NSObject

// 模板uuid
@property (nonatomic, copy) NSString *uuid;

// 模板名称
@property (nonatomic, copy) NSString *name;

// 模板类型
@property (nonatomic, copy) NSString *type;

// 签署类型
@property (nonatomic, assign) NSInteger signType;

// 创建时间
@property (nonatomic, copy) NSString *createTime;

// 模板归属
@property (nonatomic, copy) NSString *belongTo;

// 模板是否认证 0.未认证 1.已认证
@property (nonatomic, assign) NSInteger approvalStatus;

@end

NS_ASSUME_NONNULL_END
