//
//  ZYContrectUnderSigningDetailEditVc.h
//  Community
//
//  Created by ZY on 2021/5/15.
//  在线签约编辑

#import <UIKit/UIKit.h>
#import "ZYAllContractTemplatesModel.h"
#import "ZYMoulageHelperDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYContrectUnderSigningDetailEditVc : ZYBaseViewController

@property (nonatomic, copy) NSString *uuid;

// 是否连跳
@property (nonatomic, assign) BOOL isImmediatelySign;

// 是否草稿箱
@property (nonatomic, assign) BOOL isDraft;

// 是否是系统模板
@property (nonatomic, assign) BOOL isSystemTemplate;

@property (nonatomic, strong) ZYAllContractTemplatesDataListModel *contractTemplatesDataListModel;

@property (nonatomic, copy) NSString *origHtmlStr;

@property (nonatomic, strong) NSArray *origContractArray;

@property (nonatomic, strong) ZYRentSignInfoModel *rentSignInfoModel;

@end

NS_ASSUME_NONNULL_END
