//
//  MyRepairShowDetailWorkOrderInfoVC.h
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import "BaseTableViewController.h"
#import "MyRepairPageListUseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DetailVcCancelOneUpInfo)(void);//取消上报

@interface MyRepairShowDetailWorkOrderInfoVC : BaseTableViewController

@property (nonatomic,copy) DetailVcCancelOneUpInfo detailVcCancelOneUpInfo;

@property (nonatomic,strong) MyRepairPageListUseModel * model;

@end

NS_ASSUME_NONNULL_END
