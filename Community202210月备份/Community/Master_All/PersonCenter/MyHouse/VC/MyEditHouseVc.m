//
//  MyEditHouseVc.m
//  Community
//
//  Created by 余莹 on 2021/8/4.
//

#import "MyEditHouseVc.h"
#import "MyHouseData.h"
#import "MyHouseCerEdHouseModel.h"
#import "MyEditWithAddHouseVC.h"


#import "MyHouseAddSubPersonVC.h"
#import "MyEditHouseTableViewCell.h"
#define  MyEditHouseTableViewCell_Identifier      @"MyEditHouseTableViewCell"

@interface MyEditHouseVc ()
@property (nonatomic,strong) BaseTableViewFooterView *footerView; // 编辑房屋改成查看房屋 本界面footer 不去添加列表了 做返回操作
@end

@implementation MyEditHouseVc

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"编辑";
    self.title = @"用户房屋总信息";
    self.tableView.tableFooterView = self.footerView;
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
//当前vc之前list选出来的
- (void)initData{
    WEAKSELF
    [MyHouseData getMyHousesHaveBeenCertifiedListDataWithBlock:^(NSArray * arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            weakSelf.dataSourceArr = [[NSMutableArray alloc]initWithArray:[MyHouseCerEdHouseModel mj_objectArrayWithKeyValuesArray:arr]];
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHeaderV = [[UIView alloc]init];
    UILabel *headerViewTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 10,Screen_W-32, 30)];
    headerViewTextLabel.text = @"    房屋信息";
    headerViewTextLabel.textColor = [ThemeManager shareManager].mainTextColor;
    headerViewTextLabel.font  = [UIFont boldSystemFontOfSize:15];
    headerViewTextLabel.backgroundColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
    [sectionHeaderV addSubview:headerViewTextLabel];
    return sectionHeaderV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyEditHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyEditHouseTableViewCell_Identifier];
    if (!cell) {
        cell = [[MyEditHouseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyEditHouseTableViewCell_Identifier];
    }
    MyHouseCerEdHouseModel *model = self.dataSourceArr[indexPath.row];
    cell.titleL.text = @"所属房屋";
    cell.detailL.text = [[TextShowWithModelStr textShowWithModelStr:model.communityText] stringByAppendingString:[TextShowWithModelStr textShowWithModelStr:model.houseSite]];
    return cell;
}
#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
//        [_footerView.footerBtn setTitle:@"新增房屋" forState:UIControlStateNormal];// 编辑房屋改成查看房屋 本界面footer 不去添加列表了 做返回操作
        [_footerView.footerBtn setTitle:@"已完成" forState:UIControlStateNormal];
        [_footerView.footerBtn addTarget:self action:@selector(addHouseAction) forControlEvents:UIControlEventTouchUpInside];
        _footerView.footerBtn.layer.cornerRadius = 8;
    }
    return _footerView;
}
- (void)addHouseAction{
    NSLog(@"新增房屋");//房屋
    // 编辑房屋改成查看房屋 本界面footer 不去添加列表了 做返回操作
    /**
     MyEditWithAddHouseVC *chooseHouseDetailAddressVC = [[MyEditWithAddHouseVC alloc]init];
     [self.navigationController pushViewController:chooseHouseDetailAddressVC animated:YES];
     */
    [self popVC];
}
@end
