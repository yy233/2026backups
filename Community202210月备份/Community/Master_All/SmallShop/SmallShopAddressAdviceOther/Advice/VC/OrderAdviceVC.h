//
//  OrderAdviceVC.h
//  Community
//
//  Created by 余莹 on 2022/3/1.
//

#import "SmallShopBaseTableViewController.h"
#import "SmallShppOrderModel.h" 
NS_ASSUME_NONNULL_BEGIN

@interface OrderAdviceVC : SmallShopBaseTableViewController
@property (nonatomic,strong) SmallShppOrderModel *orderListUseModel;
@end

NS_ASSUME_NONNULL_END
