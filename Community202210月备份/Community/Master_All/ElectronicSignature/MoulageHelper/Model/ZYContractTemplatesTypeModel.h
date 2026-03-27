//
//  ZYContractTemplatesTypeModel.h
//  Community
//
//  Created by ZY on 2021/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ZYContractTemplatesTypeDataModel;

@interface ZYContractTemplatesTypeModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger *code;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSArray<ZYContractTemplatesTypeDataModel *> *data;

@end


@interface ZYContractTemplatesTypeDataModel : NSObject <YYModel>

@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, copy) NSString *uid;

// 名称
@property (nonatomic, copy) NSString *name;

// 传参类型
@property (nonatomic, assign) NSInteger dicId;

// 类型
@property (nonatomic, copy) NSString *sn;

// 是否选中
@property (nonatomic, assign) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
