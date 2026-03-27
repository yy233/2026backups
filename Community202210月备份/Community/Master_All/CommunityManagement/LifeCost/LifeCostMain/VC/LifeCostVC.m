//
//  LifeCostVC.m
//  Community
//
//  Created by 余莹 on 2021/1/8.
//

#import "LifeCostVC.h"
#import "LifeCostPaymentDetailsListVC.h"
#import "LifeCosePaymentOnePayInfoVC.h"
#import "LifeCoseNewAddCoseVC.h"
#import "LifeCostAccountManageVc.h"
//
#import "LifeCostPropertyFeeListVc.h"
#import "LifeCostPropertyFeeInfoVc.h"

//
#import "LifeCostMainVcViewModel.h"
//
 
//
#import "LifeCostNewCostModelGetH.h"
#import "LifeCostMyCostTableViewCell.h"
#import "LifeCostNewCostTableViewCell.h"
#import "LifeCostAdScrollviewTableViewCell.h"
#import "LifeCostGoodThingChooseTableViewCell.h"
//
#define LifeCostMyCostTableViewCell_Identifier             @"LifeCostMyCostTableViewCell"
#define LifeCostNewCostTableViewCell_Identfier             @"LifeCostNewCostTableViewCell"
#define LifeCostAdScrollviewTableViewCell_Identfier        @"LifeCostAdScrollviewTableViewCell"
#define LifeCostGoodThingChooseTableViewCell_Identfier     @"LifeCostGoodThingChooseTableViewCell"
//
#import "LifeCostMyCostSectionHeaderView.h"
#import "LifeCostNewCostSectionHeaderView.h"
#import "LifeCostVcFooterView.h"

//
#define H_SectionHeaderView  50
#define H_MyCostCell  55
#define H_AdScreollCell 80
#define H_GoodThingChoose 260

#import "LifeCostData.h"

@interface LifeCostVC ()<LifeCostNewCostTableViewCellDelegate,LifeCostVcFooterViewDelegate>
@property (nonatomic,strong) LifeCostMyCostSectionHeaderView *myCostSectionHeaderview;
@property (nonatomic,strong) LifeCostNewCostSectionHeaderView *newCostSectionHeaderview;
@property (nonatomic,strong) LifeCostVcFooterView *footerView;
@property (nonatomic,strong) NSMutableArray *myCostArr;
@property (nonatomic,strong) NSMutableArray *addNewCostArr;
@property (nonatomic,strong) EBDropdownListView *cityChooseDropdownListView;//暂时无效果
@end

@implementation LifeCostVC

- (void)viewDidLoad {
    self.myCostArr = [[NSMutableArray alloc]init];
    self.addNewCostArr = [[NSMutableArray alloc]init];
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.title = @"生活缴费";//旧版
    self.tableView.tableHeaderView = [self headerview];
    self.tableView.tableFooterView = self.footerView;
}
- (void)initData{
    WEAKSELF
    [LifeCostMainVcViewModel getLifeCostMyCostArrWith:^(NSArray * arr, BOOL success) {
        if (success) {
            self.myCostArr = [NSMutableArray arrayWithArray:[LifeCostMyCostModel mj_objectArrayWithKeyValuesArray:arr]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];

    //
//    NSInteger cityId = 500000;//暂时定
//    [LifeCostMainVcViewModel getLifeCostAddNewCostArrWithCotyid:cityId with:^(NSArray * arr, BOOL success) {
//        if (success) {
//            self.addNewCostArr = [NSMutableArray arrayWithArray:[LifeCostAddNewCostModel mj_objectArrayWithKeyValuesArray:arr]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        }
//    }];
//    [LifeCostData lifeCostGetOneCity:@"" withPayTypeListWithArrBlock:^(NSArray * arr , BOOL success) {
//        if (success) {
//          weakSelf.myCostArr = [NSMutableArray arrayWithArray:[LifeCostMyCostModel mj_objectArrayWithKeyValuesArray:arr]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [weakSelf.tableView reloadData];
//            });
//        }
//    }];
}



#pragma mark ==
- (void)footerViewChooseBtnWith:(LifeCostVcFooter_Btn_Type)btnType{
    switch (btnType) {
        case LifeCostVcFooter_Btn_Type_CostList://缴费列表记录
        {
            LifeCostPaymentDetailsListVC *payDetailListVc = [[LifeCostPaymentDetailsListVC alloc]init];
            //familyId
            [self pushVc:payDetailListVc];
        }
            break;
        case LifeCostVcFooter_Btn_Type_CostCardIdManager:
        {
            NSLog(@"户号管理");
            LifeCostAccountManageVc *vc = [[LifeCostAccountManageVc alloc]init];  
            [self pushVc:vc];
        }
             
            break;
        case LifeCostVcFooter_Btn_Type_Help:
        {
         
        }
             
            break;
            
        default:
            break;
    }
}
#pragma mark ===
- (void)myCostSectionHeaderviewSubBtnAction{
    NSLog(@"户号管理_footer");
    LifeCostAccountManageVc *vc = [[LifeCostAccountManageVc alloc]init];
    [self pushVc:vc];
    
}

- (void)cityChangeBtnAction{
    NSLog(@"城市切换");
    [self topCityBtnAction];
}

 
- (void)topCityBtnAction{
    NSLog(@"topCityBtnAction");
    EBDropdownListItem *item1 = [[EBDropdownListItem alloc] initWithItem:@"1" itemName:@"item1"];
    EBDropdownListItem *item2 = [[EBDropdownListItem alloc] initWithItem:@"2" itemName:@"item2"];
    EBDropdownListItem *item3 = [[EBDropdownListItem alloc] initWithItem:@"3" itemName:@"item3"];
    EBDropdownListItem *item4 = [[EBDropdownListItem alloc] initWithItem:@"4" itemName:@"item4"];
//    _newCostSectionHeaderview.cityChooseDropdownListView.dataSource = @[item1, item2, item3, item4];
//    [_newCostSectionHeaderview.cityChooseDropdownListView setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView) {
//        NSString *msgString = [NSString stringWithFormat:
//                               @"selected name:%@  id:%@  index:%ld"
//                               , dropdownListView.selectedItem.itemName
//                               , dropdownListView.selectedItem.itemId
//                               , dropdownListView.selectedIndex];
//
//        [self.newCostSectionHeaderview.cityChangeBtn setTitle:msgString forState:UIControlStateNormal];
//    }];
    
    self.cityChooseDropdownListView.dataSource = @[item1, item2, item3, item4];
    [self.cityChooseDropdownListView setDropdownListViewSelectedBlock:^(EBDropdownListView *dropdownListView) {
        NSString *msgString = [NSString stringWithFormat:
                               @"selected name:%@  id:%@  index:%ld"
                               , dropdownListView.selectedItem.itemName
                               , dropdownListView.selectedItem.itemId
                               , dropdownListView.selectedIndex];

        [self.newCostSectionHeaderview.cityChangeBtn setTitle:msgString forState:UIControlStateNormal];
    }];
    
}
#pragma mark == 新增缴费
- (void)touchNewCostCellItemWithNum:(NSInteger)index{
    NSLog(@"---touchNewCostCellItemWithNum------%@",self.addNewCostArr[index]);

    //0706物业的单独跳转
    LifeCostAddNewCostModel *newCostModel = self.addNewCostArr[index];
    if (newCostModel.id == 4) {
        LifeCostPropertyFeeListVc *vc =[[LifeCostPropertyFeeListVc alloc]init];
        [self pushVc:vc];
     
    }else{
        LifeCoseNewAddCoseVC *addNewCostVc = [[LifeCoseNewAddCoseVC alloc]init];
        addNewCostVc.addNewCostModel = newCostModel;
        addNewCostVc.cityId = 500000;
        [self pushVc:addNewCostVc];
    }

    
}


#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {//我的缴费
        LifeCostMyCostModel *model = self.myCostArr[indexPath.row];
        LifeCosePaymentOnePayInfoVC *payDetailInfoVc = [[LifeCosePaymentOnePayInfoVC alloc]init];
//        payDetailInfoVc.doorNo = [TextShowWithModelStr textShowWithModelStr:model.doorNo]; 
//        payDetailInfoVc.id = model.typeID;
        payDetailInfoVc.listOldModel = model;
        [self pushVc:payDetailInfoVc];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 4;
    return 2;// 好物精选 广告 部分隐藏当前无数据
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.myCostArr.count;
    }else if (section==1 || section==2 || section==3) {
        return 1;
    }else{
        return 0;
    }
        
        
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return self.myCostSectionHeaderview;
    }else if(section==1){
        return self.newCostSectionHeaderview;
    }else{
        return [UIView new];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0 || section == 1) {
        return H_SectionHeaderView;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return H_MyCostCell;
    }else if(indexPath.section==1){
        return [LifeCostNewCostModelGetH getNewCostCellAllHeightWithNewCostArrCount:self.addNewCostArr.count];
    }else if(indexPath.section==2){
        return H_AdScreollCell;
    }else if(indexPath.section==3){
        return H_GoodThingChoose;
    }else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        LifeCostMyCostTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:LifeCostMyCostTableViewCell_Identifier];
        if (!cell) {
            cell = [[LifeCostMyCostTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostMyCostTableViewCell_Identifier]; 
        }
        //cell.model = self.myCostArr[indexPath.row];
        return cell;
    }else if(indexPath.section==1){
        LifeCostNewCostTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:LifeCostNewCostTableViewCell_Identfier];
        if (!cell) {
            cell = [[LifeCostNewCostTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostNewCostTableViewCell_Identfier];
        }
        cell.delegate = self;
        cell.dataSourceArr = self.addNewCostArr;
        return cell;
    }else if(indexPath.section==2){
        LifeCostAdScrollviewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCostAdScrollviewTableViewCell_Identfier];
        if (!cell) {
            cell = [[LifeCostAdScrollviewTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostAdScrollviewTableViewCell_Identfier];
        }
        return cell;
    }else if(indexPath.section==3){
        LifeCostGoodThingChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LifeCostGoodThingChooseTableViewCell_Identfier];
        if (!cell) {
            cell = [[LifeCostGoodThingChooseTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostGoodThingChooseTableViewCell_Identfier];
        }
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark ===
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myCostArr.count==0 && indexPath.section==0) {
        return;
    }
    if (self.addNewCostArr.count==0 && indexPath.section==1) {
        return;
    }
    
    if ([cell respondsToSelector:@selector(tintColor)]) {
//        if (tableView == self.tableView) {
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
        layer.fillColor = [ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
        layer.strokeColor=[ThemeManager shareManager].guestInfoRegisterContentCellBackgroundColor.CGColor;
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
//            CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
//            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
            lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height, bounds.size.width-10, 0);

            lineLayer.backgroundColor = tableView.separatorColor.CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
//    }
}
#pragma mark ==
- (LifeCostMyCostSectionHeaderView *)myCostSectionHeaderview{
    if (!_myCostSectionHeaderview) {
        _myCostSectionHeaderview = [[LifeCostMyCostSectionHeaderView alloc]init];
        [_myCostSectionHeaderview.householdManagementBtn addTarget:self action:@selector(myCostSectionHeaderviewSubBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myCostSectionHeaderview;
}
- (LifeCostNewCostSectionHeaderView *)newCostSectionHeaderview{
    if (!_newCostSectionHeaderview) {
        _newCostSectionHeaderview = [[LifeCostNewCostSectionHeaderView alloc]init];
        [_newCostSectionHeaderview.cityChangeBtn addTarget:self action:@selector(cityChangeBtnAction) forControlEvents:UIControlEventTouchUpInside];
        //
//        [self.view addSubview:self.cityChooseDropdownListView];
//        self.cityChooseDropdownListView.frame = _newCostSectionHeaderview.cityChangeBtn.frame;
    }
    return _newCostSectionHeaderview;
}
- (UIView *)headerview{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
    UILabel *myCostL = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, Screen_W-40, 40)];
    myCostL.textColor = [ThemeManager shareManager].mainTextColor;
    myCostL.font = [UIFont systemFontOfSize:15.0];
    myCostL.text = @"我的缴费";
    [v addSubview:myCostL];
    return v;
}
- (LifeCostVcFooterView *)footerView{
    if (!_footerView) {
        _footerView = [[LifeCostVcFooterView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 50)];
        _footerView.delegate = self;
    }
    return _footerView;
}

#pragma mark == 
- (EBDropdownListView *)cityChooseDropdownListView{
    // 弹出框向下
    if (!_cityChooseDropdownListView) {
        _cityChooseDropdownListView = [[EBDropdownListView alloc]initWithFrame:CGRectMake(0, 0, 80, 20)];
        _cityChooseDropdownListView.selectedIndex = 1;
        [_cityChooseDropdownListView setViewBorder:0.5 borderColor:[UIColor grayColor] cornerRadius:2];
        [_cityChooseDropdownListView setTextColor:[ThemeManager shareManager].mainTextColor];
        [_cityChooseDropdownListView setFont:[UIFont systemFontOfSize:14]];
    }
    return _cityChooseDropdownListView;
}
@end
