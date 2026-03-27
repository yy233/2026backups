//
//  HouseRepairDetailShowVC.m
//  Community
//
//  Created by 余莹 on 2020/12/25.
//

#import "HouseRepairDetailShowVC.h"

#import "HouseRepairShowDismissResonVC.h"
//#import "HouseRepairDetailShowTopTableViewCell.h"//弃用
#import "HouseRepairDetailShowTopHeaderTableViewCell.h"
#import "HouseRepairDetailShowHouseInfoTableViewCell.h"
#import "HouseRepairDetailShowOrderInfoTableViewCell.h"
#define HouseRepairDetailShowTopHeaderTableViewCell_Identifier @"HouseRepairDetailShowTopHeaderTableViewCell"
#define HouseRepairDetailShowHouseInfoTableViewCell_Identifier @"HouseRepairDetailShowHouseInfoTableViewCell"
#define HouseRepairDetailShowOrderInfoTableViewCell_Identifier @"HouseRepairDetailShowOrderInfoTableViewCell"

#define Cell_H_Top_Type_Nomal 170
#define Cell_H_Top_Type_Ing   130
#define Cell_H_HouseInfo      200
#define Cell_H_OrderInfo      170
@interface HouseRepairDetailShowVC () <HouseRepairDetailShowOrderInfoTableViewCellDelegate,HouseRepairDetailTopHeaderTableViewCellDelegate>
@property (nonatomic,strong) HouseRepairDetailModel *model;
@end

@implementation HouseRepairDetailShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报修详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
 
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addRefresh];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)initData{
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:@(self.IDNum) forKey:@"id"];
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Get_House_RepairDetail withParams:parms finished:^(id responsObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            Y_SVP_DISMISS
        });
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                self.model  = [HouseRepairDetailModel mj_objectWithKeyValues:Y_ResponsObject_dataDic];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}

#pragma mark ==
- (void)removeThisRepairWithModel:(HouseRepairListModel *)model{
    //取消
    NSLog(@"取消");
    [[ToolOfNetWork sharedTools]YrequestGetURLNotMainQueue:URL_Post_House_Repari_cancelRepair withParams:@{@"id":@(model.ID)}.mutableCopy finished:^(id responsObject, NSError *error) {
        if (isNotNil(responsObject)) {
            if (Y_IS_Success) {
                Y_SVP_SHOW_SUCCESS_MES(@"已申请取消本次报修");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView.mj_header beginRefreshing];
                });
            }else{
                Y_SVP_SHOW_ERR_MESSAGE
            }
        }else{
            Y_SVP_SHOW_ERR_DESCRIPTION
        }
    }];
}
- (void)showDismissReasonWithModel:(HouseRepairListModel *)model{
    NSLog(@"展示驳回原因");
    HouseRepairShowDismissResonVC *vc = [[HouseRepairShowDismissResonVC alloc]init];
    vc.IDNum = model.ID;
    [self pushVc:vc];
    
}
//评价
- (void)evaluatThisRepairWithModel:(HouseRepairListModel *)model{
    NSLog(@"评价");
    AdviceVc *vc = [[AdviceVc alloc]init];
    vc.houseRepairId =  model.ID;
    [self pushVc:vc];
}
#pragma mark ===
- (void)copyBtnIsTouch{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.model.number;//订单号的复制
    NSString *msg = [NSString stringWithFormat:@"订单号复制成功：\n %@", pboard.string];
    Y_SVP_SHOW_SUCCESS_MES(msg);
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.model.phone.length==0) {//无数据时暂不处理UI
        return 0;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            switch (_model.status) {
                case HouseRepair_Status_Ing:
                {
                    return Cell_H_Top_Type_Ing;
                }
                    break;
                default:
                {
                    return Cell_H_Top_Type_Nomal;
                }
                    break;
            }
        }
            break;
        case 1:
        {
            return Cell_H_HouseInfo;
        }
            break;
        case 2:
        {
            return Cell_H_OrderInfo;
        }
            break;
            
        default:
            return Cell_H_Top_Type_Nomal;
            break;
    }
    return Cell_H_Top_Type_Nomal;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        HouseRepairDetailShowTopHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairDetailShowTopHeaderTableViewCell_Identifier];
        if (!cell) {
            cell = [[HouseRepairDetailShowTopHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HouseRepairDetailShowTopHeaderTableViewCell_Identifier];
        }
        cell.IDNum = self.IDNum;
        cell.detailModel = self.model;
        cell.delegate = self;
        return cell;
    }else if (indexPath.row==1){
        HouseRepairDetailShowHouseInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairDetailShowHouseInfoTableViewCell_Identifier];
        if (!cell) {
            cell = [[HouseRepairDetailShowHouseInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HouseRepairDetailShowHouseInfoTableViewCell_Identifier];
        }
        cell.detailModel = self.model;
        return cell;

    }else{
        HouseRepairDetailShowOrderInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:HouseRepairDetailShowOrderInfoTableViewCell_Identifier];
        if (!cell) {
            cell = [[HouseRepairDetailShowOrderInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:HouseRepairDetailShowOrderInfoTableViewCell_Identifier];
        }
        cell.detailModel = self.model;
        cell.delegate = self;
        return cell;
    }
}
#pragma mark ==
- (HouseRepairDetailModel *)model{
    if (!_model) {
        _model = [[HouseRepairDetailModel alloc]init];
    }
    return _model;
}
@end
