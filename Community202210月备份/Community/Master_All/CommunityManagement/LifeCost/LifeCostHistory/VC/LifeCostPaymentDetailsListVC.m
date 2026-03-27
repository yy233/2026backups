//
//  LifeCostPaymentDetailsListVC.m
//  Community
//
//  Created by 余莹 on 2021/1/9.
//  缴费记录 列表 历史列表

#import "LifeCostPaymentDetailsListVC.h"
//#import "LifeCostPaymentListVcHeaderView.h"
#import "LifeCostPayMentListVcHeaderShaiXuanView.h"
#import "LifeCosHistorytlListViewModel.h"
#import "LifeCostPaymentDetailTopViewModel.h"
//
#import "LifeCostPaymentDetailsListOneRowTimeShowTableViewCell.h"
#import "LifeCostPaymentDetailsListTableViewCell.h"
#define  LifeCostPaymentDetailsListTableViewCell_Identifier               @"LifeCostPaymentDetailsListTableViewCell"
#define  LifeCostPaymentDetailsListOneRowTimeShowTableViewCell_Identifier @"LifeCostPaymentDetailsListOneRowTimeShowTableViewCell"
#define  Last_Section_Num 3
#define H_HeaderChooseView  50 //顶部筛选view
@interface LifeCostPaymentDetailsListVC () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic,strong) LifeCostPaymentListVcHeaderView *headerView;//弃用btn 改用筛选
@property (nonatomic,strong) LifeCostPayMentListVcHeaderShaiXuanView *headerSahiXuanView;
@property (nonatomic,assign) NSInteger payMonth;
@property (nonatomic,assign) NSInteger payYear;
@property (nonatomic,strong) NSDictionary *allDataSourceDic;
@property (nonatomic,strong) NSMutableArray *allDataSourceDicMonthStrKeyArr;
@end

@implementation LifeCostPaymentDetailsListVC

- (void)viewDidLoad {
    self.payMonth = 0;
    self.payYear = 0;
    self.allDataSourceDic = [[NSDictionary alloc]init];
    self.allDataSourceDicMonthStrKeyArr = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    self.title = @"缴费记录";
//    [self.view addSubview:self.headerView];//和tableView同级
    [self.view addSubview:self.headerSahiXuanView];//和tableView同级
    [self.view addSubview:self.tableView];
    [self initData];
}
 
- (void)initData{
    WEAKSELF
 
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    [parm setValue:@(self.payMonth) forKey:@"payMonth"];
    [parm setValue:@(self.payYear) forKey:@"payYear"];
    [parm setValue:self.familyId forKey:@"familyId"];
    [LifeCosHistorytlListViewModel getHistoryListWithParms:parm withlistBlock:^(NSDictionary * dic, BOOL success) {
        if (success) {
            if (![[dic allKeys] containsObject:@"map"]) {
                Y_SVP_SHOW_INFO_MES(@"数据格式错误！");
                return;
            }
            weakSelf.allDataSourceDic = dic[@"map"];//包裹着全部数据
            weakSelf.allDataSourceDicMonthStrKeyArr =  [self.allDataSourceDic  allKeys].mutableCopy;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
    
    [LifeCostPaymentDetailTopViewModel getHuHaoGetAllList:^(NSArray * arr, BOOL success) {
        if (success) {
            [weakSelf.headerSahiXuanView fillHuHaoListData:arr.mutableCopy];
        }
    }];
}
#pragma mark ==
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        return;
    }else{
        NSLog(@"xxdidSelectRowAtIndexPathxxx");
    }
    
    //账单详情
    LifeCostPaymentOneEndBillOrderDetailsVC *vc = [[LifeCostPaymentOneEndBillOrderDetailsVC alloc]init];
    NSString *key = [NSString stringWithFormat:@"%@",self.allDataSourceDicMonthStrKeyArr[indexPath.section]];
    NSArray *obj = [NSArray arrayWithArray:self.allDataSourceDic[key]];
    LifeCostHistoryCostModel *model =  [LifeCostHistoryCostModel mj_objectWithKeyValues:obj[indexPath.row-1]];
    vc.orderId = model.orderId; 
    [self pushVc:vc];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allDataSourceDicMonthStrKeyArr.count;//
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return Last_Section_Num+1;//x+1 月份显示cell
    NSString *key = [NSString stringWithFormat:@"%@",self.allDataSourceDicMonthStrKeyArr[section]];
    NSArray *obj = [NSArray arrayWithArray:self.allDataSourceDic[key]];
    return obj.count+1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *v = [[UIView alloc]init];
//    if ([ThemeManager shareManager].type == ThemeType_White) {
//        v.backgroundColor = [UIColor whiteColor];
//    }else{
//        v.backgroundColor = [UIColor blackColor];
//    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {//日期月份show
        LifeCostPaymentDetailsListOneRowTimeShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCostPaymentDetailsListOneRowTimeShowTableViewCell_Identifier];
        if (!cell) {
            cell = [[LifeCostPaymentDetailsListOneRowTimeShowTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostPaymentDetailsListOneRowTimeShowTableViewCell_Identifier];
        }
        cell.titleTiemShowL.text = [NSString stringWithFormat:@"%@",self.allDataSourceDicMonthStrKeyArr[indexPath.section]];
        return cell;
    }else{
        LifeCostPaymentDetailsListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCostPaymentDetailsListTableViewCell_Identifier];
        if (!cell) {
            cell = [[LifeCostPaymentDetailsListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostPaymentDetailsListTableViewCell_Identifier];
        }
        NSString *key = [NSString stringWithFormat:@"%@",self.allDataSourceDicMonthStrKeyArr[indexPath.section]];
        NSArray *obj = [NSArray arrayWithArray:self.allDataSourceDic[key]];
        cell.model =  [LifeCostHistoryCostModel mj_objectWithKeyValues:obj[indexPath.row-1]];
        return cell;
    }
}

#pragma mark ===
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            CGFloat cornerRadius = 7.0f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
            BOOL addLine = NO;
            if (indexPath.row==0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            }else if(indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1){
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            }else{
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            
            //颜色修改
            layer.fillColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
            layer.strokeColor=[ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
            if (addLine == YES) {
                CALayer *lineLayer = [[CALayer alloc] init];
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);
                lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                [layer addSublayer:lineLayer];
            }
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }
}

#pragma mark ==
- (UITableView *)tableView{
    if (!_tableView) {
         _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, H_HeaderChooseView, Screen_W, Screen_H-H_HeaderChooseView-KNavBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        if ([ThemeManager shareManager].type == ThemeType_White) {
            _tableView.backgroundColor = [UIColor whiteColor];
        }else{
            _tableView.backgroundColor = [UIColor blackColor];
        }
    }
    return _tableView;
}
//- (LifeCostPaymentListVcHeaderView *)headerView{
//    if (!_headerView) {
//        _headerView  = [[LifeCostPaymentListVcHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, H_HeaderChooseView)];
//        _headerView.accountChooseBtn.selected = NO;
//        _headerView.timeChooseBtn.selected = NO;
//    }
//    return _headerView;
//}
- (LifeCostPayMentListVcHeaderShaiXuanView *)headerSahiXuanView{
    if (!_headerSahiXuanView) {
        _headerSahiXuanView = [[LifeCostPayMentListVcHeaderShaiXuanView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, H_HeaderChooseView)];
    }
    return _headerSahiXuanView;
}
@end
