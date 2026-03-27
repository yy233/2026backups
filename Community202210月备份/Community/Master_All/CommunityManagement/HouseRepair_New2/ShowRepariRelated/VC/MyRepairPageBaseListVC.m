//
//  MyRepairPageBaseListVC.m
//  Community
//
//  Created by 余莹 on 2022/4/11.
//

#import "MyRepairPageBaseListVC.h"


#import "FBKVOController.h"
#import "MyRepairMainListViewModel.h"
#import "HouseRepairPageBaseListTableViewCell.h"
#import "MyRepariHeader.h"
//
#import "ZYReportAboutRepairApplyVc.h"// 报事报修申请服务 (本footer 隐去)
#import "MyRepairShowDetailInfoPageVC.h"//详情

#define Row_Num_TopStatusCell  (0)
#define Row_Num_WorkNumCell (1)
#define Row_Num_AddressCell (2)
#define Row_Num_TimeCell    (3)
#define Row_Num_ImgAndContentCell (4)

@interface MyRepairPageBaseListVC ()
//kvo
{
    FBKVOController *fbKVO;
}
@property (nonatomic,strong) MyRepairMainListViewModel *viewModel;
//@property (nonatomic,strong) BaseTableViewFooterView *footerView;
@end

@implementation MyRepairPageBaseListVC

- (MyRepairMainListViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[MyRepairMainListViewModel alloc]init];
    }
    return _viewModel;
}
/**
 - (BaseTableViewFooterView *)footerView{
     if (!_footerView) {
         _footerView = [[HouseRepairListVcFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W-32, 90)];
         [_footerView.footerBtn setTitle:@"一键报修" forState:UIControlStateNormal];
         [_footerView.footerBtn addTarget:self action:@selector(footerBtnAction) forControlEvents:UIControlEventTouchUpInside];
     }
     return _footerView;
 }
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeNavBackColorWithDDndWIsGW];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MyRepairPageBaseListOfMsgAndImgsTableViewCell class]  forCellReuseIdentifier:MyRepairPageBaseListOfMsgAndImgsTableViewCell_I];
   //self.tableView.tableFooterView = self.footerView;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 20+KIndicatorHeight)];
    [self addRefresh];
    [self addKvo];
    [self initData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self changeNavBackColorWithDDndWIsGW];
}
 
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    MJRefreshBackNormalFooter *footerRefresh = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upNextPageData)];
    self.tableView.mj_header = headeerRefresh;
    self.tableView.mj_footer = footerRefresh;
    self.tableView.mj_footer.hidden = YES;
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = KIndicatorHeight;
}
 
#pragma mark ===
- (void)initData{
    [self.viewModel getDataListOnePageWithType:self.nowListType];
}


- (void)upNextPageData{
    [self.viewModel getDataListNextPage];
}
#pragma mark ===
- (void)addKvo{
    fbKVO = [FBKVOController controllerWithObserver:self];
    
    
    //店铺列表
    WEAKSELF
    NSArray *listKvoKeyArr = @[kViewModel_dataOfArr,
                                    kViewModel_thisIsSuccessBool];//keyPaths keyPath
    [fbKVO observe:self.viewModel  keyPaths:listKvoKeyArr  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSString *fbKvoKeyPath = [NSString stringWithString:[change objectForKey:@"FBKVONotificationKeyPathKey"]];
        DLog(@"fbKvoKeyPath = %@ ; objectChangeInfoData==%@ observerVM==%@   changeO= =%@ ",fbKvoKeyPath,change,object,observer);
        if(self.nowListType ==  self.viewModel.saveNowListTypeWithDealData){
            //NSLog(@"vm变化_当前list类型和data类型 相同");
            [weakSelf getListKVoPathStr:fbKvoKeyPath];
        }else{
            NSLog(@"vm变化_当前list类型和data类型 不相同");
        }
      
    }];
}
- (void)getListKVoPathStr:(NSString *)fbKvoKeyPath{
    WEAKSELF
    if ([fbKvoKeyPath isEqualToString:kViewModel_dataOfArr]) {
        //数据更改
        self.dataSourceArr  = [NSMutableArray arrayWithArray:self.viewModel.dataOfArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            if (weakSelf.viewModel.dataOfArr.count >= Y_PAGE_SIZE_10 ) {
                weakSelf.tableView.mj_footer.hidden = NO;
            }else{
                weakSelf.tableView.mj_footer.hidden = YES;
            }
        });
    }else if ([fbKvoKeyPath isEqualToString:kViewModel_thisIsSuccessBool]){//得到当次请求状态
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
        });
        if (weakSelf.viewModel.thisIsSuccessBool) {
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_SUCCESS_MES(weakSelf.viewModel.showMsgStr);
            });
       
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                Y_SVP_SHOW_ERR_MES(weakSelf.viewModel.showMsgStr);
            });
          
        }
    }else{//kViewModel_showMsgStr
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == Row_Num_TopStatusCell) {
        return 50;
    }else if (indexPath.row ==  Row_Num_ImgAndContentCell){
        MyRepairPageListUseModel *model = [[MyRepairPageListUseModel alloc]init];
        model = self.dataSourceArr[indexPath.section];
        CGFloat cellH =  [tableView fd_heightForCellWithIdentifier:MyRepairPageBaseListOfMsgAndImgsTableViewCell_I cacheByIndexPath:indexPath configuration:^(MyRepairPageBaseListOfMsgAndImgsTableViewCell * cell) {
            [cell fillDataWithModel:model];
           }];
        return cellH;

    }else{
        if (indexPath.row == Row_Num_AddressCell) {//中间行高度短点
            return 18;
        }else{
            return 30;
        }
     
    }
}
 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyRepairPageListUseModel *model = [[MyRepairPageListUseModel alloc]init];
    model = self.dataSourceArr[indexPath.section];
  
    if (indexPath.row == Row_Num_TopStatusCell) {
        MyRepairPageBaseListOfStatusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyRepairPageBaseListOfStatusTableViewCell_I];
        if (!cell) {
            cell = [[MyRepairPageBaseListOfStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyRepairPageBaseListOfStatusTableViewCell_I];
        }
        [cell fillDataWithModel:model];

        return cell;
    }else if (indexPath.row ==  Row_Num_ImgAndContentCell){
 
        MyRepairPageBaseListOfMsgAndImgsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyRepairPageBaseListOfMsgAndImgsTableViewCell_I];
        if (!cell) {
            cell = [[MyRepairPageBaseListOfMsgAndImgsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyRepairPageBaseListOfMsgAndImgsTableViewCell_I];
        }
        [cell fillDataWithModel:model];
        return cell;
        
    }else{
        MyRepairPageBaseListOfTextShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyRepairPageBaseListOfTextShowTableViewCell_I];
        if (!cell) {
            cell = [[MyRepairPageBaseListOfTextShowTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyRepairPageBaseListOfTextShowTableViewCell_I];
        }
        switch (indexPath.row) {
            case Row_Num_WorkNumCell:
            {
                cell.titleL.text = @"工单编号：";
                cell.textL.text = [TextShowWithModelStr textShowWithModelStr:model.number];
            }
                break;
            case Row_Num_AddressCell:
            {
                cell.titleL.text = @"报事地点：";
                cell.textL.text = [TextShowWithModelStr textShowWithModelStr:model.address];

            }
                break;
            case Row_Num_TimeCell:
            {
                cell.titleL.text = @"报事时间：";
                cell.textL.text = [TextShowWithModelStr textShowWithModelStr:model.createTime];
            }
                break;
            default:
                break;
        }

        return cell;

    }
 

     
}
 
#pragma mark ==

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//工单信息+跟进信息
    
    MyRepairShowDetailInfoPageVC *detailVc = [[MyRepairShowDetailInfoPageVC alloc]init];
    MyRepairPageListUseModel *mdoel = self.dataSourceArr[indexPath.section];
    detailVc.detailmodel = mdoel; 
    WEAKSELF
    detailVc.detailPopToListWithRefreshBlock = ^{//取消上报成功 返回列表页 并 刷新列表
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self pushVc:detailVc];
}

#pragma mark ==
/**
 - (void)footerBtnAction{
     
     ZYReportAboutRepairApplyVc *vc = [[ZYReportAboutRepairApplyVc alloc] init];
     vc.hidesBottomBarWhenPushed = YES;
     [self pushVc:vc];

 }
 
 */


#pragma mark === 组圆角
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cornerRadius = 7.5f;
    UIColor *sectionFillColor =  [ThemeManager shareManager].themeContentBackGroundColor_DrakNoChangeAndWW;
//    UIColor *separatoColor = Color_Line_LigntGray;
    UIColor *separatoColor = [ThemeManager shareManager].themeLineColor;
    if ([cell respondsToSelector:@selector(tintColor)]) {
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
            separatoColor = [UIColor clearColor];
        } else {//填充？
            CGPathAddRect(pathRef, nil, bounds);
            addLine = YES;
        }
        layer.path = pathRef;
        CFRelease(pathRef);
        //颜色修改
        layer.fillColor = sectionFillColor.CGColor;
        layer.strokeColor= sectionFillColor.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-0.5, bounds.size.width-10*2, 0.5);//h_0.5
            //lineLayer.backgroundColor = separatoColor.CGColor;
            if (indexPath.section == 0) {
                if (indexPath.row == 1) {
                    //[layer addSublayer:lineLayer];//1s 1r底下才显示 其余不显示
                }
            }else{
            }
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}

@end
