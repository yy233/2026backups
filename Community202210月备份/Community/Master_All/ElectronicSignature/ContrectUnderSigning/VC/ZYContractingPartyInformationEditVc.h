//
//  ZYContractingPartyInformationEditVc.h
//  Community
//
//  Created by ZY on 2021/5/18.
//

#import <UIKit/UIKit.h>
#import "ZYAllContractTemplatesModel.h"
#import "ZYContractTemplateUploadModel.h"
#import "ZYSealImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYContractingPartyInformationEditVc : ZYBaseViewController

@property (nonatomic, strong) ZYAllContractTemplatesDataListModel *contractTemplatesDataListModel;

@property (nonatomic, strong) NSArray<ZYContractTemplateUploadTempParamModel *> *contractParams;

@property (nonatomic, copy) NSString *htmlStr;

@property (nonatomic, strong) ZYSealImageDataModel *sealImageDataModel;

@property (nonatomic, strong) ZYRentSignInfoModel *rentSignInfoModel;

@end

NS_ASSUME_NONNULL_END
