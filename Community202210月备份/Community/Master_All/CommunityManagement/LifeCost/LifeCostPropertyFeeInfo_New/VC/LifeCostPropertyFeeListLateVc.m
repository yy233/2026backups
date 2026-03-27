//
//  LifeCostPropertyFeeListLateVc.m
//  Community
//
//  Created by 余莹 on 2022/5/19.
//

#import "LifeCostPropertyFeeListLateVc.h"
#import "ZYPropertyPayCostPayVc.h"
#import "LifeCostPropertyFeeListNomalInfoCell.h"
#import "LifeCostPropertyFeeListLateUseInfoModel.h"

#import "MyHouseData.h"
#import "MyHouseCerEdHouseModel.h"
//#import "MyHouseRelationMeAllTypeHouseModel.h"

static    NSString *listUrl = @"proprietor/FinanceOrder/list";

@interface LifeCostPropertyFeeListLateVc ()
@property (nonatomic,strong) NSMutableArray *allMonthInfoArr;//所有列表信息
@property (nonatomic,strong) MyHouseRelationMeAllTypeHouseModel *nowHouseModel;
@property (nonatomic,strong) NSString *showInTopViewAddressStr;
@end

@implementation LifeCostPropertyFeeListLateVc

- (void)viewDidLoad {
    //初始数据
    self.nowHouseModel = [[MyHouseRelationMeAllTypeHouseModel alloc]init];
    self.nowHouseModel.communityId = [UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.communityId;
    self.nowHouseModel.houseId = [UserNowCommitRightManager shareManager].nowCommunitRightAllDataModel.houseId;
    self.nowHouseModel.communityText = [ShareUserInfo sharedUserInfo].commuityInfo.name;
    self.nowHouseModel.houseSite =  [ShareUserInfo sharedUserInfo].commuityInfo.detailAddress;
    self.showInTopViewAddressStr  = [NSString stringWithFormat:@"%@%@",self.nowHouseModel.communityText,self.nowHouseModel.houseSite];
    [super viewDidLoad];
    
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"PROPERTYPAYCOST_PAY_SUCCESS_BACK", propertyPayCostPaySuccessBack);
}
// 通知回调
- (void)propertyPayCostPaySuccessBack {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initData];
    });
}
// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"PROPERTYPAYCOST_PAY_SUCCESS_BACK");
}
#pragma mark === 重写
- (void)initData{
    WEAKSELF
    [self upTopAddressBtnUI];//切房屋 UI刷新一下
    
    
    NSMutableDictionary *parms = [NSMutableDictionary dictionaryWithCapacity:0];
    [parms setValue:@(self.nowHouseModel.houseId) forKey:@"houseId"];
    [parms setValue:@(self.selfViewStaus) forKey:@"orderStatus"];// 0.未缴 1.已缴
    
    [[ToolOfNetWork sharedTools]YYrequestALLURLGetNotMainQueue:Y_BASEURL(listUrl) withParams:parms finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                weakSelf.allMonthInfoArr = [LifeCostPropertyFeeListLateUseInfoModel mj_objectArrayWithKeyValuesArray:Y_ResponsObject_dataArr];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
             }else{
                 Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
             Y_SVP_SHOW_ERR_DESCRIPTION
        }
        
    }];

}
#pragma mark === topView
- (void)upTopAddressBtnUI{
    [self.topView.addressBtn newAnBtnWithTextStr:[TextShowWithModelStr textShowWithModelStr: self.showInTopViewAddressStr]];
    [self.topView.addressBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:5.0];
}

 

#pragma mark === cell
//跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return;
    }
    LifeCostPropertyFeeListLateUseInfoModel *model  =  self.allMonthInfoArr[indexPath.section];
    LifeCostPropertyFeeListLateUseInfoModelSubTypeModel *subModel = model.list[indexPath.row-1];
    ZYPropertyPayCostPayVc *vc = [[ZYPropertyPayCostPayVc alloc] init];
    vc.pageType = subModel.pageType;
    vc.ID = subModel.idStr;
    if (self.selfViewStaus == LifeCostPropertyFeeListVcTopView_Staus_NoPay ) {//未缴纳
        vc.orderStatus = 0;
    }else if(self.selfViewStaus == LifeCostPropertyFeeListVcTopView_Staus_Payed){//已经缴纳
        vc.orderStatus = 1;
    }
    [self pushVc:vc];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allMonthInfoArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    LifeCostPropertyFeeListLateUseInfoModel *model = self.allMonthInfoArr[section];
    return  model.list.count +1;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    }else{
        return 75.0;
    }

}
//组headerV 置空 title做出row0
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {//月份cell
        LifeCostPropertyFeeListCenterShowMonthInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCostPropertyFeeListCenterShowMonthInfoCell_I ];
        if (!cell) {
            cell =  [[LifeCostPropertyFeeListCenterShowMonthInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostPropertyFeeListCenterShowMonthInfoCell_I];
        }
        LifeCostPropertyFeeListLateUseInfoModel *model  =  self.allMonthInfoArr[indexPath.section];
        cell.centerL.text = [TextShowWithModelStr textShowWithModelStr:model.roomName];//月份
        return cell;
        
    }else{//数据cell
        if (self.selfViewStaus == LifeCostPropertyFeeListVcTopView_Staus_Payed) {//已支付的列表
            return [self tableView:tableView payedCellForRowAtIndexPath:indexPath];
        }else{
            return [self tableView:tableView willPayCellForRowAtIndexPath:indexPath];
        }
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView payedCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LifeCostPropertyFeeListLateUseInfoModel *model  =  self.allMonthInfoArr[indexPath.section];
    LifeCostPropertyFeeListLateUseInfoModelSubTypeModel*subModel = model.list[indexPath.row-1];
    
    LifeCostPropertyFeeListNomalInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCostPropertyFeeListNomalInfoCell_I];
    if (!cell) {
        cell = [[LifeCostPropertyFeeListNomalInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostPropertyFeeListNomalInfoCell_I];
    }
    cell.moneyL.text = [NSString stringWithFormat:@"已缴¥%0.2f",subModel.totalMoney];
    cell.typeNameL.text = [TextShowWithModelStr textShowWithModelStr:subModel.rise];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView willPayCellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LifeCostPropertyFeeListLateUseInfoModel *model  =  self.allMonthInfoArr[indexPath.section];
    LifeCostPropertyFeeListLateUseInfoModelSubTypeModel*subModel = model.list[indexPath.row-1];

    LifeCostPropertyFeeListChooseBtnAndInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCostPropertyFeeListChooseBtnAndInfoCell_I];
    if (!cell) {
        cell = [[LifeCostPropertyFeeListChooseBtnAndInfoCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostPropertyFeeListChooseBtnAndInfoCell_I];
    }
    cell.moneyL.text = [NSString stringWithFormat:@"应缴¥%0.2f",subModel.totalMoney];
    cell.typeNameL.text = [TextShowWithModelStr textShowWithModelStr:subModel.rise];
    WEAKSELF
    cell.gouXuanBlock = ^(BOOL isSelected) {
        DLog(@"cell点击的某行选择非选择");
        if (!isSelected) {
            weakSelf.bottomView.chooseBtn.selected = NO;//cell内只要有一个取消选择状态 则bottom 非全选
        }
        [weakSelf sectionSubOneTypeCellChooseBtnActionWithIsSeletedBool:isSelected withIndexPath:indexPath];
    };
    cell.leftChooseBtn.selected =  subModel.isSelectedUIBool ;//是否选择的btn显示状态
    return cell;
}

//未支付 点击leftbtn选择
- (void)sectionSubOneTypeCellChooseBtnActionWithIsSeletedBool:(BOOL )isSelectedBool withIndexPath:(NSIndexPath *)indexPath{
    
    LifeCostPropertyFeeListLateUseInfoModel *model  =  self.allMonthInfoArr[indexPath.section];
    LifeCostPropertyFeeListLateUseInfoModelSubTypeModel*subModel = model.list[indexPath.row-1];
    subModel.isSelectedUIBool = isSelectedBool;
    [model.list replaceObjectAtIndex:indexPath.row-1 withObject:subModel];
    [self chooseDidSelectedWithShowOrHiddenBottomPayViewAndDealMoney];
    [self.tableView reloadData];
}

#pragma mark === popView

- (void)topAddressBtnTouchAction{//切换房屋
   [SVProgressHUD showWithStatus:@"正在加载"];[SVProgressHUD dismissWithDelay:5.0];
    
    
    [MyHouseData getMyHousesHaveRelattionListWithBlock:^(NSArray * arr, BOOL success) {
        Y_SVP_DISMISS;
        if (success) {
            if (arr.count<=0) {
                Y_SVP_SHOW_INFO_MES(@"暂无可切换的房屋");
                return;//不做切换
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popViewWithChangeCommunity showInViewWithPopType:MyHouseListChangeShowHouseList_Type_House withListArray:arr.mutableCopy];
            });
        }
    }];
    
}

- (void)okBtnWithChooseListCellWithPopType:(IssuLastAddressCellSubBasePopView_Type)type withCellData:(nonnull NSDictionary *)dic{
    if (isNil(dic)) {
        return;
    }
    DLog(@"okBtnWithChooseListCellWithPopType  == %@",dic);
    
    
    MyHouseRelationMeAllTypeHouseModel *model = [MyHouseRelationMeAllTypeHouseModel mj_objectWithKeyValues:dic];
    if (model.houseId == self.nowHouseModel.houseId) {
        return;//同一个门牌 不做后续处理
    }
    self.nowHouseModel.houseId = model.houseId;
    self.nowHouseModel.communityId = model.communityId;
    self.showInTopViewAddressStr = [NSString stringWithFormat:@"%@%@",[TextShowWithModelStr textShowWithModelStr:model.communityText] ,[TextShowWithModelStr textShowWithModelStr:model.houseSite]];//如果不切换 则当前名字初始化时的最高级别小区数据
    [self initData];
}
#pragma mark === bottom view
//点击数据更新后 更新bottom的数据
- (void)chooseDidSelectedWithShowOrHiddenBottomPayViewAndDealMoney{
    if ( self.selfViewStaus == LifeCostPropertyFeeListVcTopView_Staus_Payed) {//已支付的列表 不显示bottomv
        self.bottomView.hidden = YES;//隐藏
        return;
    }
    
    BOOL bottomViewIsShow = NO;
    double allMoney = 0.0;
    [self.payOrderIdArrs removeAllObjects];
    
    for (int i = 0; i < self.allMonthInfoArr.count; i ++) {
        LifeCostPropertyFeeListLateUseInfoModel *model = self.allMonthInfoArr[i];
        for (LifeCostPropertyFeeListLateUseInfoModelSubTypeModel *subModel  in model.list) {
            if ( subModel.isSelectedUIBool == YES) {
                allMoney += subModel.totalMoney;//累加钱
                bottomViewIsShow = YES;//只要有选择 就显示bottomv
                [self.payOrderIdArrs addObject:subModel.idStr];//订单的ID处理
            }
        }
    }
    [self.bottomView fillBottomViewAllMoney:allMoney];
    self.bottomView.hidden = !bottomViewIsShow;
}

#pragma mark == LifeCostPropertyFeeListVcBottomPayInfoViewDelegate
 
//bottom全选按钮
- (void)bottomViewTouchAllChooseBtnWithSelectedBool:(BOOL)selectedBool{

    for (int i = 0; i < self.allMonthInfoArr.count; i ++) {
        LifeCostPropertyFeeListLateUseInfoModel *model = self.allMonthInfoArr[i];
        for (LifeCostPropertyFeeListLateUseInfoModelSubTypeModel *subModel  in model.list) {
            subModel.isSelectedUIBool = selectedBool;
        }
    }
    [self.tableView reloadData];
    [self chooseDidSelectedWithShowOrHiddenBottomPayViewAndDealMoney];
}
//bottom 立即缴费
- (void)bottomViewTouchPayBtnWithMoneyNum:(double)moneyN{
    DLog(@"立即缴费 %0.2f \n willPayOrderIdArr= %@",moneyN,self.payOrderIdArrs);
//    payOrderIdArrs moneyN
    self.payMoeyNumDouble = moneyN;
    [self choosePayType];
}



@end
