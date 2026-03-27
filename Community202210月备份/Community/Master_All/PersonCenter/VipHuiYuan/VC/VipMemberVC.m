//
//  VipHuiYuanVC.m
//  Community
//
//  Created by 余莹 on 2021/2/3.
//

#import "VipMemberVC.h"
#import "BuyRecordVc.h"

#import "VipMemberHeaderView.h"
#import "VipMamberOneTableViewCell.h"
#define  VipMamberOneTableViewCell_Identifier      @"VipMamberOneTableViewCell"
#import "VipMamberTwoTableViewCell.h"
#define  VipMamberTwoTableViewCell_Identifier      @"VipMamberTwoTableViewCell"
#import "VipMamberThrTableViewCell.h"
#define  VipMamberThrTableViewCell_Identifier      @"VipMamberThrTableViewCell"
#import "VipMamberFourTableViewCell.h"
#define  VipMamberFourTableViewCell_Identifier      @"VipMamberFourTableViewCell"

@interface VipMemberVC () <VipMamberTableViewCellBaseDelegate>
@property (nonatomic,strong) VipMemberHeaderView *heeaderView;
@end

@implementation VipMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会员中心";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = Y_RGBA(245, 245, 245, 1);
    self.tableView.tableHeaderView = self.heeaderView;
    [self initNavRightItem];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupNavigationBarTextColor:[UIColor blackColor] andBarItemsColor:[UIColor blackColor] andBackViewCustomColor:Y_RGBA(254, 225, 173, 1)];//Collor_VipBackView
}
 

- (void)initNavRightItem{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"购买记录" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    [self.navigationItem setRightBarButtonItems:@[rightItem]];
}
- (void)rightBtnAction:(UIButton *)sender{
    DLog(@"购买记录");
    BuyRecordVc *vc = [[BuyRecordVc alloc]init];
    [self pushVc:vc];
}
#pragma mark - -  -  -  -
- (void)baseTouchUpCollectionCellSection:(NSInteger)section andIndex:(NSInteger)item withSelfTableViewCellType:(VipMamberTableViewCell_Type)cellType{
    NSString *str = [NSString stringWithFormat:@"cellType=%lu   section=%ld    item=_%ld",(unsigned long)cellType,section,item];
    switch (cellType) {
        case VipMamberTableViewCell_Type_One:
        {
            Y_SVP_SHOW_INFO_MES(str);
        }
            break;
        case VipMamberTableViewCell_Type_Two:
        {
            Y_SVP_SHOW_INFO_MES(str);
        }
            break;
        case VipMamberTableViewCell_Type_Thr:
        {
            Y_SVP_SHOW_INFO_MES(str);
        }
            break;
        case VipMamberTableViewCell_Type_Four:
        {
            Y_SVP_SHOW_INFO_MES(str);
        }
            break;
        case VipMamberTableViewCell_Type_NotCell_IsHeaderView://headerView
        {
            Y_SVP_SHOW_INFO_MES(str);
        }
            break;
        default:
            
            break;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 87+60;
    }else if (indexPath.section==1) {
        return (150*2+30+60);
    }else if (indexPath.section==2) {
        return (100+60);
    }else{
        return 170*2+60+40;
    }
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
    if (indexPath.section==0) {
        VipMamberOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VipMamberOneTableViewCell_Identifier];
        if (!cell) {
            cell = [[VipMamberOneTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:VipMamberOneTableViewCell_Identifier];
        }
        cell.delegate = self;
        cell.tipL.text = [NSString stringWithFormat:@"特权%ld",(long)indexPath.section+1];
        cell.titleL.text = @"每月享20元会员红包";
        return cell;
    }else if (indexPath.section==1) {
        VipMamberTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VipMamberTwoTableViewCell_Identifier];
        if (!cell) {
            cell = [[VipMamberTwoTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:VipMamberTwoTableViewCell_Identifier];
        }
        cell.delegate = self;
        cell.tipL.text = [NSString stringWithFormat:@"特权%ld",(long)indexPath.section+1];
        cell.titleL.text = @"会员红包可升级大额商家红包";
        return cell;
    }else if (indexPath.section == 2){
        
        VipMamberThrTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VipMamberThrTableViewCell_Identifier];
        if (!cell) {
            cell = [[VipMamberThrTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:VipMamberThrTableViewCell_Identifier];
        }
        cell.delegate = self;
        cell.tipL.text = [NSString stringWithFormat:@"特权%ld",(long)indexPath.section+1];
        cell.titleL.text = @"购买红包加量包，专享价";
        return cell;
    }else{
        
        VipMamberFourTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:VipMamberFourTableViewCell_Identifier];
        if (!cell) {
            cell = [[VipMamberFourTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:VipMamberFourTableViewCell_Identifier];
        }
        cell.delegate = self;
        cell.tipL.text = [NSString stringWithFormat:@"特权%ld",(long)indexPath.section+1];
        cell.titleL.text = @"会员专享特价商品，低至";
        return cell;
    }
    
}
 
#pragma mark ==
- (VipMemberHeaderView *)heeaderView{
    if (!_heeaderView) {
        _heeaderView = [[VipMemberHeaderView alloc]initWithFrame:CGRectZero];
        _heeaderView.headerViewDelegate = self;
    }
    return _heeaderView;
}
@end
