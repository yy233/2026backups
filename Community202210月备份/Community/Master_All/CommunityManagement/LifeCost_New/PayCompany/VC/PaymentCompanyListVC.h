//
//  PaymentCompanyListVC.h
//  Community
//
//  Created by 余莹 on 2022/1/7.
//

#import <UIKit/UIKit.h>
#import "LifeCostPayTypeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaymentCompanyListVC : BaseTableViewController

@property (nonatomic,strong) NSString *payTypeIdStr;

@property (nonatomic,strong) NSString *saveNowCityTextStr;

@property (nonatomic, strong) LifeCostPayTypeModel *typeModel;

@end

NS_ASSUME_NONNULL_END
