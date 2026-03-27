//
//  MyOrderListVC.m
//  Community
//
//  Created by 余莹 on 2021/2/5.
//

#import "MyOrderListVC.h"
#import "MyOrderTopSearchView.h"
#import "MyOrderListVcHeaderView.h"

#import  "MyOrderListVCHeaderShopInfoTableViewCell.h"
#define   MyOrderListVCHeaderShopInfoTableViewCell_Identifier         @"MyOrderListVCHeaderShopInfoTableViewCell"
//
#import  "MyOrderListVCBottomBtnsTableViewCell.h"
#define   MyOrderListVCBottomBtnsTableViewCell_Identifier             @"MyOrderListVCBottomBtnsTableViewCell"
//
#import  "MyOrderListVcMaxDishesTableViewCell.h"
#define   MyOrderListVcMaxDishesTableViewCell_Identifier              @"MyOrderListVcMaxDishesTableViewCell"
//
#import "MyOrderTool.h"
#import "MyOrderDetailVC.h"
#import "MyOrderDetailVcWillPay.h"
#import "MyOrderDetailVcWillUse.h"
#import "MyOrderDetailVcIsCancel.h"
#import "MyOrderDetailVcEndDeal.h"
#import "MyOrderDataTool.h"
#import "MyOrderModel.h"
#import "MyOrderAgainAddAndPayTool.h"


@interface MyOrderListVC () <MyOrderListVcCellDelegate,MyOrderListVcHeaderViewDelegate>
@property (nonatomic,strong) MyOrderTopSearchView *topSearchView;
@property (nonatomic,strong) MyOrderListVcHeaderView *headerView;
@property (nonatomic,assign) MyOrderListCell_Type type;
@end

@implementation MyOrderListVC 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的订单";
    [self initView];
    [self initData];
    [self initNotice];
}
- (void)initNotice{
    Y_NSNotificationCenter_Creat_NameAction(Buniess_PopToListVC_WithReloadList, initData);
}
- (void)dealloc{
    Y_NSNotificationCenter_RemoveNotice_Name(Buniess_PopToListVC_WithReloadList);
}
//个人中心到列表页时所调用
- (void)listShowIsType:(MyOrderListCell_Type)type{
    self.type = type;
    [self.headerView showListWithType:type];
}
- (void)initView{
    [self initNav];
    self.view.backgroundColor = Color_245Gray;
    self.tableView.tableFooterView  = [UIView new];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorColor = [UIColor clearColor];
}
- (void)initNav{
    self.navigationItem.titleView = self.topSearchView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarTextColor:[UIColor blackColor] andBarItemsColor:[UIColor blackColor] andBackViewCustomColor:Color_245Gray];
}
- (void)initData{
    if (self.type==0) {//个人中心页点击过来时
        self.type = MyOrderListCell_Type_All;
    }

    [self initOrderListWithType:self.type];
}
- (void)initOrderListWithType:(MyOrderListCell_Type)type{
    self.type = type;
     Y_SVP_SHOW_MES_IsLoading_15Delay;
    WEAKSELF
    [MyOrderDataTool getOrderListWithType:type withBlock:^(NSArray * arr, BOOL success) {
        Y_SVP_DISMISS;
        if (success) {
            weakSelf.dataSourceArr = [NSMutableArray arrayWithArray:[MyOrderModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;//1组是一个订单
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {//header
        return 60;
    }else  if (indexPath.row==[tableView numberOfRowsInSection:indexPath.section]-1) {//bottom
        return 50;
    }else{

        MyOrderModel *model = self.dataSourceArr[indexPath.section];
        NSInteger TypeNum = model.appStateNum;
//        switch (TypeNum) {
//            case  MyOrderListCell_Type_All:
//                return 200;////待内处理
//                break;
//            case  MyOrderListCell_Type_WillPay:
//                return 130;
//                break;
//            case  MyOrderListCell_Type_EndDeal:
//                return 130;
//                break;
//            case  MyOrderListCell_Type_IsCancel:
//                return 130;
//                break;
//            case  MyOrderListCell_Type_WillEvaluation:
//                return 110;
//                break;
//            case  MyOrderListCell_Type_WillUse:
//                return 130;
//                break;
//
//            default:
//                return 180;
//                break;
//        }
        
        /**
         * MyOrderListCell_Type_WillPay=2, //待付款
         MyOrderListCell_Type_PayEnd =3, //3"已付款"
         MyOrderListCell_Type_WillUse=4, // 4"待使用"
         MyOrderListCell_Type_WillEvaluation=5,//"待评价5" == 已完成MyOrderListCell_Type_EndDeal
         MyOrderListCell_Type_EvaluationEnd =6,//已经评价
         MyOrderListCell_Type_ReturnComIng=7,//退款中
         MyOrderListCell_Type_ReturnComSuccess=8,//退款成功
         MyOrderListCell_Type_ReturnComRefused=9,//拒绝退款
         MyOrderListCell_Type_ReturnCom=10,//退款/售后
         */
        if (TypeNum==MyOrderListCell_Type_ReturnCom || TypeNum==MyOrderListCell_Type_ReturnComRefused  || TypeNum==MyOrderListCell_Type_ReturnComSuccess || TypeNum==MyOrderListCell_Type_ReturnComIng) {
            return 110;;
        }else{
            return 130;
        }
       
        return 1;//
    }
    return 1;//type
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyOrderModel *model = self.dataSourceArr[indexPath.section];
    //cell顶部商铺数据
     if (indexPath.row==0) {
         MyOrderListVCHeaderShopInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderListVCHeaderShopInfoTableViewCell_Identifier];
         if (!cell) {
             cell = [[MyOrderListVCHeaderShopInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderListVCHeaderShopInfoTableViewCell_Identifier];
         }
         [cell fillDataWithOrderModel:model];
       
         return cell;
     }else  if (indexPath.row==[tableView numberOfRowsInSection:indexPath.section]-1) {//bottom
        MyOrderListVCBottomBtnsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderListVCBottomBtnsTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderListVCBottomBtnsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderListVCBottomBtnsTableViewCell_Identifier];
        }
         cell.delegate = self;
         [cell fillDataWithOrderModel:model];
         NSInteger TypeNum = model.appStateNum;
         switch (TypeNum) {
             case  MyOrderListCell_Type_WillPay:
                 [cell cellUpUIWillPay];
                 break;
//             case  MyOrderListCell_Type_EndDeal:
//                 [cell cellUpUIEndDeal];
//                 break;
                 break;
             case  MyOrderListCell_Type_WillEvaluation://待评价用已完成的cell
//                 [cell cellUpUIWillEvaluation];
                 [cell cellUpUIEndDeal];
                 break;
             case  MyOrderListCell_Type_WillUse:
                 [cell cellUpUIWillUse];
                 break;
                 
             case  MyOrderListCell_Type_ReturnComIng:
                 [cell cellUpUiIsRefundSchedule];
                 break;
             case  MyOrderListCell_Type_ReturnComSuccess:
                 [cell cellUpUiIsRefundSchedule];
                 break;
             case  MyOrderListCell_Type_ReturnComRefused:
                 [cell cellUpUiIsRefundSchedule];
                 break;
             case  MyOrderListCell_Type_ReturnCom:
                 [cell cellUpUiIsRefundSchedule];
                 break;
             default:
                 NSLog(@"其他状态的cell");//不显示详情 做评论按钮
                 [cell cellUpUIWillEvaluation];
                 break;
         }
         
        return cell;
     }else  if (indexPath.row==1) {
        MyOrderListVcMaxDishesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyOrderListVcMaxDishesTableViewCell_Identifier];
        if (!cell) {
            cell = [[MyOrderListVcMaxDishesTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyOrderListVcMaxDishesTableViewCell_Identifier];
        }
        [cell fillDataWithOrderModel:model];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        return cell;
    }
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderModel *model = self.dataSourceArr[indexPath.section];
    NSInteger TypeNum = model.appStateNum;
    
//    switch (TypeNum) {
//        case MyOrderListCell_Type_WillPay:
//        {
//            MyOrderDetailVcWillPay *vc = [[MyOrderDetailVcWillPay alloc]init];
//            vc.orderModel = model;
//            [self pushVc:vc];
//        }
//            break;
//        case MyOrderListCell_Type_WillUse:
//        {
//            MyOrderDetailVcWillUse *vc = [[MyOrderDetailVcWillUse alloc]init];
//            vc.orderModel = model;
//            [self pushVc:vc];
//        }
//            break;
//        case MyOrderListCell_Type_IsCancel:
//        {
//            MyOrderDetailVcIsCancel *vc = [[MyOrderDetailVcIsCancel alloc]init];
//            vc.orderModel = model;
//            [self pushVc:vc];
//        }
//            break;
//        case MyOrderListCell_Type_EndDeal:
//        {
//            MyOrderDetailVcEndDeal *vc = [[MyOrderDetailVcEndDeal alloc]init];
//            vc.orderModel = model;
//            [self pushVc:vc];
//        }
//            break;
//        case MyOrderListCell_Type_WillEvaluation:
//        {
//            DLog(@"待评价cell 暂用 完成订单cell的详情");
//            MyOrderDetailVcEndDeal *vc = [[MyOrderDetailVcEndDeal alloc]init];
//            vc.orderModel = model;
//            [self pushVc:vc];
//        }
//            break;
//        default:
//            DLog(@"没有数据");
//            break;
//    }
    
    switch (TypeNum) {
        case MyOrderListCell_Type_WillPay:
        {
            MyOrderDetailVcWillPay *vc = [[MyOrderDetailVcWillPay alloc]init];
            vc.orderModel = model;
            [self pushVc:vc];
        }
            break;
        case MyOrderListCell_Type_WillUse:
        {
            MyOrderDetailVcWillUse *vc = [[MyOrderDetailVcWillUse alloc]init];
            vc.orderModel = model;
            [self pushVc:vc];
        }
            break;
//        case MyOrderListCell_Type_EndDeal:
//        {
//            MyOrderDetailVcEndDeal *vc = [[MyOrderDetailVcEndDeal alloc]init];
//            vc.orderModel = model;
//            [self pushVc:vc];
//        }
//            break;
        case MyOrderListCell_Type_WillEvaluation:
        {
            DLog(@"待评价cell 暂用 完成订单cell的详情");
            MyOrderDetailVcEndDeal *vc = [[MyOrderDetailVcEndDeal alloc]init];
            vc.orderModel = model;
            [self pushVc:vc];
        }
            break;
            //已取消这个list还没有用 后续vc暂不跳转 退费进度
//        case MyOrderListCell_Type_ReturnCom:
//        {
//            MyOrderDetailVcIsCancel *vc = [[MyOrderDetailVcIsCancel alloc]init];
//            vc.orderModel = model;
//            [self pushVc:vc];
//        }
//            break;
          //退费相关
        case MyOrderListCell_Type_ReturnComIng:
        {
            DLog(@"MyOrderListCell_Type_ReturnComIng");
        }
            break;
        case MyOrderListCell_Type_ReturnComSuccess:
        {
            DLog(@"MyOrderListCell_Type_ReturnComSuccess");
        }
            break;
        case MyOrderListCell_Type_ReturnComRefused:
        {
            DLog(@"MyOrderListCell_Type_ReturnComRefused");
        }
            break;
        case MyOrderListCell_Type_ReturnCom:
        {
            DLog(@"MyOrderListCell_Type_ReturnCom");
        }
            break;
        default:
            DLog(@"不跳转详情数据 只走评论按钮");
            break;
    }
}

#pragma mark ==delegate cell sub btn
- (void)touchPayBtnWithOrderModel:(MyOrderModel *)model{
    DLog(@"");
    [MyOrderAgainAddAndPayTool againPayWithOrderModel:model];
}
- (void)touchEvaluationBtnWithOrderModel:(MyOrderModel *)model{
    DLog(@"");
    MyOrderEvaluationVC *vc = [[MyOrderEvaluationVC alloc]init];
    vc.orderModel = model;
    [self pushVc:vc];
}
- (void)touchOnceAgainBtnWithOrderModel:(MyOrderModel *)model{
    DLog(@"");
    [MyOrderAgainAddAndPayTool againPayWithOrderModel:model];

    
}
- (void)touchRefundScheduleBtnWithOrderModel:(MyOrderModel *)model{
    DLog(@"");
    MyOrderRefundScheduleVC *vc = [[MyOrderRefundScheduleVC alloc]init];
    vc.orderModel = model;
    [self pushVc:vc];
    
}
#pragma mark ===
- (void)orderHeaderViewTouchUPWithListType:(MyOrderListCell_Type)type{
    self.type = type;
//    Y_SVP_SHOW_INFO_MES(@"orderHeaderViewTouchUPWithListType");

    //data
//    switch (self.type) {//获取新的 or 本地筛选
//        case  MyOrderListCell_Type_All:
//            [self initData];
//
//            break;
//        case  MyOrderListCell_Type_WillPay:
//            break;
//        case  MyOrderListCell_Type_EndDeal:
//            break;
//        case  MyOrderListCell_Type_IsCancel:
//            break;
//        case  MyOrderListCell_Type_WillEvaluation:
//            break;
//        case  MyOrderListCell_Type_WillUse:
//            break;
//        default:
//            break;
//    }
    [self initOrderListWithType:self.type];
    [self.tableView reloadData];
}
#pragma mark ===
- (MyOrderTopSearchView *)topSearchView{
    if (!_topSearchView) {
        _topSearchView = [[MyOrderTopSearchView alloc]initWithFrame: CGRectMake(0, 0, Screen_W, KNavBarHeight)];
    }
    return _topSearchView;
}
//
- (MyOrderListVcHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[MyOrderListVcHeaderView alloc]init];
        _headerView.delegate = self;
    }
    return _headerView;
}
#pragma mark ===

@end
