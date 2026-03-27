//
//  ZYContractTemplateUploadModel.h
//  Community
//
//  Created by ZY on 2021/5/13.
//

#import <Foundation/Foundation.h>

@class ZYContractTemplateUploadTempParamModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYContractTemplateUploadModel : NSObject <YYModel>

@property (nonatomic, copy) NSString *belongTo;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) NSInteger signType;

@property (nonatomic, copy) NSString *uploader;

@property (nonatomic, copy) NSString *oldTempId;

@property (nonatomic, strong) NSArray<ZYContractTemplateUploadTempParamModel *> *tempParam;

@end


@interface ZYContractTemplateUploadTempParamModel : NSObject

@property (nonatomic, copy) NSString *tKey;

@property (nonatomic, copy) NSString *tName;

@property (nonatomic, assign) NSInteger tOrder;

@property (nonatomic, copy) NSString *tType;

@property (nonatomic, copy) NSString *tValue;

@property (nonatomic, copy) NSString *tUid;

@property (nonatomic, copy) NSString *tUserId;

@property (nonatomic, copy) NSString *tTempId;

// 取值范围
@property (nonatomic, copy) NSString *tValueRange;

// 是否必填（默认0必填，1选填，2不可填）
@property (nonatomic, assign) NSInteger tIsRequired;

// 依赖参数
@property (nonatomic, copy) NSString *tRelyParam;

// 依赖条件
@property (nonatomic, copy) NSString *tRelyCondition;

// 可编辑方（默认0，无限制；1、甲方；2、乙方）
@property (nonatomic, assign) NSInteger tEditableParty;

@end

NS_ASSUME_NONNULL_END
