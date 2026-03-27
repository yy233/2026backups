//
//  ParkingTemporaryVC.m
//  Community
//
//  Created by 余莹 on 2021/8/6.
// 临时停车 本界面暂时不使用 接口不要了

#import "ParkingTemporaryVC.h"
#import "ParkingTemporaryVcTopView.h"
#import "ParkingTemporaryTableViewCell.h"
#define ParkingTemporaryTableViewCell_Identifier      @"ParkingTemporaryTableViewCell"
#import "ParkingCarData.h"
#import "ParkingCarBaseModel.h"


@interface ParkingTemporaryVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) ParkingTemporaryVcTopView *topView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@end

@implementation ParkingTemporaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"临时缴费"; 
    [self initView];
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}
- (void)initData{
//    self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:@"渝D32R21",@"22",@"33",@"44", nil];
    WEAKSELF
//    [ParkingCarData lingShiGetMyCarListWithBlcok:^(NSArray * arr, BOOL success) {
//        if (success) {
//            weakSelf.dataSourceArr = [[NSMutableArray alloc]initWithArray: [ParkingCarBaseModel  mj_objectArrayWithKeyValuesArray:arr]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.tableView reloadData];
//            });
//        }
//    }];
}
#pragma mark  ==
//新增car
- (void)saveNewCarAction{
    DLog();
    WEAKSELF
//    [ParkingCarData lingShiAddCarWithParkCarInfoDic:@{}.mutableCopy withBlock:^(NSDictionary * dic, BOOL succeess) {
//        if (succeess) {
//            [weakSelf initData];
//        }
//    }];
}
//解绑
- (void)cancelBangDingWithDataIndexNum:(NSInteger)dataIndexNum{
    DLog();
}
//默认权限
- (void)setRightYesWithDataIndexNum:(NSInteger)dataIndexNum{
    DLog();
    
   
}
#pragma mark  ==================
//编辑car的权限和绑定关系
- (void)editCarWithDataIndexNum:(NSInteger)dataIndexNum{
    ParkingCarBaseModel *model = self.dataSourceArr[dataIndexNum];
    NSString *carNameStr = model.carPlate;
//    NSString *carNameStr = self.dataSourceArr[dataIndexNum];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:carNameStr message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    WEAKSELF
    UIAlertAction *rightSetAction = [UIAlertAction actionWithTitle:@"设定默认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setRightYesWithDataIndexNum:dataIndexNum];
    }];
    UIAlertAction *bangDingSetNotAction = [UIAlertAction actionWithTitle:@"解除绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf cancelBangDingWithDataIndexNum:dataIndexNum];
    }];
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:rightSetAction];
    [alertC addAction:bangDingSetNotAction];
    [alertC addAction:alertActionCancel];
    [self presentViewController:alertC animated:YES completion:nil];
    
}

//默认权限设置
- (void)setCarWithFriestRightWithDataIndexNum:(NSInteger)dataIndexNum{
    ParkingCarBaseModel *model = self.dataSourceArr[dataIndexNum];
    NSString *carNameStr = model.carPlate;
    UIAlertController *rightSetAlertC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确认设定%@为默认车辆吗？",carNameStr] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    WEAKSELF
    UIAlertAction *alertActionOk = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf setRightYesWithDataIndexNum:dataIndexNum];
    }];
    [rightSetAlertC addAction:alertActionCancel];
    [rightSetAlertC addAction:alertActionOk];
    [self presentViewController:rightSetAlertC animated:YES completion:nil];
}

#pragma mark ==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        [self setCarWithFriestRightWithDataIndexNum:(indexPath.row-1)];
    }
}
#pragma mark ==
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSourceArr.count == 0) {
        return 0;
    }else{
        return  self.dataSourceArr.count+1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ParkingTemporaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ParkingTemporaryTableViewCell_Identifier];
    if (!cell) {
        cell = [[ParkingTemporaryTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ParkingTemporaryTableViewCell_Identifier];
    }
    
    if (indexPath.row==0) {
        cell.nameL.text = @"您绑定的车牌";
        cell.nameL.font = [UIFont boldSystemFontOfSize:15];
        cell.editBtn.hidden = YES;
        cell.typeInfoBtn.hidden = YES;
    }else{
        WEAKSELF
        cell.eBlock = ^{
            [weakSelf editCarWithDataIndexNum:(indexPath.row-1)];
        };
        cell.nameL.font = [UIFont  systemFontOfSize:13];
        cell.editBtn.hidden = NO;
        
        ParkingCarBaseModel *model = self.dataSourceArr[indexPath.row-1];
        cell.nameL.text  = model.carPlate;
        //
        cell.typeInfoBtn.hidden = NO;
    }
    return cell;
}


#pragma mark == UI
- (void)initView{
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    [self.topView.textFTopTuchBtn addTarget:self action:@selector(textFTopTuchBtnACtion) forControlEvents:UIControlEventTouchUpInside];
    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.superview);
        make.left.right.equalTo(_topView.superview);
        make.height.offset(150);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(10);
        make.left.right.equalTo(_topView.superview);
        make.bottom.equalTo(_topView.superview).offset(-20);
    }];
    WEAKSELF
    self.topView.saveBlock = ^{
        [weakSelf saveNewCarAction];
    };
}
#pragma mark ==
- (ParkingTemporaryVcTopView *)topView{
    if (!_topView) {
        _topView = [[ParkingTemporaryVcTopView alloc]init];
    }
    return _topView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 245 + status_height, Screen_W, Screen_H - 245 - status_height - bar_bottom_height) style:UITableViewStylePlain];
        _tableView.sectionFooterHeight = 0.1;
        _tableView.sectionFooterHeight = 0.1;
        _tableView.backgroundColor = Y_RGBA(245, 245, 245, 1);
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}
#pragma mark ==
- (NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [[NSMutableArray alloc]init];
    }
    return _dataSourceArr;
}
- (void)textFTopTuchBtnACtion{
    DLog(@"textFTopTuchBtnACtion 点击tf 跳转去h5 输车牌");
}

@end
