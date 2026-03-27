//
//  MyCarWithParkingSpotListVC.m
//  Community
//
//  Created by 余莹 on 2022/5/6.
//

#import "MyCarWithParkingSpotListVC.h"
#import "MyCarWithParkingSpotHeader.h"
#import "MyCarWithParkingSpotListVcNomalShowInfoTableViewCell.h"
#import "MyCarWithParkingSpotListVcCarPalteShowTableViewCell.h"
#import "MyCarWithParkingSpotListFooterView.h"
#import "MyCarWithParkingSpotListPopChooseView.h"



@interface MyCarWithParkingSpotListVC () <BasePopTableViewChooseDelegate>
@property (nonatomic,strong)  MyCarWithParkingSpotListFooterView *footerView;
@property (nonatomic,strong)  MyCarWithParkingSpotListPopChooseView *popChooseView;
@property (nonatomic,strong) NSMutableArray *myAllCarListUseChoosePopViewData;//当前我的车辆 用来popView的总数据
@property (nonatomic,strong) NSMutableArray *myCarListTouchThisSpotUseToChoosePopViewData;//当前车位 应该显示的 我的车辆 用来popView的数据

@property (nonatomic,assign) BOOL whetherMoreCarWithIsShowEditTypeBool;//不可在本地做编辑的状态 ｜ 没有编辑行 只有展示行
@property (nonatomic,assign) NSIndexPath* nowAddCarInfoIndexPath;//当前做添加动作时记录的indexpath
@property (nonatomic,strong) NSMutableArray *addEditCarInfoArrWihtWillUp;//可编辑状态 即将要提交的数据

@end

@implementation MyCarWithParkingSpotListVC
#pragma mark =====
- (NSMutableArray *)addEditCarInfoArrWihtWillUp{
    if (!_addEditCarInfoArrWihtWillUp) {
        _addEditCarInfoArrWihtWillUp = [NSMutableArray arrayWithCapacity:0];
    }
    return _addEditCarInfoArrWihtWillUp;
}
- (NSMutableArray *)myAllCarListUseChoosePopViewData{
    if (!_myAllCarListUseChoosePopViewData) { 
        _myAllCarListUseChoosePopViewData = [NSMutableArray arrayWithCapacity:0];
    }
    return _myAllCarListUseChoosePopViewData;
}
- (NSMutableArray *)myCarListTouchThisSpotUseToChoosePopViewData{
    if (!_myCarListTouchThisSpotUseToChoosePopViewData) {
        _myCarListTouchThisSpotUseToChoosePopViewData = [NSMutableArray arrayWithCapacity:0];
    }
    return _myCarListTouchThisSpotUseToChoosePopViewData;
}
- (MyCarWithParkingSpotListFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[MyCarWithParkingSpotListFooterView alloc]initWithFrame:CGRectZero];
        [_footerView.footerBtnV.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.footerBtnV.footerBtn newAnBtnWithBackColor: kParkingSpotColor_Green];
    }
    return _footerView;
}
- (MyCarWithParkingSpotListPopChooseView *)popChooseView{
    _popChooseView = [[MyCarWithParkingSpotListPopChooseView alloc]init];
    _popChooseView.delegate = self;
    return _popChooseView;
}
- (void)footerBtnAction{
    DLog(@"footer 提交按钮");
    if (self.addEditCarInfoArrWihtWillUp.count == 0) {
        return;
    }
    ;
    NSMutableArray *willUpArr = [CarInfoBaseModel mj_keyValuesArrayWithObjectArray:self.addEditCarInfoArrWihtWillUp keys:@[@"positionId" , @"carNumber", @"communityId" ]];
    
     
    NSLog(@"willUpArr = %@",willUpArr);
    WEAKSELF
    [MyCarInfoOrParkingOrPayHistoryData myCarPakingSpotAddSubCarPlateInfoWithBody:@{@"params":willUpArr}.mutableCopy withBlock:^(NSDictionary * _Nonnull dic, BOOL success) {
        if (success) {
            //清空编辑状态的数据
            weakSelf.nowAddCarInfoIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            weakSelf.addEditCarInfoArrWihtWillUp = [NSMutableArray arrayWithCapacity:0];
            //拉列表
            [weakSelf initData];
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.footerView.footerBtnV.hidden = YES;
            });
        }
    }];
    
    
}

#pragma mark =====
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *titleStr = [NSString stringWithFormat:@"%@-%@",[ShareUserInfo sharedUserInfo].commuityInfo.name,@"我的车位"];
    self.title = titleStr;
    [self initView];
    [self addRefresh];
    [self myCarListDataWillUseChoosePopView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDIsCountBlueAndWW];
}

- (void)initView{
    self.tableView.tableFooterView = self.footerView;
    //未编辑不显示fv确定提交按钮
    self.footerView.footerBtnV.hidden = YES;
    //无数据不显示fv文本数据
    self.footerView.showTextL.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
     self.tableView.mj_header = headeerRefresh;
}
#pragma mark =====
- (void)initData{
    WEAKSELF
    [MyCarInfoOrParkingOrPayHistoryData myCarPakingSpotInfoListWithParms:@{ @"communityId" : @([ShareUserInfo sharedUserInfo].commuityInfo.ID) }.mutableCopy withBlock:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];;
        });
        if (success) {
            
            weakSelf.dataSourceArr = [NSMutableArray arrayWithArray:[MyCarWithParkingSpotModel mj_objectArrayWithKeyValuesArray:arr]];
            if (arr.count>0) {
                //有数据显示fv文本数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.footerView.showTextL.hidden = NO;
                });
                MyCarWithParkingSpotModel *oneModel =   weakSelf.dataSourceArr.firstObject;
                weakSelf.whetherMoreCarWithIsShowEditTypeBool = (oneModel.whetherMoreCar >= 1) ? NO : YES ;  //是否开启一位多车 0没有开启1开启（决定展示下面的车牌信息）｜取一个数据的状态即可｜1开启状态只展示基础信息 不可编辑
                [weakSelf.footerView fillTypeWithWhetherMoreCarBool:weakSelf.whetherMoreCarWithIsShowEditTypeBool];//展示的文本数据
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    //无数据不显示fv文本数据
                    self.footerView.showTextL.hidden = YES;
                });
            }
          
            
            //test--data-ing
//
//            //产权
//            MyCarWithParkingSpotModel *model11 = [[MyCarWithParkingSpotModel alloc]init];
//            model11.carPositionNumber = @"A00011";
//            model11.classificationName = @"三车位";
//            model11.siteClassificationName = @"小区xxx停车场111";
//            model11.dockNumber = 3;
//            model11.carPosStatus = 1;
//            model11.ID = @"1234567";
//
//            CarInfoBaseModel *carM1 = [[CarInfoBaseModel alloc]init];
//            carM1.carPlateIsOnEditing = NO;
//            carM1.carNumber = @"沪222222";
//            model11.carNumbers =  @[carM1].mutableCopy;
//
//            [weakSelf.dataSourceArr addObject:model11];
//
//            //产权
//            MyCarWithParkingSpotModel *model = [[MyCarWithParkingSpotModel alloc]init];
//            model.carPositionNumber = @"A0001";
//            model.classificationName = @"三车位";
//            model.siteClassificationName = @"小区xxx停车场yyy";
//            model.dockNumber = 3;
//            model.carPosStatus = 1;
//            model.ID = @"1234567888";
//
//            CarInfoBaseModel *carM = [[CarInfoBaseModel alloc]init];
//            carM.carPlateIsOnEditing = NO;
//            carM.carNumber = @"沪111111";
//
//            CarInfoBaseModel *carMz = [[CarInfoBaseModel alloc]init];
//            carMz.carPlateIsOnEditing = NO;
//            carMz.carNumber = @"沪777777";
//            model.carNumbers = @[carM,carMz].mutableCopy;
//
//            [weakSelf.dataSourceArr addObject:model];
            //test_end

         
            //清空编辑状态的数据
            weakSelf.nowAddCarInfoIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            weakSelf.addEditCarInfoArrWihtWillUp = [NSMutableArray arrayWithCapacity:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                weakSelf.footerView.footerBtnV.hidden = YES;//非编辑状态 不显示footer

            });
        }
    }];
}
- (void)myCarListDataWillUseChoosePopView{
    WEAKSELF
    [MyCarInfoOrParkingOrPayHistoryData myCarInfoListWithParms:@{@"communityId": @( [ShareUserInfo sharedUserInfo].commuityInfo.ID) }.mutableCopy withBlock:^(NSArray * _Nonnull arr,  BOOL success) {
        if (success) {
            weakSelf.myAllCarListUseChoosePopViewData = [NSMutableArray arrayWithArray: [CarInfoBaseModel mj_objectArrayWithKeyValuesArray:arr]];
        }
    }];
}

//- (void)initData111{
//
//    for (int i = 0; i < 8; i++) {
//        CarInfoBaseModel *carInfoModel = [[CarInfoBaseModel alloc]init];
//        carInfoModel.carNumber = [NSString stringWithFormat:@"车牌号码xxx_%d",i];
//        [self.myCarListData addObject:carInfoModel];
//    }
//    //多车位
//    //产权
//    MyCarWithParkingSpotModel *model = [[MyCarWithParkingSpotModel alloc]init];
//    model.carPositionNumber = @"A0001";
//    model.classificationName = @"三车位";
//    model.siteClassificationName = @"小区xxx停车场yyy";
//    model.dockNumber = 3;
//    model.carPosStatus = 1;
//
//    NSMutableArray *a1 = @[].mutableCopy;
//    for (int i = 0; i <3; i++) {
//        NSString *s = [NSString stringWithFormat:@"多位的车牌_%d",i];
//        CarInfoBaseModel *carM = [[CarInfoBaseModel alloc]init];
//        carM.carPlateIsOnEditing = NO;
//        carM.carNumber = s;
//        [a1 addObject:carM];
//    }
//    model.carNumbers =  a1;
//
//    //月租
//    MyCarWithParkingSpotModel *modelz = [[MyCarWithParkingSpotModel alloc]init];
//    modelz.carPositionNumber = @"B0001";
//    modelz.classificationName = @"三车位";
//    modelz.siteClassificationName = @"小区xxx停车场yyy";
//    modelz.dockNumber = 3;
//    modelz.carPosStatus = 2;
//
//    NSMutableArray *a2 = @[].mutableCopy;
//    for (int i = 0; i <2; i++) {
//        NSString *s = [NSString stringWithFormat:@"有空位的多位的车牌_%d",i];
//        CarInfoBaseModel *carM = [[CarInfoBaseModel alloc]init];
//        carM.carPlateIsOnEditing = NO;
//        carM.carNumber = s;
//        [a2 addObject:carM];
//    }
//    modelz.carNumbers =  a2;
//    //单车位
//    MyCarWithParkingSpotModel *modelp = [[MyCarWithParkingSpotModel alloc]init];
//    modelp.carPositionNumber = @"A0002";
//    modelp.classificationName = @"单车位";
//    modelp.siteClassificationName = @"小区xxx停车场yyy";
//    modelp.dockNumber = 1;
//    modelp.carPosStatus = 1;
//    CarInfoBaseModel *carM0 = [[CarInfoBaseModel alloc]init];
//    carM0.carPlateIsOnEditing = NO;
//    carM0.carNumber = @"车牌_0";
//    modelp.carNumbers = @[
//        carM0,
//    ].mutableCopy;
//
//    MyCarWithParkingSpotModel *modelpz = [[MyCarWithParkingSpotModel alloc]init];
//    modelpz.carPositionNumber = @"B0002";
//    modelpz.classificationName = @"单车位";
//    modelpz.siteClassificationName = @"小区xxx停车场yyy";
//    modelpz.dockNumber = 1;
//    modelpz.carPosStatus = 2;
//    CarInfoBaseModel *carM1 = [[CarInfoBaseModel alloc]init];
//    carM1.carPlateIsOnEditing = NO;
//    carM1.carNumber = @"车牌_1";
//    modelpz.carNumbers = @[
//        carM1,
//    ].mutableCopy;
//
//    //单车位  空车
//    MyCarWithParkingSpotModel *modelp0 = [[MyCarWithParkingSpotModel alloc]init];
//    modelp0.carPositionNumber = @"A0000";
//    modelp0.classificationName = @"单车位";
//    modelp0.siteClassificationName = @"小区xxx停车场yyy";
//    modelp0.dockNumber = 1;
//    modelp0.carPosStatus = 1;;
//    modelp0.carNumbers = @[
//    ].mutableCopy;
//    MyCarWithParkingSpotModel *modelpz0 = [[MyCarWithParkingSpotModel alloc]init];
//    modelpz0.carPositionNumber = @"B0000";
//    modelpz0.classificationName = @"单车位";
//    modelpz0.siteClassificationName = @"小区xxx停车场yyy";
//    modelpz0.dockNumber = 1;
//    modelpz0.carPosStatus = 2;;
//    modelpz0.carNumbers = @[
//    ].mutableCopy;
//
//    self.dataSourceArr = [NSMutableArray arrayWithObjects:model,modelz,modelp,modelpz,modelp0,modelpz0, nil];
//
////    self.isCanNotEditBool = YES;
//    self.whetherMoreCarBool = NO;
//    [self.footerView fillTypeWithWhetherMoreCarBool:self.whetherMoreCarBool];//展示的文本数据
//}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MyCarWithParkingSpotModel *model = self.dataSourceArr[section];
  
    
    if (self.whetherMoreCarWithIsShowEditTypeBool) {//0没有开启 1开启
        return 2+model.dockNumber;//最大数量行 (基础信息+底部圆角+车牌最多的数量行)
        //return 2+model.carNumbers.count;//有几个车牌行 (基础信息+底部圆角+车牌现有的行数)
    }else{
        return  2;//非开启状态只显示基础车位信息 不显示车牌（基础信息+底部圆角）最小数量行
    }
    
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 80;//基础信息行
    }else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){//底部占位做空白圆角用
        return 10;
    }else{
        return 60;//车牌行
    }
    
  
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCarWithParkingSpotModel *model = self.dataSourceArr[indexPath.section];

    if (indexPath.row == 0) {
        MyCarWithParkingSpotListVcNomalShowInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCarWithParkingSpotListVcNomalShowInfoTableViewCell_I];
        if(!cell){
            cell = [[MyCarWithParkingSpotListVcNomalShowInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyCarWithParkingSpotListVcNomalShowInfoTableViewCell_I];
        }
        [cell fillModel:model];
        return cell;
    }else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){//底部占位做空白圆角用
        MyCarWithParkingSpotListVcBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCarWithParkingSpotListVcBottomTableViewCell_I];
        if(!cell){
            cell = [[MyCarWithParkingSpotListVcBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyCarWithParkingSpotListVcBottomTableViewCell_I];
        }
        return cell;
    }else{
        
        if ((indexPath.row) > model.carNumbers.count) {//编辑行
            
            MyCarWithParkingSpotListVcCarPalteNilShowCanAddActionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCarWithParkingSpotListVcCarPalteNilShowCanAddActionTableViewCell_I];
            if(!cell){
                cell = [[MyCarWithParkingSpotListVcCarPalteNilShowCanAddActionTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyCarWithParkingSpotListVcCarPalteNilShowCanAddActionTableViewCell_I];
            }
            WEAKSELF
            cell.touchAddBtnBlock = ^{
                [weakSelf communitySoptCellAddActionWithIndexPath:indexPath];
            };
            return cell;
             
        }else{//车牌展示行
            
            CarInfoBaseModel *carPalteInfoModel = model.carNumbers[indexPath.row-1];
            if (!carPalteInfoModel.carPlateIsOnEditing) {//是否为当前编辑的车牌bool状态
                //原数据展示类
                MyCarWithParkingSpotListVcCarPalteShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCarWithParkingSpotListVcCarPalteShowTableViewCell_I];
                if(!cell){
                    cell = [[MyCarWithParkingSpotListVcCarPalteShowTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyCarWithParkingSpotListVcCarPalteShowTableViewCell_I];
                }
                
                [cell fillCarPlateStr: [TextShowWithModelStr textShowWithModelStr:carPalteInfoModel.carNumber]];
                return cell;
            }else{
                //编辑数据展示类
                MyCarWithParkingSpotListVcCarPalteCanDeleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyCarWithParkingSpotListVcCarPalteCanDeleteTableViewCell_I];
                if(!cell){
                    cell = [[MyCarWithParkingSpotListVcCarPalteCanDeleteTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyCarWithParkingSpotListVcCarPalteCanDeleteTableViewCell_I];
                }
                [cell fillCarPlateStr: [TextShowWithModelStr textShowWithModelStr:carPalteInfoModel.carNumber]];
                WEAKSELF
                cell.touchDeletBtnBlock = ^{
                    [weakSelf deletCarInfoWithIndexPath:indexPath];
                };
                return cell;
            }
        }
    
    }

}

#pragma mark =====

//增加 弹出框
- (void)communitySoptCellAddActionWithIndexPath:(NSIndexPath *)indexPath{
    self.nowAddCarInfoIndexPath = indexPath;
    self.myCarListTouchThisSpotUseToChoosePopViewData = [NSMutableArray arrayWithCapacity:0];
    //做车牌过滤
   
    if (self.myAllCarListUseChoosePopViewData.count == 0) {//无
        WEAKSELF
        [MyCarInfoOrParkingOrPayHistoryData myCarInfoListWithParms:@{@"communityId": @( [ShareUserInfo sharedUserInfo].commuityInfo.ID) }.mutableCopy withBlock:^(NSArray * _Nonnull arr,  BOOL success) {
            if (success) {
                weakSelf.myAllCarListUseChoosePopViewData = [NSMutableArray arrayWithArray: [CarInfoBaseModel mj_objectArrayWithKeyValuesArray:arr]];
                weakSelf.myCarListTouchThisSpotUseToChoosePopViewData = [NSMutableArray arrayWithArray:weakSelf.myAllCarListUseChoosePopViewData];

                //过滤
                [weakSelf guoLuWillPopCarModel];
            }
        }];
    }else{//有
        self.myCarListTouchThisSpotUseToChoosePopViewData = [NSMutableArray arrayWithArray:self.myAllCarListUseChoosePopViewData];
        //过滤
        [self guoLuWillPopCarModel];
    }   
}

- (void)guoLuWillPopCarModel{
    //过滤
    //当前车位 已经有了的车位牌 不能在popV出现 导致一个车位全部都是同车牌的情况 |要减去 自带的 要减去正要提交的
    MyCarWithParkingSpotModel *spotModel = self.dataSourceArr[self.nowAddCarInfoIndexPath.section]; //当前车位
    NSMutableArray *thisSpotAllShowCarsArr = [NSMutableArray arrayWithArray:spotModel.carNumbers];//当前车位 initData数据
    NSMutableArray *thisSpotWillUpArr = [NSMutableArray arrayWithCapacity:0];//当前车位 willUp的编辑状态数据
     
    [self.addEditCarInfoArrWihtWillUp enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {//重复Model项目增入 防治点击过快时 上级carNumbers未处理完成的情况
       CarInfoBaseModel *carM = (CarInfoBaseModel *)obj;
        if ([carM.positionId isEqualToString:spotModel.ID]) {
            [thisSpotWillUpArr addObject:carM];
        }
    }];
    [thisSpotAllShowCarsArr addObjectsFromArray: thisSpotWillUpArr];
    
    NSMutableArray *guoLuGetArr = [NSMutableArray arrayWithCapacity:0];
    
    //1.展示和选择的本筛选数据 相同的过滤
    NSString *pStr = @"NOT (SELF IN %@)";//取非 过滤modek
    NSPredicate *fPredicate = [NSPredicate predicateWithFormat:pStr, thisSpotAllShowCarsArr];
    guoLuGetArr = [NSMutableArray arrayWithArray:[self.myAllCarListUseChoosePopViewData filteredArrayUsingPredicate:fPredicate]];
    
    
//    //2.已有数据和选择筛选数据 相关名字的过滤
    NSMutableArray *objIsDicNowModelOfThisSpotAllShowCarsArr = [NSMutableArray arrayWithArray:[CarInfoBaseModel mj_keyValuesArrayWithObjectArray:thisSpotAllShowCarsArr]];
    NSString *p2Str = @"NOT (SELF.carNumber IN %@)"; //取model.某键值 非
    NSPredicate *f2Predicate = [NSPredicate predicateWithFormat:p2Str, [objIsDicNowModelOfThisSpotAllShowCarsArr valueForKey:@"carNumber"]];
    self.myCarListTouchThisSpotUseToChoosePopViewData = [NSMutableArray arrayWithArray:[guoLuGetArr filteredArrayUsingPredicate:f2Predicate]];  

    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.popChooseView showInView:self.view thePopViewTableViewHeight:0 WithArray: self.myCarListTouchThisSpotUseToChoosePopViewData ];
    });
}
- (void)guoLuWillPopCarModel111Old{//本方法会删除不该过滤的数据
    //过滤
    //当前车位 已经有了的车位牌 不能在popV出现 导致一个车位全部都是同车牌的情况
    MyCarWithParkingSpotModel *spotModel = self.dataSourceArr[self.nowAddCarInfoIndexPath.section]; //当前车位
    NSMutableArray *thisSpotCarsArr = [NSMutableArray arrayWithArray:spotModel.carNumbers];

   

    //1.总我的车辆列表

    for (int i = 0; i < self.myAllCarListUseChoosePopViewData.count; i++) {
        for (int j = 0; j < thisSpotCarsArr.count;  j++) {

            CarInfoBaseModel *allCarOneObj = self.myAllCarListUseChoosePopViewData[i];
            CarInfoBaseModel *thisSpotCarOneObj = thisSpotCarsArr[j];
            if ([allCarOneObj.carNumber isEqualToString:thisSpotCarOneObj.carNumber]) {
                //总列表该车位显示的车牌 同车牌 去掉
                NSLog(@"总列表显示的 删除 %@",allCarOneObj.carNumber);
                [self.myCarListTouchThisSpotUseToChoosePopViewData removeObjectAtIndex:i];
                break;//单层循环

            }
        }
    }

    
    
    NSMutableArray *guoLuUseDataArr = [self.myCarListTouchThisSpotUseToChoosePopViewData mutableCopy];
    //2.已经编辑状态的车辆 将要提交的数据 (防止快速点击popv时 数据不能完全走1过滤的情况)
    for (int i = 0; i <  guoLuUseDataArr.count; i++) {
        for (int j = 0; j < self.addEditCarInfoArrWihtWillUp.count;  j++) {
            CarInfoBaseModel *popWillUseSpotCarOneObj =  guoLuUseDataArr[i];
            CarInfoBaseModel *editWillUpCarOneObj = self.addEditCarInfoArrWihtWillUp[j];
            if ([spotModel.ID isEqualToString: editWillUpCarOneObj.positionId] && [popWillUseSpotCarOneObj.carNumber isEqualToString:editWillUpCarOneObj.carNumber]) {
                //即将提交的更改新增数据列表 同车牌 去掉
                NSLog(@"即将提交的更改新增数据列表 删除 %@",popWillUseSpotCarOneObj.carNumber);
                [self.myCarListTouchThisSpotUseToChoosePopViewData removeObjectAtIndex:i];
                break;//单层循环
            }
        }
    }
    
    
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.popChooseView showInView:self.view thePopViewTableViewHeight:0 WithArray: self.myCarListTouchThisSpotUseToChoosePopViewData ];
    });
    
   
}
 //弹出框拿到数据 处理成新数据
- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath{
    //1.编辑状态车辆的展示部分处理
    //新增的车信息
//    CarInfoBaseModel *carModel =  self.myAllCarListUseChoosePopViewData[indexPath.row];//有过滤 不是总列表 使用去掉了同车牌的列表
    CarInfoBaseModel *carModel =  self.myCarListTouchThisSpotUseToChoosePopViewData[indexPath.row];
    carModel.carPlateIsOnEditing = YES;
    DLog(@"popvc list choose row = %ld   %@",indexPath.row,  carModel.carNumber);
    //旧组 替换arr
    MyCarWithParkingSpotModel *spotModel =  self.dataSourceArr[self.nowAddCarInfoIndexPath.section];
    NSMutableArray *willChangeCarArr =  spotModel.carNumbers.mutableCopy;
    [willChangeCarArr addObject:carModel];
    spotModel.carNumbers = willChangeCarArr;
    //换 obj
    [self.dataSourceArr replaceObjectAtIndex:self.nowAddCarInfoIndexPath.section withObject:spotModel];
    [self.tableView reloadData];
    //编辑后才显示
    self.footerView.footerBtnV.hidden = NO;
    
    //2.编辑状态的车辆 将要提交的数据 处理
    CarInfoBaseModel *oneAddCarPateWillUpBodyInfo = [[CarInfoBaseModel alloc]init];
    oneAddCarPateWillUpBodyInfo.positionId = spotModel.ID;
    oneAddCarPateWillUpBodyInfo.carNumber = carModel.carNumber;
    oneAddCarPateWillUpBodyInfo.communityId = [NSString stringWithFormat:@"%ld",[ShareUserInfo sharedUserInfo].commuityInfo.ID];
    [self.addEditCarInfoArrWihtWillUp addObject:oneAddCarPateWillUpBodyInfo];

}

//删除
- (void)deletCarInfoWithIndexPath:(NSIndexPath *)indexPath{
    NSInteger carIndex = indexPath.row - 1;//有基础信息cell行
    NSLog(@" deletCarInfoWithIndexPath   s r   %ld  %ld ",indexPath.section,carIndex);
    
    //1.编辑状态车辆的展示部分处理
    MyCarWithParkingSpotModel *spotModel = self.dataSourceArr[indexPath.section];//用于后续数据处理 车位比对
    //旧组 删除
    NSMutableArray *willChangeCarArr =  spotModel.carNumbers.mutableCopy;
    CarInfoBaseModel *willDeletCarModel = willChangeCarArr[carIndex];//用于后续数据处理 车牌比对
    [willChangeCarArr removeObjectAtIndex:carIndex];
    //替换arr
    spotModel.carNumbers = willChangeCarArr;
    //换 obj
    [self.dataSourceArr replaceObjectAtIndex:indexPath.section withObject:spotModel];
    [self.tableView reloadData];
 
    
    //2.编辑状态的车辆 将要提交的数据们 处理当前删除
    for (CarInfoBaseModel *saveSubModel in self.addEditCarInfoArrWihtWillUp) {
        if ([saveSubModel.positionId isEqualToString: spotModel.ID] && [saveSubModel.carNumber isEqualToString:willDeletCarModel.carNumber] ) {
            [self.addEditCarInfoArrWihtWillUp removeObject:saveSubModel];
            break;
        }
    }
    
    //3.当前编辑的总数据 处理footer显示隐藏
    if (self.addEditCarInfoArrWihtWillUp.count == 0) {
        //有新增数据 才显示提交按钮
        self.footerView.footerBtnV.hidden = YES;
    }
    
    
}

@end
