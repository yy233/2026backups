//
//  MyCarListInfoVC.m
//  Community
//
//  Created by 余莹 on 2022/5/9.
//

#import "MyCarListInfoVC.h"
#import "MyCarListInfoVcTableViewCell.h"
#import "MyCarListInfoVcAddBtnTableViewCell.h"
#import "CarPaltWebViewVC.h"
#import "MyCarInfoOrParkingOrPayHistoryData.h"
#import "CarInfoBaseModel.h"
@interface MyCarListInfoVC ()

@end

@implementation MyCarListInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *titleStr = [NSString stringWithFormat:@"%@-%@",[ShareUserInfo sharedUserInfo].commuityInfo.name,@"我的车辆"];
    self.title = titleStr;
    [self initView];
    [self addRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDIsCountBlueAndWW];
}

- (void)initView{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
     self.tableView.mj_header = headeerRefresh;
}
- (void)initData{
    WEAKSELF
    [MyCarInfoOrParkingOrPayHistoryData myCarInfoListWithParms:@{@"communityId": @( [ShareUserInfo sharedUserInfo].commuityInfo.ID) }.mutableCopy withBlock:^(NSArray * _Nonnull arr,  BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];;
        });
        if (success) {
            weakSelf.dataSourceArr = [NSMutableArray arrayWithArray: [CarInfoBaseModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
         
    }];
 }

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  self.dataSourceArr.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;//车牌行（有删除按钮的cell且比较宽）
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section >= self.dataSourceArr.count){
        MyCarListInfoVcAddBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: MyCarListInfoVcAddBtnTableViewCell_I];
        if (!cell) {
            cell = [[MyCarListInfoVcAddBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyCarListInfoVcAddBtnTableViewCell_I];
        }
        WEAKSELF
        cell.touchAddBtnBlock = ^{
            [weakSelf touchAddAction];
        };
        return cell;
    }else{
        MyCarListInfoVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: MyCarListInfoVcTableViewCell_I];
        if (!cell) {
            cell = [[MyCarListInfoVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyCarListInfoVcTableViewCell_I];
        }
        CarInfoBaseModel *model = self.dataSourceArr[indexPath.section];
        [cell fillCarPlateStr: [TextShowWithModelStr textShowWithModelStr:model.carNumber]];
        WEAKSELF
        cell.touchDelActionBlock = ^{
            [weakSelf touchDelActionWithIndexPath:indexPath];
        };
        return cell;
    }

}

#pragma mark ==  新增
- (void)touchAddAction{
    //h5 车牌界面
    DLog(@"跳转去h5 输车牌");

    CarPaltWebViewVC *vc = [[CarPaltWebViewVC alloc]init];
    WEAKSELF
    vc.carPlatBlock = ^(NSString * _Nonnull carPlatStr) {
        [weakSelf addOneCarDataWithCarPlatStr:carPlatStr];
    };
    [self pushVc:vc];
}
- (void)addOneCarDataWithCarPlatStr:(NSString *)carPlatStr{
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithCapacity:0];
    [parms setValue:carPlatStr forKey:@"carNumber"];
    [parms setValue:@( [ShareUserInfo sharedUserInfo].commuityInfo.ID ) forKey:@"communityId"];
    [parms setValue:@( [UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.accessLevel ) forKey:@"carType"];//后台需要的当前用户身份权限类型

    WEAKSELF
    [MyCarInfoOrParkingOrPayHistoryData myCarAddOneCartWithParms:parms withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            STRONGSELF
            [strongSelf initData];
        }
    }];

}

#pragma mark == 删除
- (void)touchDelActionWithIndexPath:(NSIndexPath *)indexPath{
    DLog(@"删除 index = %ld ",indexPath.section);

    CarInfoBaseModel *model = self.dataSourceArr[indexPath.section];
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithCapacity:0];
    [parms setValue:[TextShowWithModelStr textShowWithModelStr:model.ID] forKey:@"carId"];
    
     WEAKSELF
    [MyCarInfoOrParkingOrPayHistoryData myCarDeletOneCartWithParms:parms withBlock:^(NSDictionary * _Nonnull dic,  BOOL success) {
        if (success) {
            STRONGSELF
            [strongSelf initData];
        }
    }];
}

@end
