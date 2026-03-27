//
//  HealthTemperatureTotalVc.h
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import <UIKit/UIKit.h>
#import "HealthDataSubBaseVC.h"
#import "HealthDataSubBaseTableViewController.h"

#import "HealthTempAndHeartBaseTotalTopView.h"
#import "HealthTempAndHeartBaseTotalBrokenLineGraphView.h"
NS_ASSUME_NONNULL_BEGIN

@interface HealthTemperatureAndHeartBaseTotalVc : HealthDataSubBaseVC
@property (nonatomic,strong) NSString *nowUserId;

@property (nonatomic,strong) HealthTempAndHeartBaseTotalTopView *topView;
@property (nonatomic,strong) HealthTempAndHeartBaseTotalBrokenLineGraphView *mainLinesView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) LabelYu *tableViewHeaderView;
@property (nonatomic,assign) TempAndHeartTotalTopView_SubBtn_Choose_Type topViewChooseType;
@property (nonatomic,assign) NSInteger weakPageTurnIndexNum;
@property (nonatomic,assign) NSInteger monthPageTurnIndexNum;
@property (nonatomic,strong) NSMutableArray *tableViewDataSourceArr;
@property (nonatomic,strong) NSMutableArray *saveTableViewDataSourceArrTouchStatus;//存 点击收起的状态

@property (nonatomic,strong) HealthGetTempOrHeartOneDayModel *saveOneDayModel;
@property (nonatomic,strong) HealthGetTempOrHeartOneWeakModel *saveOneWeakModel;
@property (nonatomic,strong) HealthGetTempOrHeartOneMonthModel *saveOneMonthModel;

@end

NS_ASSUME_NONNULL_END
