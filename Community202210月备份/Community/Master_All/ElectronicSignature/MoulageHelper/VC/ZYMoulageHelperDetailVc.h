//
//  ZYMoulageHelperDetailVc.h
//  Community
//
//  Created by ZY on 2021/4/14.
//

#import <UIKit/UIKit.h>
#import "ZYAllContractTemplatesModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYMoulageHelperDetailVc : ZYBaseViewController

@property (nonatomic, copy) NSString *uuid;

@property (nonatomic, assign) BOOL isSystemTemplate;

@property (nonatomic, strong) ZYAllContractTemplatesDataListModel *contractTemplatesDataListModel;

@end

NS_ASSUME_NONNULL_END
