//
//  ZYLifeCostBindHouseholdWebVC.h
//  Community
//
//  Created by ZY on 2022/1/11.
//

#import <UIKit/UIKit.h>
#import "LifeCostPayTypeModel.h"
#import "PaymentCompanyUseShowModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZYLifeCostBindHouseholdWebVC : ZYBaseViewController

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, strong) LifeCostPayTypeModel *typeModel;

@property (nonatomic, strong) PaymentCompanyUseShowModel *companyModel;

@end

NS_ASSUME_NONNULL_END
