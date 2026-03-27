//
//  ZYMoulageHelperDetailEditVc.h
//  Community
//
//  Created by ZY on 2021/5/7.
//

#import <UIKit/UIKit.h>
#import "ZYAllContractTemplatesModel.h"
#import "ZYMoulageHelperDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYMoulageHelperDetailEditVc : ZYBaseViewController

@property (nonatomic, copy) NSString *htmlStr;

@property (nonatomic, strong) NSArray *contractArray;

@property (nonatomic, strong) NSArray *noHandleContractArray;

@property (nonatomic, assign) BOOL isSystemTemplate;

@property (nonatomic, strong) ZYAllContractTemplatesDataListModel *contractTemplatesDataListModel;

@end

NS_ASSUME_NONNULL_END
