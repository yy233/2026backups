//
//  LifeCostPayHistoryOrderListVC.m
//  Community
//
//  Created by 余莹 on 2022/1/6.
//

#import "LifeCostPayHistoryOrderListVC.h"
#import "LifeCostPaymentListVcHeaderView.h"
#import "PopviewWithChoosePayType.h"
#import "PopviewWithChoosePayTime.h"
#import "LifeCostPayHistoryOrderListTableViewCell.h"

#define  LifeCostPayHistoryOrderListTableViewCell_Identifier                             @"LifeCostPayHistoryOrderListTableViewCell"
#define  LifeCostPayHistoryOrderListOnlyShowMonthInfTableViewCell_Identifier             @"LifeCostPayHistoryOrderListOnlyShowMonthInfTableViewCell"

#import "LifeCostPayOrderDetailWithHistoryPayCompleteInfoVC.h"

 
#import "LifeCostData.h"

#define  H_HeaderChooseView  (50)
@interface LifeCostPayHistoryOrderListVC () <LifeCostPaymentListVcHeaderViewDelegate,PopviewWithChoosePayTypeDelegate,PopviewWithChoosePayTimeDelegate>
@property (nonatomic,strong) LifeCostPaymentListVcHeaderView *headerView;
@property (nonatomic,strong) PopviewWithChoosePayType *popviewPayType;
@property (nonatomic,strong) PopviewWithChoosePayTime *popviewPayTime;
@property (nonatomic,strong) NSString *saveHeaderChoosePayTypeIDstr;
@property (nonatomic,strong) NSString *saveHeaderChoosePayTimeStr;

@end

@implementation LifeCostPayHistoryOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"缴费记录";
    [self initView];
    [self addRefresh];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDIsCountBlueAndGW];
}

- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)initView{
    self.tableView.tableHeaderView = self.headerView;
}
- (void)initData{
    WEAKSELF
    if (self.saveHeaderChoosePayTypeIDstr.length==0  && self.saveHeaderChoosePayTimeStr.length==0 ) {//初始状态全部查询
        [LifeCostData lifeCostGetPayOrderListWithPayHistoryOrderListBlock:^(NSArray * _Nonnull arr, BOOL success) {
            [weakSelf getDataListBlockWithArr:arr andSuccessBool:success];
        }];
    }else if (self.saveHeaderChoosePayTypeIDstr.length>0 && self.saveHeaderChoosePayTimeStr.length>0){
        [LifeCostData lifeCostGetPayOrderListWithTypeIdStr:self.saveHeaderChoosePayTypeIDstr andQueryTimeStr:self.saveHeaderChoosePayTimeStr withPayHistoryOrderListBlock:^(NSArray * _Nonnull arr, BOOL success) {
            [weakSelf getDataListBlockWithArr:arr andSuccessBool:success];
        }];
    }else if (self.saveHeaderChoosePayTypeIDstr.length>0){
        [LifeCostData lifeCostGetPayOrderListWithTypeIdStr:self.saveHeaderChoosePayTypeIDstr withPayHistoryOrderListBlock:^(NSArray * _Nonnull arr, BOOL success) {
            [weakSelf getDataListBlockWithArr:arr andSuccessBool:success];
        }];
    }else if (self.saveHeaderChoosePayTimeStr.length>0){
        [LifeCostData lifeCostGetPayOrderListWithQueryTimeStr:self.saveHeaderChoosePayTimeStr withPayHistoryOrderListBlock:^(NSArray * _Nonnull arr, BOOL success) {
            [weakSelf getDataListBlockWithArr:arr andSuccessBool:success];
        }];
    }
    
    //筛选空状态
    [self saiXuanTypeData];
}

- (void)getDataListBlockWithArr:(NSArray *)arr andSuccessBool:( BOOL )success{
    WEAKSELF
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView.mj_header endRefreshing];
    });
    if (success) {
        weakSelf.dataSourceArr = [NSMutableArray arrayWithArray:[LifeCostPayHistoryOrderListModel mj_objectArrayWithKeyValuesArray:arr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }
}

//筛选空状态
- (void)saiXuanTypeData{
    WEAKSELF
    if (self.nowPayTypeList.count<=0) {
        [LifeCostData lifeCostGetOneCity:[LifeCostSaveCityInfoModel share].cityName withPayTypeListWithArrBlock:^(NSArray * _Nonnull arr, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_header endRefreshing];
            });
            if (success) {
                weakSelf.nowPayTypeList  = [NSMutableArray arrayWithArray:[LifeCostPayTypeModel mj_objectArrayWithKeyValuesArray:arr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }];
    }
}
#pragma mark == action
- (void)touchOneChoosePayTypeBtn{
    DLog(@"");
    [self.popviewPayType showInView:self.view thePopViewSubViewHeight:0.0 WithArray: self.nowPayTypeList];//LifeCostPayTypeModel
}
- (void)touchOneChooseTimeBtn{
    DLog(@"");
    [self.popviewPayTime showInView:self.view thePopViewSubViewHeight:0.0 WithArray:@[].mutableCopy];
}

#pragma mark == type choose
- (void)popViewChooseALlPayType{
    self.saveHeaderChoosePayTypeIDstr = @"";//空长度
    [self.headerView fillNewShowChoosePayTypeStr:@"全部费种"];
    [self initData];
}
//费种筛选
- (void)popViewChoosePayTypeWithModel:(LifeCostPayTypeModel *)model{
    self.saveHeaderChoosePayTypeIDstr = [NSString stringWithFormat:@"%ld",model.type];
    [self.headerView fillNewShowChoosePayTypeStr:[TextShowWithModelStr textShowWithModelStr:model.typeName]];
    [self initData];
}
#pragma mark == time choose
- (void)popViewChooseALlPayTime{
    self.saveHeaderChoosePayTimeStr = @"";//空长度
    [self.headerView fillNewShowChoosePayTypeStr:@"全部时间"];
    [self initData];
}
//时间筛选
- (void)popViewChoosePayTimeWitYearAndMonthStr:(NSString *)yearAndMonthStr{
   // yearAndMonthStr = @"2022-01-01";（这种格式才可以拿到数据| 2022-01 这种格式只是用来展示）
    self.saveHeaderChoosePayTimeStr = yearAndMonthStr;
    [self.headerView fillNewShowChooseTimeStr: yearAndMonthStr];
     [self initData];
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LifeCostPayHistoryOrderListModel *sectionModel = self.dataSourceArr[indexPath.section];
    LifeCostPayHistoryOrderSubOrderEntityModel *entityModel = sectionModel.orderEntityList[indexPath.row-1];

    if(indexPath.row !=0 ){
        LifeCostPayOrderDetailWithHistoryPayCompleteInfoVC *vc = [[LifeCostPayOrderDetailWithHistoryPayCompleteInfoVC alloc]init];
        vc.oneOrderModel = entityModel;
        [self pushVc:vc];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    LifeCostPayHistoryOrderListModel *sectionModel = self.dataSourceArr[section];
     return sectionModel.orderEntityList.count+1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        return 50;
    }else{
        return 70;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LifeCostPayHistoryOrderListModel *sectionModel = self.dataSourceArr[indexPath.section];
    if (indexPath.row == 0) {
        LifeCostPayHistoryOrderListOnlyShowMonthInfTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCostPayHistoryOrderListOnlyShowMonthInfTableViewCell_Identifier];
        if (!cell) {
            cell = [[LifeCostPayHistoryOrderListOnlyShowMonthInfTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostPayHistoryOrderListOnlyShowMonthInfTableViewCell_Identifier];
        }
        cell.monthTitleL.text = [TextShowWithModelStr textShowWithModelStr: sectionModel.dateString];
        return cell;
    }else{
        LifeCostPayHistoryOrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCostPayHistoryOrderListTableViewCell_Identifier];
        if (!cell) {
            cell = [[LifeCostPayHistoryOrderListTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostPayHistoryOrderListTableViewCell_Identifier];
        }
        LifeCostPayHistoryOrderSubOrderEntityModel *entityModel = sectionModel.orderEntityList[indexPath.row-1];
        [cell fillDataWithModel:entityModel];
        return cell;
    }
}
#pragma mark ===
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
 
    
    if ([cell respondsToSelector:@selector(tintColor)]) {
        CGFloat cornerRadius = 7.0f;
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
        BOOL addLine = NO;
        if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
            CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);// 实体剧形状
        } else if (indexPath.row == 0) {//上部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
            addLine = YES;
            
        } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {//下部分有圆角
            CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
            CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
            CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
        layer.strokeColor=[ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW.CGColor;
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


#pragma mark == header view
- (LifeCostPaymentListVcHeaderView *)headerView{
    if (!_headerView) {
        _headerView  = [[LifeCostPaymentListVcHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, H_HeaderChooseView)];
        _headerView.delegate = self;
    }
    return _headerView;
}
- (PopviewWithChoosePayType *)popviewPayType{
    _popviewPayType = [[PopviewWithChoosePayType alloc]init];
    _popviewPayType.delegagtePayType = self;
    return _popviewPayType;
}
- (PopviewWithChoosePayTime *)popviewPayTime{
    _popviewPayTime = [[PopviewWithChoosePayTime alloc]init];
    _popviewPayTime.delegagtePayTime = self;
    return _popviewPayTime;
}


@end
