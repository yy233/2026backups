//
//  LifeCosePaymentOnePayInfoVC.h
//  Community
//
//  Created by 余莹 on 2021/1/9.
//

#import <UIKit/UIKit.h>
#import "LifeCostMyCostDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LifeCosePaymentOnePayInfoVC : BaseTableViewController
@property (nonatomic,strong) LifeCostMyCostModel *listOldModel;
@property (nonatomic,strong) LifeCostMyCostDetailModel *thisCostDetailmodel;
@property (nonatomic,strong) NSMutableArray *sectionOneContentArr;

@end

NS_ASSUME_NONNULL_END
