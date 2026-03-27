//
//  ZYContractTemplateChangedUploadModel.h
//  Community
//
//  Created by ZY on 2021/10/29.
//

#import <Foundation/Foundation.h>
#import "ZYContractTemplateUploadModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYContractTemplateChangedUploadModel : NSObject

@property (nonatomic, copy) NSString *tempId;

@property (nonatomic, strong) NSArray<ZYContractTemplateUploadTempParamModel *> *paramsList;

@end

NS_ASSUME_NONNULL_END
