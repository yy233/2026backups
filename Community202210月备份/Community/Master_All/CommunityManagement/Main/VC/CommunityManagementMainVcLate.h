//
//  CommunityManagementMainVcLast.h
//  Community
//
//  Created by 余莹 on 2021/7/26.
//

#import <UIKit/UIKit.h>
#import "MainBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommunityManagementMainVcLate : MainBaseViewController

// 是否直接跳转到我的租赁界面
@property (nonatomic, assign) BOOL isJumpMyRent;

// 是否直接跳转到签章合同管理界面
@property (nonatomic, assign) BOOL isJumpContractManage;

@end

NS_ASSUME_NONNULL_END
