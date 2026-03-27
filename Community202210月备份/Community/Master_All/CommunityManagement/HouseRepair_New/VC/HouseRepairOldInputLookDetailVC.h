//
//  HouseRepairOldInputLookDetailVC.h
//  Community
//
//  Created by 余莹 on 2022/3/4.
//

#import <UIKit/UIKit.h>
#import "HouseRePairHeader.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^DetailVcCancelOneUpInfo)(void);//取消上报

@interface HouseRepairOldInputLookDetailVC : BaseTableViewController
@property (nonatomic,strong) MyRepairPageListUseModel * model;
@property (nonatomic,copy) DetailVcCancelOneUpInfo detailVcCancelOneUpInfo;
@end

NS_ASSUME_NONNULL_END
