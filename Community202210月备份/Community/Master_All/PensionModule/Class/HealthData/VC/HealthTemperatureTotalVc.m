//
//  HealthTemperatureTotalVc.m
//  Community
//
//  Created by 余莹 on 2021/11/19.
//

#import "HealthTemperatureTotalVc.h"
#import "HealthBaseDataManager.h"
#import "HealthTempHeader.h"

#define  Height_Row              (30)
#define  Height_SectionHeader    (40)

@interface HealthTemperatureTotalVc () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation HealthTemperatureTotalVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"体温"; 
//    self.mainLinesView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3];
//    self.tableView.backgroundColor = [[UIColor greenColor]colorWithAlphaComponent:0.5];
    
    [self newTextConnectWithHeaderTopV];
    [self.tableView reloadData];
 
}
 
 
- (void)newTextConnectWithHeaderTopV{
    self.tableViewHeaderView.text = @"体温异常记录";
}
- (void)getOneDayData{
    WEAKSELF
    [[HealthBaseDataManager share]getUserTempOneDayDataWithUserId:self.nowUserId withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            weakSelf.saveOneDayModel = [HealthGetTempOrHeartOneDayModel mj_objectWithKeyValues:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reUpMainLinesView];
            });
        }
    }];
    
    [[HealthBaseDataManager share]getUserTempOneDayAbnormalDataWithUserId:self.nowUserId withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            self.tableViewDataSourceArr = [HealthGetAllAbnormalModel mj_objectArrayWithKeyValuesArray:arr];
            [self changeTouchStausWithSectionCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
- (void)getOneWeakData{
    WEAKSELF
    [[HealthBaseDataManager share]getUserTempOneWeakDataWithUserId:self.nowUserId withWeakPageTurnIndexNum:self.weakPageTurnIndexNum withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            self.saveOneWeakModel = [HealthGetTempOrHeartOneWeakModel mj_objectWithKeyValues:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reUpMainLinesView];
            });
        }
    }];
    
    [[HealthBaseDataManager share]getUserTempOneWeakAbnormalDataWithUserId:self.nowUserId  withWeakPageTurnIndexNum:self.weakPageTurnIndexNum withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            if (self.weakPageTurnIndexNum == -1) {
                self.tableViewDataSourceArr = [HealthGetAllAbnormalModel mj_objectArrayWithKeyValuesArray:arr];
            }else{
                [self.tableViewDataSourceArr  addObjectsFromArray: [HealthGetAllAbnormalModel mj_objectArrayWithKeyValuesArray:arr]]; 
            }
            [self changeTouchStausWithSectionCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
 
    
}
- (void)getOneMonthData{
    WEAKSELF
    [[HealthBaseDataManager share]getUserTempOneMonthDataWithUserId:self.nowUserId withMonthPageTurnIndexNum:self.monthPageTurnIndexNum withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            self.saveOneMonthModel = [HealthGetTempOrHeartOneMonthModel mj_objectWithKeyValues:dic];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reUpMainLinesView];
            });
        }
    }];
    [[HealthBaseDataManager share]getUserTempOneMonthAbnormalDataWithUserId:self.nowUserId  withMonthPageTurnIndexNum:self.monthPageTurnIndexNum withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            if (self.monthPageTurnIndexNum == -1) {
                self.tableViewDataSourceArr = [HealthGetAllAbnormalModel mj_objectArrayWithKeyValuesArray:arr];
            }else{
                [self.tableViewDataSourceArr  addObjectsFromArray: [HealthGetAllAbnormalModel mj_objectArrayWithKeyValuesArray:arr]];
            }
            [self changeTouchStausWithSectionCount];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
- (void)changeTouchStausWithSectionCount{

    self.saveTableViewDataSourceArrTouchStatus = [NSMutableArray arrayWithCapacity:0];//清空原本数据
    for (int i = 0; i < self.tableViewDataSourceArr.count; i++) {
        [self.saveTableViewDataSourceArrTouchStatus addObject:@(0)];
    }
}
- (void)touchSectionHeaderViewWithSectionNum:(NSInteger)section{
    if ( [[self.saveTableViewDataSourceArrTouchStatus objectAtIndex:section] intValue] == 0) {
        [self.saveTableViewDataSourceArrTouchStatus  replaceObjectAtIndex:section withObject:@(1)];
    }else{
        [self.saveTableViewDataSourceArrTouchStatus  replaceObjectAtIndex:section withObject:@(0)];
    }
}
#pragma mark === 折线图
- (void)reUpMainLinesView{
    switch (self.topViewChooseType) {
        case TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisDay:
        {
            [self.mainLinesView fillTempDayTypeWithData:self.saveOneDayModel];
        }
            break;
        case TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisWeak:
        {
            [self.mainLinesView fillTempWeakTypeWithData:self.saveOneWeakModel];
        }
            break;
        case TempAndHeartTotalTopView_SubBtn_Choose_Type_ThisMonth:
        {
            [self.mainLinesView fillTempMonthTypeWithData:self.saveOneMonthModel];
        }
            break;
            
        default:
            break;
    }
    
    
}
#pragma mark === 异常纪录
#pragma mark == == == == == == == == == ==
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableViewDataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.saveTableViewDataSourceArrTouchStatus[section] boolValue]) {//已经记录为1时做全部显示
        HealthGetAllAbnormalModel *model = self.tableViewDataSourceArr[section];
        return model.list.count;
    }else{
        return 0;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return Height_Row;

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Height_SectionHeader;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HealthGetAllAbnormalModel *model = self.tableViewDataSourceArr[section];
    HealthTempAndHeartBaseTotalAbnormalSectionHeaderView *hv = [[HealthTempAndHeartBaseTotalAbnormalSectionHeaderView alloc]initWithFrame:CGRectZero];
    hv.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.timeTitle];//时间数据
    hv.rightBtn.selected = [self.saveTableViewDataSourceArrTouchStatus[section] boolValue];//箭头上下
    WEAKSELF
    hv.touchSubBtnBlcok = ^{
        [weakSelf touchSectionHeaderViewWithSectionNum:section];
//        [tableView reloadSections: [NSIndexSet indexSetWithIndex:section]  withRowAnimation:UITableViewAutomaticDimension];//刷新本组
        [tableView reloadData];//刷新全部 使其暂无展位图隐掉
    };
    return hv;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HealthTempOrHeartAbnormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HealthTempOrHeartAbnormalTableViewCell_Identifier];
    if (!cell) {
        cell = [[HealthTempOrHeartAbnormalTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:HealthTempOrHeartAbnormalTableViewCell_Identifier];
    }
    HealthGetAllAbnormalModel *model = self.tableViewDataSourceArr[indexPath.section];
    HealthGetOneAbnormalModel *oneObj = model.list[indexPath.row];
    [cell fillDataWithTempAbnormalModel:oneObj];
    return cell;
}
@end
