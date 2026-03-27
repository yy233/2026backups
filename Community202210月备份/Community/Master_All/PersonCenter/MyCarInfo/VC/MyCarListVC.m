//
//  MyCarVC.m
//  Community
//
//  Created by 余莹 on 2021/8/5.
//

#import "MyCarListVC.h"
#import "MyCarAddOrEditVC.h"
#import "MyCarTableViewCell.h"
#define  MyCarTableViewCell_Identifier  @"MyCarTableViewCell"
#import "MyCarInfoData.h"
#import "MyCarInfoCarModel.h"

@interface MyCarListVC ()
@property (nonatomic,assign) NSInteger nowCommunityId;
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

@implementation MyCarListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的车辆";
    self.tableView.tableFooterView = self.footerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.nowCommunityId =  [ShareUserInfo sharedUserInfo].commuityInfo.ID;
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing]; 
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)initData{
//    NSInteger communityId = self.nowCommunityId;//车辆不做社区id限制
    WEAKSELF
        [MyCarInfoData getMyCarListWithBlcok:^(NSArray * arr, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_header endRefreshing];
            });
            if (success) {
                weakSelf.dataSourceArr = [MyCarInfoCarModel mj_objectArrayWithKeyValuesArray:arr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }];
     
 
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return self.dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCarTableViewCell_Identifier];
    if (!cell) {
        cell = [[MyCarTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyCarTableViewCell_Identifier];
    }
    WEAKSELF
    cell.editActionBlock = ^{
        [weakSelf editActionWithRowNum:indexPath.row];
    };
    MyCarInfoCarModel *model = self.dataSourceArr[indexPath.row];
    cell.titleL.text = [TextShowWithModelStr textShowWithModelStr:model.carPlate];
    return cell;
}
- (void)editActionWithRowNum:(NSInteger)rowNum{
//    NSArray *titleArr = @[@"编辑车辆",@"删除车辆"];
    NSArray *titleArr =@[@"删除车辆"];//1030 不修改
    MyCarInfoCarModel *model = self.dataSourceArr[rowNum];
    NSString *carNameStr = [TextShowWithModelStr textShowWithModelStr:model.carPlate];
    //
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:carNameStr message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    WEAKSELF
    /**
     *@"编辑车辆"
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:titleArr.firstObject style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
      //去编辑页面
        MyCarAddOrEditVC *vc = [[MyCarAddOrEditVC alloc]init];
        //vc.nowCommunityId = self.nowCommunityId;
        vc.isAddCarBool = NO;
        vc.idStr = [TextShowWithModelStr textShowWithModelStr:model.idStr];
        vc.oldCarPlate = [TextShowWithModelStr textShowWithModelStr:model.carPlate];
        [weakSelf pushVc:vc];
    }];
  */
    //@"删除车辆"
    UIAlertAction *deletAction = [UIAlertAction actionWithTitle:titleArr.lastObject style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deletCarWithRowNum:rowNum];
    }];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    //[alertVC addAction:editAction];
    [alertVC addAction:deletAction];
    [alertVC addAction:cancleAction];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)deletCarWithRowNum:(NSInteger)rowNum{
    MyCarInfoCarModel *model = self.dataSourceArr[rowNum];// 做删除请求
    WEAKSELF
    [MyCarInfoData deletMyCarWithId:model.ID withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            [weakSelf.dataSourceArr removeObjectAtIndex:rowNum];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 120)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"添加车辆"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W-32, 50)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:20 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];
    }
    return _footerView;
}
- (void)footerBtnAction{
    MyCarAddOrEditVC *vc = [[MyCarAddOrEditVC alloc]init];
    vc.isAddCarBool = YES;
//    vc.nowCommunityId = self.nowCommunityId;
    [self pushVc:vc];
}
 

@end
