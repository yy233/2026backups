//
//  ParkingMonthlyTenancyAddNewCarVC.m
//  Community
//
//  Created by 余莹 on 2021/8/6.
//

#import "ParkingMonthlyTenancyAddNewCarVC.h"
#import "ParkingMonthlyTenancyPayRenewaGoPayingVC.h"
#import "MyHouseAddSubPersonTableViewCell.h"
#import "ParkingPayInfoTableViewCell.h"
#import "ParkingPayMonthlyNumBtnTableViewCell.h"
#import "ParkingMonthlyTenancyAddNewCarVcWithCarPlareTableViewCell.h"

#define ParkingMonthlyTenancyAddNewCarVcWithCarPlareTableViewCell_Identifier    @"ParkingMonthlyTenancyAddNewCarVcWithCarPlareTableViewCell"

#define  MyHouseAddSubPersonTableViewCellTextFeild_Identifier               @"MyHouseAddSubPersonTableViewCellTextFeild"
#define  MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn_Identifier  @"MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn"
#define  ParkingPayInfoOnlyTextColorRedTableViewCell_Identifier             @"ParkingPayInfoOnlyTextColorRedTableViewCell"
#define  ParkingPayMonthlyNumBtnTableViewCell_Identifier                    @"ParkingPayMonthlyNumBtnTableViewCell"
 
#define ParkingAddCarCell_rowNum_CarAddress 0
#define ParkingAddCarCell_rowNum_CarPares 1
#define ParkingAddCarCell_rowNum_MonthNum 2
#define ParkingAddCarCell_rowNum_AllMoney 3

#import "PopViewOfParkingCarPosition.h"
#import "ParkingCarData.h"
#import "CarPositionModel.h"
#import "MyCarInfoData.h"
#import "MyCarInfoCarModel.h"
#import "PopViewWithMyCarList.h"
#import "CarPaltWebViewVC.h"


#define Popview_Tag_MyCarList 306 //用户车辆

@interface ParkingMonthlyTenancyAddNewCarVC () <MyHouseAddSubPersonTableViewCellTextFeildDelegate,BasePopTableViewChooseDelegate>
@property (nonatomic,strong) BaseTableViewFooterView *footerView;
//
@property (nonatomic,strong) PopViewOfParkingCarPosition *popViewCarPosition;
@property (nonatomic,strong) NSMutableArray *saveCarPositionArr;
@property (nonatomic,strong) CarPositionModel *saveChooseCarPosition;
//
@property (nonatomic,strong) PopViewWithMyCarList *popViewWithMyCarList;
@property (nonatomic,strong) NSMutableArray *saveMyCarListArr;
@property (nonatomic,strong) MyCarInfoCarModel *saveMyCarChooseModel;
@end

@implementation ParkingMonthlyTenancyAddNewCarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定车辆";
    self.tableView.tableFooterView = self.footerView;
    [self initData];
    [self reqDanJiaWithOneMoney];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDIsCountBlueAndWW];
}
 
- (void)initData{
    self.cellTitleArr = [[NSMutableArray alloc]initWithObjects:@"停车位置",@"车牌号",@"包月时长",@"付费金额", nil];
    self.dataSourceArr = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"0", nil];
    [self.tableView reloadData];
    self.saveDanJiaOfMonthly = 0.0;
    self.saveChooseCarPosition  = [[CarPositionModel alloc]init];
    self.saveMyCarChooseModel = [[MyCarInfoCarModel alloc]init];

}
- (void)reqDanJiaWithOneMoney{
 
    //一个月停车单价
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];
    [parms setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];
    [parms setValue:@(1) forKey:@"month"];
    [parms setValue:self.dataSourceArr[ParkingAddCarCell_rowNum_CarPares] forKey:@"carPlate"];
    //
    WEAKSELF
    Y_SVP_SHOW_MES_IsLoading_15Delay
    [ParkingCarData parkineGetMoneyWithNowInfoDic:parms  withBlock:^(NSDictionary * dic, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            NSNumber *moneyNumber = [dic objectForKey:@"M"];
            weakSelf.saveDanJiaOfMonthly = [moneyNumber doubleValue];
//            [weakSelf.dataSourceArr  replaceObjectAtIndex:ParkingAddCarCell_rowNum_MonthNum withObject:[NSString stringWithFormat:@"%ld",monthlyNum]];
//            [weakSelf.dataSourceArr  replaceObjectAtIndex:ParkingAddCarCell_rowNum_AllMoney withObject:[NSString stringWithFormat:@"%@",moneyNumber]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf reloadRowNum:ParkingAddCarCell_rowNum_MonthNum];
//                [weakSelf reloadRowNum:ParkingAddCarCell_rowNum_AllMoney];
//            });
        }
    }];
}
#pragma mark ==
- (void)textFieldTopBtnActionWithRowNum:(NSInteger)rowNum{
    if (rowNum==0) {
        //选择 停车场
        WEAKSELF
        Y_SVP_SHOW_MES_IsLoading_15Delay
        [ParkingCarData parkingGetPositionInfoWithCommunityInfoDic:@{@"communityId":@([ShareUserInfo sharedUserInfo].commuityInfo.ID)}.mutableCopy withBlock:^(NSArray * arr, BOOL success) {
            Y_SVP_DISMISS
            if (success) {
                weakSelf.saveCarPositionArr = [CarPositionModel mj_objectArrayWithKeyValuesArray:arr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.popViewCarPosition showInView:self.view thePopViewTableViewHeight:0 WithArray:weakSelf.saveCarPositionArr];
                });
            }
        }];
    }
}

- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath{
    if (tag == Popview_Tag_MyCarList) {
        //车辆数据
        self.saveMyCarChooseModel = self.saveMyCarListArr[indexPath.row];
        [self.dataSourceArr replaceObjectAtIndex:ParkingAddCarCell_rowNum_CarPares withObject: [TextShowWithModelStr textShowWithModelStr:self.saveMyCarChooseModel.carPlate]];
        [self reloadRowNum:ParkingAddCarCell_rowNum_CarPares];
        
    }else{
        DLog(@"选择 停车场 某位置");
        CarPositionModel *model = self.saveCarPositionArr[indexPath.row];
        self.saveChooseCarPosition = model;
        [self.dataSourceArr replaceObjectAtIndex:ParkingAddCarCell_rowNum_CarAddress withObject: [TextShowWithModelStr textShowWithModelStr:model.carPosition]];
        [self reloadRowNum:ParkingAddCarCell_rowNum_CarAddress];
    }

    
}
//车牌号码
- (void)cellTextFieldWithTag:(NSInteger)tag andTextFieldStr:(NSString *)textStr{
    [self.dataSourceArr replaceObjectAtIndex:ParkingAddCarCell_rowNum_CarPares withObject:textStr];
}
//更新月份
//更新金额
- (void)changeMoneyWithMonthlyNum:(NSInteger)monthlyNum{
    //
   // NSLog(@"包月数量 （增加减少） vc得到数据 ==== 月份数 %ld",monthlyNum);
    double allMoney = ( self.saveDanJiaOfMonthly * monthlyNum);
    //没有单价时获取单价
    if (monthlyNum>0 && self.saveDanJiaOfMonthly == 0.0) {
        [self reqDanJiaWithOneMoney];
        return;
    }
    //
    [self.dataSourceArr  replaceObjectAtIndex:ParkingAddCarCell_rowNum_MonthNum withObject:[NSString stringWithFormat:@"%ld",monthlyNum]];
    [self.dataSourceArr  replaceObjectAtIndex:ParkingAddCarCell_rowNum_AllMoney withObject:[NSString stringWithFormat:@"%0.2f",allMoney]];
    //NSLog(@"包月数量 （增加减少） vc得到数据 刷新 ==== 月份数 %ld ,dataS %@ 钱=%@",monthlyNum,self.dataSourceArr[ParkingAddCarCell_rowNum_MonthNum],self.dataSourceArr[ParkingAddCarCell_rowNum_AllMoney]);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadRowNum:ParkingAddCarCell_rowNum_MonthNum];
        [self reloadRowNum:ParkingAddCarCell_rowNum_AllMoney];
    });
}

- (void)reloadRowNum:(NSInteger)rowNum{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowNum inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
     return  self.cellTitleArr.count;
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

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ParkingAddCarCell_rowNum_CarAddress) {
        MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn *cell  = [tableView dequeueReusableCellWithIdentifier:MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn_Identifier];
        if (!cell) {
            cell = [[MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseAddSubPersonTableViewCellTextFeildHaveChooseBtn_Identifier];
        }
        cell.titleL.text = self.cellTitleArr[indexPath.row];
        cell.textField.text = self.dataSourceArr[indexPath.row];
        [cell setTextFiePstr:@"请选择停车场"];
        WEAKSELF
        cell.touchBtnBlock = ^{
            [weakSelf textFieldTopBtnActionWithRowNum:indexPath.row];
        };
        return cell;
    }else  if (indexPath.row == ParkingAddCarCell_rowNum_CarPares) {
        /**
         MyHouseAddSubPersonTableViewCellTextFeild *cell  = [tableView dequeueReusableCellWithIdentifier:MyHouseAddSubPersonTableViewCellTextFeild_Identifier];
         if (!cell) {
             cell = [[MyHouseAddSubPersonTableViewCellTextFeild alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyHouseAddSubPersonTableViewCellTextFeild_Identifier];
             cell.delegate = self;
         }
         */
        ParkingMonthlyTenancyAddNewCarVcWithCarPlareTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:ParkingMonthlyTenancyAddNewCarVcWithCarPlareTableViewCell_Identifier];
        if (!cell) {
            cell = [[ParkingMonthlyTenancyAddNewCarVcWithCarPlareTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ParkingMonthlyTenancyAddNewCarVcWithCarPlareTableViewCell_Identifier];
            cell.delegate = self;
        }
        cell.titleL.text = self.cellTitleArr[indexPath.row];
        cell.textField.text = self.dataSourceArr[indexPath.row];
        [cell setTextFiePstr:@"请输入车牌号码"];
        [cell.rightBtn addTarget:self action:@selector(carCellRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.textFTopTuchBtn addTarget:self action:@selector(textFTopTuchBtnAction) forControlEvents:UIControlEventTouchUpInside];
        return cell;
  
    } else if(indexPath.row == ParkingAddCarCell_rowNum_MonthNum){
        ParkingPayMonthlyNumBtnTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ParkingPayMonthlyNumBtnTableViewCell_Identifier];
        if (!cell) {
            cell = [[ParkingPayMonthlyNumBtnTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ParkingPayMonthlyNumBtnTableViewCell_Identifier];
 
        }
        cell.titleL.text = self.cellTitleArr[indexPath.row];
        cell.monthlyNumChangeBlock = ^(NSInteger monthlyNum) {
            //NSLog(@"包月数量 （增加减少） blcok得到数据 刷新 ==== 月份数 %ld", monthlyNum);
            [self changeMoneyWithMonthlyNum:monthlyNum];
        };
        //月份数据
        if ( [self.dataSourceArr[indexPath.row] floatValue] == 0 ) {
            cell.textF.text = @"0";
            cell.monthlyN  = 0;
        }else{
            cell.textF.text = self.dataSourceArr[indexPath.row];
            cell.monthlyN  = [self.dataSourceArr[indexPath.row] integerValue];
        }
        return cell;
    }else{//ParkingAddCarCell_rowNum_AllMoney
        BaseShowRedRightTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseShowRedRightTextTableViewCell"];
        if (!cell) {
            cell = [[BaseShowRedRightTextTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"BaseShowRedRightTextTableViewCell"];
        }
        cell.titleL.text = self.cellTitleArr[indexPath.row];
        //
        if ( [self.dataSourceArr[indexPath.row] floatValue] == 0 ) {
            cell.textField.text = @"¥0";
        }else{
            cell.textField.text = [@"¥" stringByAppendingString:self.dataSourceArr[indexPath.row]];
        }
        return cell;
    }
}
 
#pragma mark ==
- (void)carCellRightBtnAction{
    //DLog(@"我的车辆列表数据获取操作 poplistV");
    WEAKSELF
    [MyCarInfoData getMyCarListWithBlcok:^(NSArray * arr, BOOL success) {//#import "MyCarInfoCarModel.h"

        if (success) {
            //arr = [NSArray arrayWithObject:@{@"id":@"35491571067654144",@"carPlate":@"渝C66666"}];//test
            if (arr.count<=0) {
                Y_SVP_SHOW_INFO_MES(@"暂无历史车辆数据，可手动输入车牌号。");
                return;
            }else{
                weakSelf.saveMyCarListArr = [MyCarInfoCarModel mj_objectArrayWithKeyValuesArray:arr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.popViewWithMyCarList showInView:self.view thePopViewTableViewHeight:0 WithArray:weakSelf.saveMyCarListArr];
                });
            }
          
        }
    }];
}
- (void)textFTopTuchBtnAction{
    DLog(@"cellsub  点击tf 跳转去h5 输车牌");
    CarPaltWebViewVC *vc = [[CarPaltWebViewVC alloc]init];
    WEAKSELF
    vc.carPlatBlock = ^(NSString * _Nonnull carPlatStr) {
        STRONGSELF
        [strongSelf.dataSourceArr replaceObjectAtIndex:ParkingAddCarCell_rowNum_CarPares withObject: carPlatStr ];
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.navigationController.navigationBarHidden = NO;
            [strongSelf reloadRowNum:ParkingAddCarCell_rowNum_CarPares];
        });
    };
    [self pushVc:vc];
    
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}
#pragma mark ==
- (BaseTableViewFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[BaseTableViewFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 120)];
        [_footerView.footerBtn newAnBtnWithTextStr:@"去支付"];
        [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView setBtnFram:CGRectMake(0, 0, Screen_W-32, 50)];
        [_footerView.footerBtn newAnBtnWithLayerCorNerNum:8 withLayerLineWidth:0 withLayerLineColor:[UIColor whiteColor]];

    }
    return _footerView;
}

- (PopViewOfParkingCarPosition *)popViewCarPosition{
    _popViewCarPosition = [[PopViewOfParkingCarPosition alloc]init];
    _popViewCarPosition.delegate = self;
    return _popViewCarPosition;
}

- (PopViewWithMyCarList *)popViewWithMyCarList{
    _popViewWithMyCarList = [[PopViewWithMyCarList alloc]init];
    _popViewWithMyCarList.delegate = self;
    return _popViewWithMyCarList;
}

- (void)footerBtnAction{
    DLog(@"去支付");
    NSMutableDictionary *parms = [[NSMutableDictionary alloc]init];

    NSNumber *allMoney =  [self.dataSourceArr.lastObject numberValue];
    NSInteger month =  [self.dataSourceArr[ParkingAddCarCell_rowNum_MonthNum] intValue];
    NSString *carPlateStr = self.dataSourceArr[ParkingAddCarCell_rowNum_CarPares];

    if ([allMoney isEqual:0] || month == 0) {
        Y_SVP_SHOW_ERR_MES(@"不能0个月！");
        return;
    }
    if (carPlateStr.length == 0) {
        Y_SVP_SHOW_ERR_MES(@"请输入车牌信息！");
        return;
    }
    if (self.saveChooseCarPosition.carPosition.length == 0) {
        Y_SVP_SHOW_ERR_MES(@"请选择停车位！");
        return;
    }

    [parms setValue:allMoney forKey:@"money"];
    [parms setValue:@(month) forKey:@"month"];
    [parms setValue:carPlateStr forKey:@"carPlate"];
    [parms setValue:@(self.saveChooseCarPosition.id) forKey:@"carPositionId"];
    [parms setValue:@([ShareUserInfo sharedUserInfo].commuityInfo.ID) forKey:@"communityId"];

    WEAKSELF
    [ParkingCarData parkingBindingMonthCarWithParkCarInfoDic:parms withBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            Y_SVP_SHOW_SUCCESS_MES(@"绑定车辆需要进行缴费，等待缴费信息");
            NSString *dataOrderIdStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"OrderIdStr"]];
            NSLog(@"parkingbindingMonthCarWithParkCarInfoDic %@ \n %@",dic,dataOrderIdStr);
            dispatch_async(dispatch_get_main_queue(), ^{
            //支付跳转
                ParkingMonthlyTenancyPayRenewaGoPayingVC *vc = [[ParkingMonthlyTenancyPayRenewaGoPayingVC alloc]init];
                vc.title = @"支付";
                vc.dataOrderIdStr = dataOrderIdStr;
                vc.moneyNum = [allMoney doubleValue];
                [weakSelf pushVc:vc];
            });
        }
    }];
}
@end
