//
//  BillingDetailVC.h
//  Community
//
//  Created by 余莹 on 2022/6/8.
//

#import "BaseTableViewController.h"
#import "BillingListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BillingDetailVC : BaseTableViewController
@property (nonatomic,strong) NSString *idStr;
@property (nonatomic,assign) BOOL isTuiKuanBool;
@end

NS_ASSUME_NONNULL_END
