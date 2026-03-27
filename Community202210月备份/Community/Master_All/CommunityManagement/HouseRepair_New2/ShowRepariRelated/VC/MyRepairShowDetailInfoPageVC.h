//
//  RepairShowDetailInfoPageVC.h
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import "MyRepairMainPageVC.h"
#import "YHPageViewController.h"
#import "YHPageHeaderViewController.h"

#import "MyRepairPageListUseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^DetailPopToListWithRefreshBlock)(void);

@interface MyRepairShowDetailInfoPageVC : YHPageViewController
@property (nonatomic,strong) MyRepairPageListUseModel * detailmodel;
@property (nonatomic,copy) DetailPopToListWithRefreshBlock detailPopToListWithRefreshBlock;
@end

NS_ASSUME_NONNULL_END
