//
//  LifeCostMainVC.m
//  Community
//
//  Created by 余莹 on 2022/1/4.
//

#import "LifeCostMainVC.h"
#import "LifeCostData.h"
#import "ZYLifeCostData.h"
 
#import "LifeCostMyCostTableViewCell.h"
#import "LifeCostNewCostTableViewCell.h"
#import "LifeCostMyCostSectionHeaderTableViewCell.h"
#import "LifeCostPayTypeHeaderTableViewCell.h"
#import "LifeCostVcFooterView.h"

//缴费记录
#import "LifeCostPayHistoryOrderListVC.h"
// 帮助中心
#import "ZYLifeCostHelpCenterVC.h"
// 切换城市
#import "YMCitySelect.h"
// 户号管理
#import "ZYLifeCostHouseholdVC.h"
// 分组设置
#import "ZYLifeCostAddGroupVC.h"

//我的缴费
#import "LifeCostMainVcTopGroupSectionModel.h"
#import "LifeCostMainVcTopGroupSubAccountEntityModel.h"
//去缴费
#import "LifeCostPayWillToPayListVC.h" //列表
#import "LifeCostContWillPayWithShowInfoVC.h"  //空
#import "LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc.h" //无money预缴详情直接缴费

//新增缴费
//缴费公司列表
#import "PaymentCompanyListVC.h"
//物业缴费
#import "LifeCostPropertyFeeListVc.h"

//
#define LifeCostMyCostTableViewCell_Identifier                             @"LifeCostMyCostTableViewCell"
#define LifeCostNewCostTableViewCell_Identfier                             @"LifeCostNewCostTableViewCell"
#define LifeCostMyCostSectionHeaderTableViewCell_Identifier                @"LifeCostMyCostSectionHeaderTableViewCell"
#define LifeCostPayTypeHeaderTableViewCell_Identifier                      @"LifeCostPayTypeHeaderTableViewCell"
//
#define H_SectionHeaderCell       (50)
#define H_MyCostCell              (60)
#define H_PayTypeNewItemOneCellH  (60)

@interface LifeCostMainVC () <LifeCostVcFooterViewDelegate,LifeCostNewCostTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource, YMCitySelectDelegate>
@property (nonatomic,strong) LifeCostVcFooterView *footerView;
@property (nonatomic,strong) NSMutableArray *myCostSectionsArr;//组
@property (nonatomic,strong) NSMutableArray *myNewPayTypeArr;//可新增类型
@property (nonatomic,strong) NSMutableArray *saveShouFangNumArr;//折叠用的记录
@property (nonatomic, strong) LifeCostMainVcTopGroupSectionModel *currentGroupModel;
@end

@implementation LifeCostMainVC
- (NSMutableArray *)saveShouFangNumArr{
    if (!_saveShouFangNumArr) {
        _saveShouFangNumArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _saveShouFangNumArr;
}
- (NSMutableArray *)myCostSectionsArr{
    if (!_myCostSectionsArr) {
        _myCostSectionsArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _myCostSectionsArr;
}

- (NSMutableArray *)myNewPayTypeArr{
    if (!_myNewPayTypeArr) {
        _myNewPayTypeArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _myNewPayTypeArr;
}
- (UIView *)headerview{
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
    UILabel *myCostL = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, Screen_W-40, 40)];
    myCostL.textColor = [ThemeManager shareManager].mainTextColor;
    myCostL.font = [UIFont boldSystemFontOfSize:16.0];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生活缴费";
    self.tableView.tableHeaderView = [self headerview];
    self.tableView.tableFooterView = self.footerView;
    self.tableView.separatorColor = [UIColor clearColor];
    [self addRefresh];
    // 注册通知
    Y_NSNotificationCenter_Creat_NameAction(@"LIFE_COST_CHANGE_GROUP_BACK", lifeCostChangeGroupBack:)
}
// 通知回调
- (void)lifeCostChangeGroupBack:(NSNotification *)noti {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initData];
    });
}
// 销毁通知
- (void)dealloc {
    Y_NSNotificationCenter_RemoveNotice_Name(@"LIFE_COST_CHANGE_GROUP_BACK")
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;//城市选择pop会有这个问题
    [self changeNavBackColorWithDDndWIsGW];
}
- (void)addRefresh{
    MJRefreshNormalHeader *headeerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(initData)];
    self.tableView.mj_header = headeerRefresh;
}
- (void)initData{
    WEAKSELF
    //我的缴费
    [LifeCostData lifeCostGetMainWithMinHuHaoSectionListWithArrBlcok:^(NSArray * _Nonnull arr, BOOL success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView.mj_header endRefreshing];
        });
        if (success) {
            weakSelf.myCostSectionsArr = [NSMutableArray arrayWithArray: [LifeCostMainVcTopGroupSectionModel mj_objectArrayWithKeyValuesArray:arr]];
            weakSelf.saveShouFangNumArr = [NSMutableArray arrayWithCapacity:0];
            if (weakSelf.myCostSectionsArr.count<=0) {
                [weakSelf.saveShouFangNumArr addObject:@(1)];
            }else{
                for (int i = 0 ; i < weakSelf.myCostSectionsArr.count; i++) {
                    if (i == 0) {
                        [weakSelf.saveShouFangNumArr addObject:@(0)];//打开状态
                    }else{
                        [weakSelf.saveShouFangNumArr addObject:@(1)];//折叠状态
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
    }];
 
    [self cityChangeWithUpDataLastSectionInfo];
 
}
- (void)cityChangeWithUpDataLastSectionInfo{
    WEAKSELF
    //新增缴费
    //刷新 初始状态用获取的流程|或者 用存储的城市str处理
    if ([LifeCostSaveCityInfoModel share].cityName.length<=0) {
        [LifeCostData lifeCostGetMainWithPayTypeListWithArrBlock:^(NSArray * _Nonnull arr, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_header endRefreshing];
            });
            if (success) {
                weakSelf.myNewPayTypeArr  = [NSMutableArray arrayWithArray:[LifeCostPayTypeModel mj_objectArrayWithKeyValuesArray:arr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }];
    }else{
        [LifeCostData lifeCostGetOneCity:[LifeCostSaveCityInfoModel share].cityName withPayTypeListWithArrBlock:^(NSArray * _Nonnull arr, BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView.mj_header endRefreshing];
            });
            if (success) {
                weakSelf.myNewPayTypeArr  = [NSMutableArray arrayWithArray:[LifeCostPayTypeModel mj_objectArrayWithKeyValuesArray:arr]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        }];
        
    }
}
// 加载删除分组数据
- (void)initDeleteGroupData {
    NSDictionary *params = @{@"id" : @(self.currentGroupModel.ID)};
    [ZYLifeCostData lifeCostDeleteGroupWithParams:params dictBlock:^(id  _Nonnull responsObject, BOOL success) {
        Y_SVP_DISMISS
        if (success) {
            NSDictionary *groupInfo = @{@"groupId" :[NSString stringWithFormat:@"%ld", self.currentGroupModel.ID], @"groupName" : self.currentGroupModel.groupName};
            Y_NSNotificationCenter_PostNotice_HaveUserInfo_Name(@"LIFE_COST_CHANGE_GROUP_BACK", groupInfo)
        }
    }];
}
#pragma mark === block
- (void)goToChangeCityVc{
    NSLog(@"跳转城市选择界面");
    
    YMCitySelect *citySelect = [[YMCitySelect alloc] initWithDelegate:self];
    citySelect.type = City_Select_Type_LifeCost;
    [self pushVc:citySelect];
}
- (void)editSectionInfoWithSectionNum:(NSInteger)sectionNum{
    if (self.myCostSectionsArr.count==0) {
        Y_SVP_SHOW_INFO_MES(@"默认组禁止编辑。");
        return;
    }
    NSLog(@"编辑 sectionNum %ld",sectionNum);//myCostSectionsArr[sectionNum]
    
    LifeCostMainVcTopGroupSectionModel *model = self.myCostSectionsArr[sectionNum];
    self.currentGroupModel = model;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *editAlert = [UIAlertAction actionWithTitle:@"修改名称" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"修改名称");
        ZYLifeCostAddGroupVC *vc = [[ZYLifeCostAddGroupVC alloc] init];
        vc.type = ZYLife_Cost_Type_UpdateGroup;
        vc.groupId = [NSString stringWithFormat:@"%ld", model.ID];
        vc.groupName = model.groupName;
        [self pushVc:vc];
    }];
    UIAlertAction *deleteAlert = [UIAlertAction actionWithTitle:@"删除分组" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showAlertDeleteGroup];
    }];
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:editAlert];
    [alertVC addAction:deleteAlert];
    [alertVC addAction:cancelAlert];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}
// 删除分组提示视图
- (void)showAlertDeleteGroup {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"是否确认删除该户号?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAlert = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *deleteAlert = [UIAlertAction actionWithTitle:@"确认删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除");
        [SVProgressHUD showLoadingCustomHUDWithStatus:@"删除中..."];
        [self initDeleteGroupData];
    }];
    [alertVC addAction:cancelAlert];
    [alertVC addAction:deleteAlert];
    alertVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:alertVC animated:YES completion:nil];
}
- (void)souFangSectionNum:(NSInteger)sectionNum{
    if (self.myCostSectionsArr.count==0) {
        return;
    }
    NSLog(@"收放 sectionNum %ld",sectionNum);
    NSInteger willReNum = ( [self.saveShouFangNumArr[sectionNum] isEqual: @(0)] ? 1 : 0);
    [self.saveShouFangNumArr replaceObjectAtIndex:sectionNum withObject:@(willReNum)];
    [self.tableView reloadSections:[[NSIndexSet alloc]initWithIndex:sectionNum] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark == 新增缴费
- (void)touchNewCostCellItemWithNum:(NSInteger)index{
 
    LifeCostPayTypeModel *model = self.myNewPayTypeArr[index];//项目接口
    NSLog(@"新增缴费 section。 项目 类型  = %@",model.typeName);
    
    if (model.isPropertyFee) {
        LifeCostPropertyFeeListVc *vc =[[LifeCostPropertyFeeListVc alloc]init];//物业缴费主列表
        [self pushVc:vc];
    }else{
        //公司
        PaymentCompanyListVC *vc = [[PaymentCompanyListVC alloc]init];
        vc.saveNowCityTextStr = model.cityName;
        vc.payTypeIdStr = [NSString stringWithFormat:@"%ld",model.type];
        vc.typeModel = model;
        [self pushVc:vc];
    }
   
}
#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DLog(@"");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section<self.myCostSectionsArr.count || (self.myCostSectionsArr.count==0 && indexPath.section==0)) {//我的缴费1
        if (indexPath.row==0) {
            [self souFangSectionNum:indexPath.section];//折叠
            return;//组名cell
        }else{
            //去缴费
            [self goMyCostSectionOneWithCelIndexPath:indexPath];
        }
    }
}

//去缴费
- (void)goMyCostSectionOneWithCelIndexPath:(NSIndexPath *)indexPath{
    
    LifeCostMainVcTopGroupSectionModel *groupSectionModel = self.myCostSectionsArr[indexPath.section];
    LifeCostMainVcTopGroupSubAccountEntityModel *entityModel = groupSectionModel.accountEntityList[indexPath.row-1];
    NSInteger bfNum = [entityModel.businessFlow integerValue];
    switch (bfNum) {
        case 0:
        {
            [LifeCostData lifeCostGetWillPayOrderListWithMyAccoundBillKeyStr:[TextShowWithModelStr textShowWithModelStr:entityModel.account] withListBlock:^(NSArray * _Nonnull arr, BOOL success) {
                if (success) {
                    if (arr.count==0) {//空数据 未出账单_未欠费vc
                        LifeCostContWillPayWithShowInfoVC *vc = [[LifeCostContWillPayWithShowInfoVC alloc]init];
                        vc.accountStr = [TextShowWithModelStr textShowWithNotNullStr:entityModel.account];
                        vc.commpanyStr = [TextShowWithModelStr textShowWithNotNullStr:entityModel.company];
                        [self pushVc:vc];
                    }else{//有账单 去列表
                        LifeCostPayWillToPayListVC *vc = [[LifeCostPayWillToPayListVC alloc]init];
                        vc.oneAccountModel = entityModel;
                        [self pushVc:vc];
                    }
                }
            }];
        }
            break;
        case 1:
        {
            // (预交)
            LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc *vc = [[LifeCostPayOrderDetailWithNotHaveMoneyNumCanSaveMoneyToPayDetailVc alloc]init];
            vc.mianVcGroupListSubOrderModel = entityModel;
            [self pushVc:vc];
        }
            break;
        case 2://0和2都用一个方法
        {
            [LifeCostData lifeCostGetWillPayOrderListWithMyAccoundBillKeyStr:[TextShowWithModelStr textShowWithModelStr:entityModel.account] withListBlock:^(NSArray * _Nonnull arr, BOOL success) {
                if (success) {
                    if (arr.count==0) {//空数据 未出账单_未欠费vc
                        LifeCostContWillPayWithShowInfoVC *vc = [[LifeCostContWillPayWithShowInfoVC alloc]init];
                        vc.accountStr = [TextShowWithModelStr textShowWithNotNullStr:entityModel.account];
                        vc.commpanyStr = [TextShowWithModelStr textShowWithNotNullStr:entityModel.company];
                        [self pushVc:vc];
                    }else{//有账单 去列表
                        LifeCostPayWillToPayListVC *vc = [[LifeCostPayWillToPayListVC alloc]init];
                        vc.oneAccountModel = entityModel;
                        [self pushVc:vc];
                    }
                }
            }];
        }
            break;
            
        default:
            Y_SVP_SHOW_ERR_MES(@"暂不支持的缴费类型。");
            DLog(@"bf == %ld",bfNum);
            break;
    }
    
}
 
#pragma mark ==

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.myCostSectionsArr.count==0) {
        return 2;
    }else{
        return self.myCostSectionsArr.count+1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section<self.myCostSectionsArr.count || (self.myCostSectionsArr.count==0 && section==0)) {//我的缴费
        if ([self.saveShouFangNumArr[section] boolValue] == NO) {//no散开状态 yes=折叠状态
            LifeCostMainVcTopGroupSectionModel *myCostWithGroupModel = self.myCostSectionsArr[section];
            return myCostWithGroupModel.accountEntityList.count+1;
        }else{
            return 1;//折叠(只有一个headerCell)
        }
    }else{//新增缴费
        return 2;//toprop+otherRow
    }
        
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return H_SectionHeaderCell;
    }else{
        if (indexPath.section<self.myCostSectionsArr.count || (self.myCostSectionsArr.count==0 && indexPath.section==0)) {//我的缴费
            return H_MyCostCell;
        }else{
            return H_PayTypeNewItemOneCellH*(self.myNewPayTypeArr.count%3 == 0 ? self.myNewPayTypeArr.count/3 : self.myNewPayTypeArr.count/3+1)+20;//新增缴费总h
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section<self.myCostSectionsArr.count || (self.myCostSectionsArr.count==0 && indexPath.section==0)) {//我的缴费
            LifeCostMainVcTopGroupSectionModel *groupSectionModel = self.myCostSectionsArr[indexPath.section];

        if (indexPath.row == 0) {//我的缴费
            LifeCostMyCostSectionHeaderTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:LifeCostMyCostSectionHeaderTableViewCell_Identifier];
            if (!cell) {
                cell = [[LifeCostMyCostSectionHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostMyCostSectionHeaderTableViewCell_Identifier];
            }
            WEAKSELF
            [cell fillBtnShowAddressStr: [TextShowWithModelStr textShowWithNotNullStr:groupSectionModel.groupName]];
            [cell fillBtnShowSouFangBool:[weakSelf.saveShouFangNumArr[indexPath.section] boolValue]];
            cell.editBtnBlock = ^{
                [weakSelf editSectionInfoWithSectionNum:indexPath.section];
            };
            cell.souFangBtnBlock = ^{
                [weakSelf souFangSectionNum:indexPath.section];
            };
            return cell;
        }else{
            LifeCostMyCostTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:LifeCostMyCostTableViewCell_Identifier];
            if (!cell) {
                cell = [[LifeCostMyCostTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostMyCostTableViewCell_Identifier];
            }
            LifeCostMainVcTopGroupSubAccountEntityModel *entityModel = groupSectionModel.accountEntityList[indexPath.row-1];
            [cell fillDataWithModel:entityModel]; 
            return cell;
        }
    }else { //新增缴费
        if (indexPath.row==0) {
            LifeCostPayTypeHeaderTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:LifeCostPayTypeHeaderTableViewCell_Identifier];
            if (!cell) {
                cell = [[LifeCostPayTypeHeaderTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostPayTypeHeaderTableViewCell_Identifier];
            }
            [cell fillHeaderCellCityNameWithStr:[LifeCostSaveCityInfoModel share].cityName];
            WEAKSELF
            cell.headerCellCityChangeBtnBlock = ^{
                [weakSelf goToChangeCityVc];
            };
            return cell;
        }else{
            LifeCostNewCostTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:LifeCostNewCostTableViewCell_Identfier];
            if (!cell) {
                cell = [[LifeCostNewCostTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:LifeCostNewCostTableViewCell_Identfier];
            }
            cell.delegate = self;
            cell.dataSourceArr = self.myNewPayTypeArr;
            return cell;
        }
      
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
        if (indexPath.section == [tableView numberOfSections]-1) {//最后一组(新增缴费)不做分割线
            addLine = NO;
        }
        if (addLine == YES) {
            CALayer *lineLayer = [[CALayer alloc] init];
            if (indexPath.row==0) {
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+0, bounds.size.height, bounds.size.width-0, 0.5);
            }else{
                lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+50, bounds.size.height, bounds.size.width-50, 0.5);
            }
            lineLayer.backgroundColor = [[ThemeManager shareManager].mainTextColor colorWithAlphaComponent:0.2].CGColor;
            [layer addSublayer:lineLayer];
        }
        UIView *testView = [[UIView alloc] initWithFrame:bounds];
        [testView.layer insertSublayer:layer atIndex:0];
        testView.backgroundColor = UIColor.clearColor;
        cell.backgroundView = testView;
    }
}


#pragma mark ==
- (void)footerViewChooseBtnWith:(LifeCostVcFooter_Btn_Type)btnType{
    switch (btnType) {
        case LifeCostVcFooter_Btn_Type_CostList://缴费列表记录
        {
            LifeCostPayHistoryOrderListVC *vc = [[LifeCostPayHistoryOrderListVC alloc]init];
            vc.nowPayTypeList = self.myNewPayTypeArr;//全部类型列表传入 用作类型筛选项
            [self pushVc:vc];
        }
            break;
            
        case LifeCostVcFooter_Btn_Type_CostSet://缴费设置
        {
            Y_SVP_SHOW_INFO_MES(@"当前社区暂未开放");
         
        }
             
            break;
        case LifeCostVcFooter_Btn_Type_CostCardIdManager:
        {
            NSLog(@"户号管理");
            ZYLifeCostHouseholdVC *vc = [[ZYLifeCostHouseholdVC alloc] init];
            [self pushVc:vc];
        }
             
            break;
        case LifeCostVcFooter_Btn_Type_Help:
        {
            Y_SVP_SHOW_INFO_MES(@"当前社区暂未开放");
//            ZYLifeCostHelpCenterVC *vc = [[ZYLifeCostHelpCenterVC alloc] init];
//            [self pushVc:vc];
        }
             
            break;
            
        default:
            break;
    }
}

#pragma mark - YMCitySelectDelegate
- (void)ym_ymCitySelectCityName:(NSString *)cityName {
    
    NSLog(@"%@", cityName);
    [LifeCostSaveCityInfoModel share].cityName = cityName;
    [self cityChangeWithUpDataLastSectionInfo];
}

@end
