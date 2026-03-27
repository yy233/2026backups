//
//  BillingListVC.m
//  Community
//
//  Created by 余莹 on 2022/6/8.
//

#import "BillingListVC.h"
#import "BillingDetailVC.h"

#import "PopviewWithChoosePayTime.h"
#import "BillListVcTypePopView.h"
#import "BillListVcTopView.h"
#import "BillingListVcTableViewCell.h"
#import "BillListVcSectionHeaderView.h"
#import "BillingListDataVm.h"
#import "FBKVOController.h"
#import "BillingListModel.h"


@interface BillingListVC () <BasePopTableViewChooseDelegate,PopviewWithChoosePayTimeDelegate>
//kvo
{
    FBKVOController *fbKVO;
}
@property (nonatomic,strong) BillListVcTopView *topView;
@property (nonatomic,strong) BillListVcTypePopView *popViewOfTypeChoose;
@property (nonatomic,strong) PopviewWithChoosePayTime *popviewPayTime;

@property (nonatomic,assign) NSInteger saveNotTypeNum;
@property (nonatomic,strong) NSMutableArray *dataSourceArrOfTypeChoose;
@property (nonatomic,strong) NSString *saveHeaderChooseTimeStr;

@property (nonatomic,strong) BillingListDataVm *viewModel;


@end

@implementation BillingListVC
//
- (BillListVcTopView *)topView{
    if (!_topView) {
        _topView = [[BillListVcTopView alloc]initWithFrame:CGRectZero];
        [_topView.typeBtn addTarget:self action:@selector(typeChooseAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView.timeBtn addTarget:self action:@selector(timeChooseAction) forControlEvents:UIControlEventTouchUpInside];

    }
    return _topView;
}
- (BillListVcTypePopView *)popViewOfTypeChoose{
    _popViewOfTypeChoose = [[BillListVcTypePopView alloc]init];
    _popViewOfTypeChoose.delegate = self;
    return _popViewOfTypeChoose;
}
- (PopviewWithChoosePayTime *)popviewPayTime{
    _popviewPayTime = [[PopviewWithChoosePayTime alloc]init];
    _popviewPayTime.delegagtePayTime = self;
    return _popviewPayTime;
}

- (NSMutableArray *)dataSourceArrOfTypeChoose{
    if (!_dataSourceArrOfTypeChoose) {
        _dataSourceArrOfTypeChoose = [NSMutableArray arrayWithObjects:@"全部账单",@"付款账单",@"收款账单",@"退款账单", nil];
    }
    return _dataSourceArrOfTypeChoose;
}
//


- (BillingListDataVm *)viewModel{
    if (!_viewModel) {
        _viewModel = [[BillingListDataVm alloc]init];
    }
    return _viewModel;
}
#pragma mark ==
- (void)addKvo{
    
    fbKVO = [FBKVOController controllerWithObserver:self];
    //列表
    WEAKSELF
    NSArray *listKvoKeyArr = @[kViewModel_dataOfArr,
                                    kViewModel_thisIsSuccessBool];//keyPaths keyPath
    [fbKVO observe:self.viewModel  keyPaths:listKvoKeyArr  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *fbKvoKeyPath = [NSString stringWithString:[change objectForKey:@"FBKVONotificationKeyPathKey"]];
        DLog(@"fbKvoKeyPath = %@ ; objectChangeInfoData==%@ observerVM==%@   changeO= =%@ ",fbKvoKeyPath,change,object,observer);
        [weakSelf getKVoPathStr:fbKvoKeyPath];
    }];
  
}
- (void)getKVoPathStr:(NSString *)fbKvoKeyPath{
    WEAKSELF
    if ([fbKvoKeyPath isEqualToString:kViewModel_thisIsSuccessBool]){//msg
        //success or fail
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
         });
        
        if (weakSelf.viewModel.thisIsSuccessBool) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(weakSelf.viewModel.showMsgStr);//成功有提示
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_MES(weakSelf.viewModel.showMsgStr);//请求失败有提示
            });
        }
    }else  if ([fbKvoKeyPath isEqualToString:kViewModel_dataOfArr]) {//data
        //SUCCESS
        self.dataSourceArr = [BillingListModel mj_objectArrayWithKeyValuesArray:weakSelf.viewModel.dataOfArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
           
         });
    }else{
    }
}


//
#pragma mark ==
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账单明细";
    self.saveNotTypeNum = 0;
    [self initView];
    [self addKvo];
 
}
- (void)initView{
    [self changeNavBackColorWithDDndWIsGW];
    self.tableView.backgroundColor = [ThemeManager shareManager].themeBackGroundColor;//重蓝非白
    self.tableView.tableHeaderView = self.topView;
    //
    NSString *typeStr = self.dataSourceArrOfTypeChoose[self.saveNotTypeNum ];
    [self.topView.typeBtn newAnBtnWithTextStr:typeStr];
    [self popViewChooseALlPayTime];
    
    [self initListData];
}
- (void)initListData{
    //更新UI
    [self.topView.typeBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:10];
    [self.topView.timeBtn layoutButtonWithEdgeInsetsStyle:GLButtonEdgeInsetsStyleRight imageTitleSpace:10];
    //数据请求前的筛选信息填充
    [self.viewModel fillQueryTimeStr:self.saveHeaderChooseTimeStr andType:self.saveNotTypeNum];
    //请求第一页
    [self.viewModel getDataListOnePage];
 
}
- (void)upDataListData{
    //加载更多
    [self.viewModel getDataListNextPage];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;//月份
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    BillingListModel *listOfOneMonethModel = self.dataSourceArr[section];
    NSArray *arr = listOfOneMonethModel.balanceChanges;
    return arr.count;//当月行数
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BillingListModel *listOfOneMonethModel = self.dataSourceArr[section];

    BillListVcSectionHeaderView *sHeaderView = [[BillListVcSectionHeaderView alloc]initWithFrame:CGRectZero];
    sHeaderView.moneyL.text = [NSString stringWithFormat:@"支出¥%0.2f 收入¥%0.2f",listOfOneMonethModel.payTotalAmount,listOfOneMonethModel.payeeTotalAmount];
    sHeaderView.timeL.text = [TextShowWithModelStr textShowWithModelStr:listOfOneMonethModel.timeStr];
    return sHeaderView;
}
 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillingListVcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BillingListVcTableViewCell_I];
    if (!cell) {
        cell = [[BillingListVcTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:BillingListVcTableViewCell_I];
    }
    BillingListModel *listOfOneMonethModel = self.dataSourceArr[indexPath.section];
    NSArray *arr = listOfOneMonethModel.balanceChanges;

    [cell fillModel:arr[indexPath.row]];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BillingListModel *listOfOneMonethModel = self.dataSourceArr[indexPath.section];
    NSArray *arr = listOfOneMonethModel.balanceChanges;

    BillingListSubOneInfoDetailModel *submodel =  arr[indexPath.row];
    BillingDetailVC *vc = [[BillingDetailVC alloc]init];
    vc.idStr = submodel.ID;
    [self pushVc:vc];
}
 
#pragma mark == popView
- (void)typeChooseAction{
    [self.popViewOfTypeChoose showInView:self.view thePopViewTableViewHeight:0 WithArray:self.dataSourceArrOfTypeChoose];
    
}
- (void)timeChooseAction{
    [self.popviewPayTime showInView:self.view thePopViewSubViewHeight:0.0 WithArray:@[].mutableCopy];

}

#pragma mark == type Choose
- (void)basePopViewTag:(NSInteger)tag OfSubTableViewTouchWithIndexPath:(NSIndexPath *)indexPath{
    self.saveNotTypeNum = indexPath.row;
    NSString *typeStr = self.dataSourceArrOfTypeChoose[self.saveNotTypeNum ];
    [self.topView.typeBtn newAnBtnWithTextStr:typeStr];
    [self initListData];
 
}

#pragma mark == time Choose
- (void)popViewChooseALlPayTime{
    self.saveHeaderChooseTimeStr = @"";//空长度
    [self.topView.timeBtn newAnBtnWithTextStr:@"全部时间"];
    [self initListData];
}
//时间筛选
- (void)popViewChoosePayTimeWitYearAndMonthStr:(NSString *)yearAndMonthStr{
   // yearAndMonthStr = 2022-01 这种格式只是用来展示）
    self.saveHeaderChooseTimeStr = yearAndMonthStr;
    [self.topView.timeBtn newAnBtnWithTextStr: yearAndMonthStr];
    [self initListData];
}



#pragma mark ==
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cornerRadius = 10.0f;
    UIColor *sectionFillColor = [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;

    UIColor *separatoColor = Y_ColorWith16FromRGB(0xF0F1F6);
     if ([cell respondsToSelector:@selector(tintColor)]) {
        cell.backgroundColor = UIColor.clearColor;
        CAShapeLayer *layer = [[CAShapeLayer alloc] init];
        CGMutablePathRef pathRef = CGPathCreateMutable();
//        CGRect bounds = CGRectInset(cell.bounds, 16.0, 0);
         CGRect bounds = CGRectInset(cell.bounds, 0.0, 0);
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
        layer.fillColor = sectionFillColor.CGColor;
        layer.strokeColor= sectionFillColor.CGColor;
         
         addLine = NO;//不需要系统分割线
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10+35, bounds.size.height-1.0, bounds.size.width-20-35, 1.0);
            [layer addSublayer:lineLayer];
            lineLayer.backgroundColor = separatoColor.CGColor;
           
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}


@end
