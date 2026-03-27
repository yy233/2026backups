//
//  ZYMoulageHelperDetailModel.h
//  Community
//
//  Created by ZY on 2021/5/7.
//

#import <Foundation/Foundation.h>

@class ZYMoulageHelperDetailtParamsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZYMoulageHelperDetailModel : NSObject <YYModel>

@property (nonatomic, strong) NSArray<ZYMoulageHelperDetailtParamsModel *> *tParams;

@property (nonatomic, copy) NSString *content;

@end


@interface ZYMoulageHelperDetailtParamsModel : NSObject

@property (nonatomic, copy) NSString *tCreateTime;

@property (nonatomic, copy) NSString *tKey;

@property (nonatomic, copy) NSString *tName;

@property (nonatomic, assign) NSInteger tOrder;

@property (nonatomic, copy) NSString *tTempId;

@property (nonatomic, copy) NSString *tUid;

@property (nonatomic, copy) NSString *tUpdateTime;

@property (nonatomic, copy) NSString *tUserId;

@property (nonatomic, copy) NSString *tType;

@property (nonatomic, copy) NSString *tValue;

// 取值范围
@property (nonatomic, copy) NSString *tValueRange;

// 是否必填（默认0必填，1选填）
@property (nonatomic, assign) NSInteger tIsRequired;

// 依赖参数
@property (nonatomic, copy) NSString *tRelyParam;

// 依赖条件
@property (nonatomic, copy) NSString *tRelyCondition;

// 可编辑方（默认0，无限制；1、甲方可编辑；2、乙方可编辑）
@property (nonatomic, assign) NSInteger tEditableParty;

@end

NS_ASSUME_NONNULL_END
